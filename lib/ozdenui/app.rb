# Bismillah
#
# app.rb - ozdenui v0.1 (OzdenUI: basic.js for Ruby)
# The window, the tasks of the program and the commands that go to the page.
#
# Threads:
# - The main thread runs the window (macOS wants the first thread of the program).
# - The app thread runs the code of the program: the block of run, every event, every timer and ui { } task, one at a
#   time. The code of the program never needs a lock.
# - The server (server.rb) takes the messages of the page on threads of its own: they only put a task in the queue.
#
# The commands of a task are sent to the page together, when the task ends (flush): one message for a whole window,
# not one for each object.
#
# Started Date: November 2026
# Webpage: https://bug7a.github.io/ozdenui-ruby/
#
# Copyright 2026 Bugra Ozden <bugra.ozden@gmail.com> (https://bug7a.github.io/)
# Licensed under the Apache License, Version 2.0
# SPDX-License-Identifier: Apache-2.0

module OzdenUI
  # What the gem is made of. A program uses the methods of OzdenUI; these classes are behind them.
  module Runtime
    # A time that runs later (after) or again and again (every): timer.stop ends it.
    class Timer
      MIN_REPEAT = 0.001 # WHY: every(0) would spin a whole CPU core

      # @api private
      def initialize(app, milliseconds, repeat, task)
        @app = app
        @stopped = false
        @queued = false # WHY: a slow task must not pile up ticks in the queue
        seconds = [milliseconds.to_f / 1000, 0].max
        seconds = [seconds, MIN_REPEAT].max if repeat
        @thread = Thread.new do
          next_at = Process.clock_gettime(Process::CLOCK_MONOTONIC)
          loop do
            # WHY from the time before: a clock that sleeps "a second" after every tick falls behind
            next_at = [next_at + seconds, Process.clock_gettime(Process::CLOCK_MONOTONIC)].max
            wait = next_at - Process.clock_gettime(Process::CLOCK_MONOTONIC)
            sleep(wait) if wait.positive?
            break if @stopped || app.closed?
            unless @queued
              @queued = true
              app.tasks.put(proc do
                @queued = false
                task.call unless @stopped
              end)
            end
            break unless repeat
          end
          app.forget_timer(self)
        end
      end

      def stop
        @stopped = true
        @app.forget_timer(self)
        nil
      end
      alias cancel stop

      def stopped?
        @stopped
      end
    end

    # @api private
    class TaskQueue
      def initialize
        @tasks = []
        @mutex = Mutex.new
        @condition = ConditionVariable.new
        @closed = false
      end

      def put(task)
        @mutex.synchronize do
          @tasks << task
          @condition.signal
        end
      end

      def close
        @mutex.synchronize do
          @closed = true
          @condition.broadcast
        end
      end

      # The next task; nil when the window is closed.
      def get
        @mutex.synchronize do
          @condition.wait(@mutex) while @tasks.empty? && !@closed
          @closed ? nil : @tasks.shift
        end
      end
    end

    # Something that happens once, and the threads that wait for it.
    # @api private
    class Latch
      def initialize
        @mutex = Mutex.new
        @condition = ConditionVariable.new
        @set = false
      end

      def set
        @mutex.synchronize do
          @set = true
          @condition.broadcast
        end
      end

      def set?
        @mutex.synchronize { @set }
      end

      # true when it happened before the time was over (nil: no end).
      def wait(seconds = nil)
        ends_at = seconds && Process.clock_gettime(Process::CLOCK_MONOTONIC) + seconds
        @mutex.synchronize do
          until @set
            left = ends_at && ends_at - Process.clock_gettime(Process::CLOCK_MONOTONIC)
            return false if left && left <= 0
            @condition.wait(@mutex, left)
          end
          true
        end
      end
    end

    # An answer the code waits for (a dialog): from the page, or nil when it can not come. Only the first one counts.
    # @api private
    class Answer
      attr_reader :value

      def initialize
        @given = false
        @value = nil
      end

      def give(value)
        return if @given
        @value = value
        @given = true
      end

      def given?
        @given
      end
    end

    # @api private
    class App
      READY_TIMEOUT = 15
      DARK_PAGE_COLOR = "#1C1C1B"
      EARLY_PAGE_COLOR = "ozdenui-page-color:" # window.name of a page loaded again for another theme (bridge.js)
      RELOAD_DELAY_MS = 50                     # the page of set_theme loads itself again this much after the script that asks it
      ACCENT_STYLE_NAME = "minimalAccent"
      THEMES = %w[light dark auto].freeze
      OPTION_NAMES = %i[title width height theme style accent accent_dark language debug icon].freeze

      attr_reader :options, :theme, :server, :tasks, :objects, :leaving, :callbacks, :page, :ready, :drawn, :basic_version
      attr_accessor :control, :containers

      def initialize(options, start)
        @options = { title: "OzdenUI", width: 800, height: 600, theme: "light", style: nil }.merge(options)
        @options[:theme] = @options[:theme].to_s
        @options[:style] = @options[:style].to_s if @options[:style]
        # A picture of the dark window without a change of the program (OZDENUI_LOOK)
        @options[:theme] = ENV["OZDENUI_THEME"] unless ENV["OZDENUI_THEME"].to_s.empty?
        check_options
        @start = start
        @wanted_theme = @options[:theme]
        @theme = @wanted_theme == "dark" ? "dark" : "light"
        @tasks = TaskQueue.new
        @ready = Latch.new  # the page said it is ready for the first time
        @closed = Latch.new # the window is gone
        @drawn = Latch.new  # the first drawing of the program is on the page
        @commands = []
        @containers = [] # the open boxes of the task that runs: the last one takes the new objects
        @objects = {}
        @leaving = {}    # objects the page removed, until the events they sent before are handled
        @callbacks = {}  # id -> [block, owner id]
        @failed_ids = {} # the objects the page could not make (an answer that belongs to one is nil)
        @answers = {}
        @timers = []
        @timers_mutex = Mutex.new
        @ready_mutex = Mutex.new
        @is_ready = false
        @next_object = 0
        @next_callback = 0
        @prefers_dark = false
        @page_width = @options[:width]
        @page_height = @options[:height]
        @loading_for_theme = false
        @has_started = false
        @warned = {}
      end

      def check_options
        unknown = @options.keys - OPTION_NAMES
        unless unknown.empty?
          raise Error, "run(#{unknown.first}: ...): the window takes #{OPTION_NAMES.map { |name| "#{name}:" }.join(', ')}"
        end
        theme, style = @options.values_at(:theme, :style)
        raise Error, %(run(theme: #{theme.inspect}): it is "light", "dark" or "auto") unless THEMES.include?(theme)
        raise Error, %(run(style: #{style.inspect}): it is nil or "minimal") unless style.nil? || style == "minimal"
        raise Error, "run(accent_dark: ...): it goes with accent:" if @options[:accent_dark] && !@options[:accent]
        return unless @options[:accent] && style != "minimal"
        raise Error, %(run(accent: ...): the color of the minimal look; give style: "minimal" too)
      end

      # Opens the window and returns when it is closed.
      def run
        @server = Server.new(self)
        @app_thread = Thread.new { run_app_thread }
        Window.open(self, @server.address)
      ensure
        on_window_closed
        @server&.stop
        @app_thread&.join(1)
      end

      def closed?
        @closed.set?
      end

      def closed_latch
        @closed
      end

      def dark?
        @theme == "dark"
      end

      def minimal?
        @options[:style] == "minimal"
      end

      # *** TIMERS:

      def new_timer(milliseconds, repeat, task)
        timer = Timer.new(self, milliseconds, repeat, task)
        @timers_mutex.synchronize { @timers << timer unless timer.stopped? }
        timer
      end

      def forget_timer(timer)
        @timers_mutex.synchronize { @timers.delete(timer) }
      end

      def stop_timers
        timers = @timers_mutex.synchronize { @timers.dup }
        timers.each(&:stop)
      end

      # *** THE APP THREAD:

      def run_app_thread
        unless @ready.wait(READY_TIMEOUT) || closed?
          warn_plain("the page is not ready yet (basic.js or the bridge did not load)")
          # WHY it goes on waiting: a page that comes late on a slow computer must still start the program
          sleep(0.05) until @ready.set? || closed?
        end
        return if closed?
        run_task(method(:start_page))
        @drawn.set
        run_tasks_until { false }
      rescue SystemExit
        # WHY: exit in a block of the program ends only this thread; the window would stay open with nobody behind it
        @control&.close
      end

      def start_page
        @has_started = true
        make_page
        add_accent_packages
        Values.call_handler(@start, [@page])
      end

      def make_page
        @page = UIObject.new(self, "page", :page)
        @page.become_page(@page_width, @page_height)
        @page.set(color: DARK_PAGE_COLOR) if dark?
      end

      def add_accent_packages
        return unless @options[:accent]
        flush
        @server.request("kind" => "accent", "name" => ACCENT_STYLE_NAME, "color" => @options[:accent],
                        "colorDark" => @options[:accent_dark].to_s)
      rescue PageGone, Error => error
        warn_plain("run(accent: ...): #{error.message}")
      end

      def run_tasks_until
        until yield
          task = @tasks.get
          return unless task
          run_task(task)
        end
      end

      def run_task(task)
        # WHY its own open boxes: a task that runs while another one waits for a dialog (a click, a timer) would make its
        #      objects in the open box of that one; a task that failed in a box leaves nothing open either.
        outer = @containers
        @containers = []
        begin
          task.call
        rescue StandardError, ScriptError => error
          # WHY not the end of the program: one block that failed must not close the window with the work in it
          trace = Values.program_trace(error)
          $stderr.puts "ozdenui: a task failed: #{error.message} (#{error.class})", trace.map { |line| "    #{line}" }
        end
        @containers = outer
        flush
      end

      # Runs the other tasks until the block is true: the code that waits (a dialog) keeps the window working.
      def wait_for
        flush
        run_tasks_until { yield || closed? }
      end

      def app_thread?
        Thread.current == @app_thread
      end

      def check(what)
        return if app_thread?
        raise Error, "#{what} works only in the block of run, an event or a timer. From another thread: ui { ... }"
      end

      # *** THE COMMANDS:

      def send_command(command)
        check(command["op"])
        @commands << command
      end

      def flush
        return if @commands.empty? || closed? || @loading_for_theme
        commands = @commands
        @commands = []
        after_apply(@server.request("kind" => "apply", "commands" => commands))
      rescue PageGone
        nil # the page is gone (closed, loaded again): its commands go with it
      rescue Error => error
        warn_plain(error.message)
      end

      def after_apply(result)
        return unless result.is_a?(Hash)
        (result["errors"] || []).each do |problem|
          id = problem["id"].to_s
          where = "#{problem['op']} #{id}".strip
          where = "#{problem['src']}: #{where}" unless problem["src"].to_s.empty?
          warn_plain("#{where}: #{problem['message']}")
          give_up_answer_of(id) if problem["op"] == "create" && !id.empty?
        end
        removed = result["removed"] || []
        return if removed.empty?
        removed.each do |id|
          object = @objects.delete(id)
          @leaving[id] = object if object
        end
        # WHY later: a component sends an event and then leaves the page (a Dialog: onClose, then remove()). The events
        #     the page sent before this answer are already in the queue: the task that forgets comes after them.
        @tasks.put(proc { forget_removed(removed) })
      end

      # WHY: the blocks given to a removed object would be kept for ever (a list made again every second grows).
      def forget_removed(removed)
        removed.each { |id| @leaving.delete(id) }
        @callbacks.delete_if { |_id, entry| removed.include?(entry[1]) }
      end

      def give_up_answer_of(id)
        @failed_ids[id] = true
        @answers[id]&.give(nil)
      end

      def new_id
        "o#{@next_object += 1}"
      end

      def register_callback(handler, owner_id)
        id = "c#{@next_callback += 1}"
        @callbacks[id] = [handler, owner_id]
        id
      end

      def container_id
        @containers.last || "page"
      end

      # Calls a function of a component (Toast.show, Dialog.confirm). wait: the function gives a Promise; its value is
      # returned, and the window keeps working while the code waits for it. keep: the id of the object that stands for
      # what the function returns (a bubble).
      def call_static(target, method, args, wait: false, keep: nil)
        command = { "op" => "static", "target" => target, "method" => method, "args" => args, "src" => Values.source_line }
        command["keep"] = keep if keep
        unless wait
          send_command(command)
          return nil
        end
        pending = Answer.new
        id = register_callback(proc { |value| pending.give(value) }, "")
        command["answer"] = id
        send_command(command)
        value = wait_for_answer(id, pending)
        @callbacks.delete(id)
        value
      end

      # Waits for an answer (the window keeps working). key: the callback id of the answer, or the id of the object that
      # gives it (a Dialog). It is nil when it can not come: the object could not be made, the page was loaded again or
      # the window was closed.
      def wait_for_answer(key, pending)
        @answers[key] = pending
        wait_for do
          pending.give(nil) if @failed_ids[key]
          pending.given?
        end
        pending.value
      ensure
        @answers.delete(key)
      end

      def read(id, key)
        flush
        ruby_value(@server.request("kind" => "read", "id" => id, "key" => key))
      end

      def ask(id, method, args)
        flush
        ruby_value(@server.request("kind" => "ask", "id" => id, "method" => method, "args" => args))
      end

      def evaluate(script)
        check("evaluate")
        flush
        ruby_value(@server.request("kind" => "eval", "script" => script))
      rescue PageGone, Error => error
        warn_at("evaluate: #{error.message}")
        nil
      end

      # *** FROM THE PAGE (the threads of the server; they only queue tasks):

      def on_page_ready(message)
        is_first = @ready_mutex.synchronize do
          first = !@is_ready
          @is_ready = true
          first
        end
        if is_first
          take_ready(message)
          @ready.set
          return
        end
        # The page was loaded again (set_theme, the reload of the developer tools): its objects are gone, the block of
        # run makes them again.
        @tasks.put(proc do
          take_ready(message)
          start_again
        end)
      end

      def take_ready(message)
        @basic_version = message["basicVersion"]
        @page_width = message["width"]
        @page_height = message["height"]
        @prefers_dark = message["prefersDark"] ? true : false
        @theme = @prefers_dark ? "dark" : "light" if @wanted_theme == "auto"
      end

      def on_page_event(target, event, data)
        @tasks.put(proc { dispatch(target, event, data.is_a?(Hash) ? data : Data.new) })
      end

      def dispatch(target, event, data)
        case event
        when "callback" then run_callback(target, data)
        when "__message" then $stderr.puts "ozdenui (page #{data['kind']}): #{data['text']}"
        else @objects[target]&.receive_event(event, data) # nil: an event of an object removed in the meantime
        end
      end

      def run_callback(id, data)
        handler, owner_id = @callbacks[id]
        return unless handler
        owner = @objects[owner_id] || @leaving[owner_id]
        owner.take_state(data["state"]) if owner && data["state"].is_a?(Hash)
        args = (data["args"] || []).map { |value| ruby_value(value) }
        Values.call_handler(handler, args)
      end

      # A value from the page: a basic.js object becomes its object of the program; JSON data that came whole (the
      # wholeArgs of a callback) becomes its value.
      def ruby_value(value)
        case value
        when Hash
          return object_value(value) if value.key?("__bpObject")
          return JSON.parse(value["__bpJson"], object_class: Data) if value["__bpJson"].is_a?(String)
          value.each { |key, item| value[key] = ruby_value(item) }
        when Array
          value.map! { |item| ruby_value(item) }
        else
          value
        end
      rescue JSON::ParserError
        nil
      end

      # A basic.js object from the page: its object, or { "id", "data" } for a part of a component (a row of a list), or nil.
      def object_value(value)
        id = value["__bpObject"]
        known = id.is_a?(String) ? (@objects[id] || @leaving[id]) : nil
        return known if known
        rest = Data.new
        value.each { |key, item| rest[key] = ruby_value(item) unless key == "__bpObject" }
        rest.empty? ? nil : rest
      end

      # *** ANOTHER THEME, A PAGE LOADED AGAIN:

      # WHY the page is loaded again: a component takes its look when it is made, and a new page keeps nothing of the
      # old one (an open menu or bubble, a listener of a component).
      # WHY window.name: it stays over the load, so the new page has the ground of its theme from its first drawing.
      def change_theme(theme)
        return if closed? || theme == @wanted_theme
        @wanted_theme = theme
        theme = @prefers_dark ? "dark" : "light" if theme == "auto" # the page tells it again when it is ready
        @theme = theme
        stop_timers # WHY: a tick would send its commands to a page that is being loaded
        color = theme == "dark" ? DARK_PAGE_COLOR : ""
        flush
        @loading_for_theme = true
        name = JSON.generate(EARLY_PAGE_COLOR + color)
        script = "window.name = #{name}; setTimeout(function () { location.reload(); }, #{RELOAD_DELAY_MS}); 0"
        begin
          @server.request("kind" => "eval", "script" => script)
        rescue PageGone, Error
          nil
        end
      end

      def start_again
        if @loading_for_theme
          @loading_for_theme = false # WHY no word: the program asked for the new page (set_theme)
        elsif @has_started
          warn_plain("the page was loaded again: the block of run runs again")
        end
        # WHY: the dialogs of the old page are gone; the code that waits for one of them gets nil
        @answers.each_value { |pending| pending.give(nil) }
        @failed_ids = {}
        stop_timers
        @commands = []
        @objects = {}
        @leaving = {}
        @callbacks = {}
        start_page
      end

      def on_window_closed
        return if closed?
        @closed.set
        @tasks.close
        stop_timers
      end

      # The title of the page: the title of a browser window, and what the system lists.
      def title=(title)
        @options[:title] = title.to_s
        @control&.title = title.to_s
        script = "document.title = #{JSON.generate(title.to_s)}; 0"
        @tasks.put(proc do
          begin
            @server.request("kind" => "eval", "script" => script)
          rescue PageGone, Error
            nil
          end
        end)
      end

      # *** WORDS TO THE TERMINAL:

      # Tells once in the terminal, at the line of the program.
      def warn_at(text)
        text = "#{Values.source_line}: #{text}".sub(/\A: /, "")
        return if @warned[text]
        @warned[text] = true
        $stderr.puts "ozdenui: #{text}"
      end

      def warn_plain(text)
        $stderr.puts "ozdenui: #{text}"
      end
    end
  end

  @app = nil

  class << self
    # @api private
    attr_reader :app

    # @api private
    def current_app
      @app || raise(Runtime::Error, "make the objects in the block of run: OzdenUI.run(title: \"...\") { ... }")
    end

    # @api private
    def warning(text)
      @app ? @app.warn_at(text) : $stderr.puts("ozdenui: #{text}")
    end
  end

  module_function

  # Opens the window, runs the block when its page is ready (the block may take the page) and returns when the window
  # is closed. Call it once, at the end of the program.
  #
  #   OzdenUI.run(title: "Counter", width: 360, height: 260) do |page|
  #     Label(text: "Hello")
  #   end
  #
  # title:, width:, height:; theme: "light" (default), "dark" or "auto" (what the system asks); style: "minimal" (small,
  # made of lines); accent: a color of the minimal look ("#2A78D6"), accent_dark: its color in a dark window;
  # language: the language of the texts ("tr": capital letters, word breaks); debug: true (the developer tools of the
  # web view); icon: a PNG for the Dock of macOS.
  def run(start = nil, **options, &block)
    start ||= block
    raise Runtime::Error, "run takes a block (or a method: run(method(:start))) that makes the objects" unless Runtime::Values.callable?(start)
    raise Runtime::Error, "run is called once in a program" if OzdenUI.app
    app = Runtime::App.new(options, start)
    OzdenUI.instance_variable_set(:@app, app)
    app.run
    nil
  rescue Interrupt
    nil # Ctrl+C in the terminal closes the window, as its red button does
  end

  # Closes the window (from any thread); run returns.
  def close
    app = OzdenUI.current_app
    app.control ? app.control.close : app.tasks.put(proc { app.control&.close })
    nil
  end

  # Changes the title of the window.
  def set_title(title)
    OzdenUI.current_app.title = title
    nil
  end

  # The theme of the window: "light" or "dark".
  def theme
    OzdenUI.current_app.theme
  end

  # true in a dark window: color = dark? ? "#9AA3B5" : "#5A6270"
  def dark?
    OzdenUI.current_app.dark?
  end

  # Draws the window again in another theme: "light", "dark" or "auto" (what the system asks). The page is made again
  # and the block of run runs again, as when the window opened: its objects start again (a text typed in a field is
  # gone), what the program keeps in its own variables stays. Any thread may call it; the change comes after the task
  # that runs now.
  def set_theme(theme)
    theme = theme.to_s
    raise Runtime::Error, %(set_theme(#{theme.inspect}): it is "light", "dark" or "auto") unless Runtime::App::THEMES.include?(theme)
    app = OzdenUI.current_app
    app.tasks.put(proc { app.change_theme(theme) })
    nil
  end

  # Runs the block on the thread of the window, after the task that runs now. Any thread may call it: it is the way a
  # thread of the program (a download, a long job) changes the objects.
  #
  #   Thread.new do
  #     text = download            # the window does not wait for it
  #     ui { label.text = text }
  #   end
  def ui(&task)
    raise Runtime::Error, "ui takes a block: ui { label.text = text }" unless task
    OzdenUI.current_app.tasks.put(task)
    nil
  end

  # Runs the block once, after a time (milliseconds). It returns a timer: timer.cancel.
  def after(milliseconds, &task)
    raise Runtime::Error, "after takes a block: after(3000) { ... }" unless task
    OzdenUI.current_app.new_timer(milliseconds, false, task)
  end

  # Runs the block again and again (the loop() of basic.js). It returns a timer: timer.stop.
  def every(milliseconds, &task)
    raise Runtime::Error, "every takes a block: every(1000) { ... }" unless task
    OzdenUI.current_app.new_timer(milliseconds, true, task)
  end

  # Sends the waiting commands to the page now: a long task can show its progress.
  def flush
    app = OzdenUI.current_app
    app.check("flush")
    app.flush
    nil
  end

  # Runs JavaScript on the page and returns its value (after the waiting commands).
  def evaluate(script)
    OzdenUI.current_app.evaluate(script)
  end

  # The page of the window (what the block of run gets): page.color = "...", page.on(:key_down) { ... }, page.width.
  def page
    OzdenUI.current_app.page
  end

  # Reads a flag that came from the page (the kit writes its flags as 1 / 0): true for 1, true and a text that is not empty.
  def on?(value)
    Runtime::Values.on?(value)
  end

  # How a component writes its numbers, where a param does not take the text itself: a text around one {} place.
  #
  #   "{:,.2f} TL"   1,234.50 TL      "{:.0f} kg"   12 kg      "{:.1%}"   12.3%      "$ {:,}"   $ 1,234
  #
  # WHY not a block of the program: the page draws at once; the answer of the program would come too late.
  def number_format(pattern)
    Runtime::Values.number_format(pattern)
  end

  # The address of a picture for the page: of a file of this computer ("photo.png"), of the text of an SVG or of bytes
  # (File.binread, a PNG made by the program). An address of the web stays as it is. A param of a component that names
  # a file (icon_file:, image_file:) and the picture: of an Icon take a path by themselves; picture() is for the other
  # places (the "icon" of an item of a list, a picture in a style).
  def picture(source)
    Runtime::Values.picture(source)
  end
end
