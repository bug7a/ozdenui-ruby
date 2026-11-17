# Bismillah
#
# window.rb - ozdenui v0.1 (OzdenUI: basic.js for Ruby)
# Opens the window of the program and returns when it is closed: the web view of macOS (window_cocoa.rb), an app
# window of Chrome or Edge (no address bar, no tabs) or, for a picture or a check, a hidden browser (look.rb).
#
# OZDENUI_WINDOW: "browser" (an app window of Chrome or Edge also on macOS), "tab" (a tab of the default browser),
# "headless" (no window: a check). OZDENUI_BROWSER: the path of the browser. OZDENUI_LOOK: see look.rb.
#
# Started Date: November 2026
# Webpage: https://bug7a.github.io/ozdenui-ruby/
#
# Copyright 2026 Bugra Ozden <bugra.ozden@gmail.com> (https://bug7a.github.io/)
# Licensed under the Apache License, Version 2.0
# SPDX-License-Identifier: Apache-2.0

require "tmpdir"
require "fileutils"
require "rbconfig"

module OzdenUI
  # What the gem is made of. A program uses the methods of OzdenUI; these classes are behind them.
  module Runtime
    # @api private
    module Window
      STREAM_GONE_AFTER = 1.5 # a page that does not listen this long is a closed window

      module_function

      def open(app, address)
        mode = ENV["OZDENUI_WINDOW"].to_s
        return Look.open(app, address) if !ENV["OZDENUI_LOOK"].to_s.empty? || mode == "headless"
        return if mode.empty? && open_native(app, address)
        BrowserWindow.new(app).open(address, mode == "tab")
      end

      # true when the window of the system was opened (and is closed now).
      def open_native(app, address)
        return false unless Dialogs.system_name == :mac
        require_relative "window_cocoa"
        CocoaWindow.new(app).open(address)
        true
      rescue LoadError, Fiddle::DLError => error
        # WHY it goes on: without fiddle (a Ruby built without it, a Gemfile that does not list it) the program still
        #     works, in a window of the browser
        $stderr.puts "ozdenui: the web view of macOS could not be used (#{error.message}): the window of a browser opens"
        false
      end

      def cache_folder
        base = case Dialogs.system_name
               when :mac then File.join(Dir.home, "Library", "Caches")
               when :windows then ENV["LOCALAPPDATA"] || Dir.tmpdir
               else ENV["XDG_CACHE_HOME"] || File.join(Dir.home, ".cache")
               end
        File.join(base, "ozdenui")
      rescue ArgumentError
        File.join(Dir.tmpdir, "ozdenui")
      end

      def program_name
        File.basename($PROGRAM_NAME, ".*").gsub(/[^A-Za-z0-9-]/, "_")
      end

      # A browser of this computer that opens an app window (Chromium kind): Edge is on every Windows.
      def find_browser
        given = ENV["OZDENUI_BROWSER"].to_s
        return given unless given.empty?
        candidates = []
        case Dialogs.system_name
        when :mac
          ["Google Chrome", "Microsoft Edge", "Chromium", "Brave Browser"].each do |name|
            candidates << "/Applications/#{name}.app/Contents/MacOS/#{name}"
            candidates << File.join(Dir.home, "Applications", "#{name}.app", "Contents", "MacOS", name)
          end
        when :windows
          [ENV["ProgramFiles(x86)"], ENV["ProgramFiles"], ENV["LocalAppData"]].compact.each do |root|
            candidates << File.join(root, "Microsoft", "Edge", "Application", "msedge.exe")
            candidates << File.join(root, "Google", "Chrome", "Application", "chrome.exe")
          end
        else
          folders = ENV["PATH"].to_s.split(File::PATH_SEPARATOR)
          %w[google-chrome google-chrome-stable chromium chromium-browser microsoft-edge brave-browser].each do |name|
            folders.each { |folder| candidates << File.join(folder, name) }
          end
        end
        candidates.find { |path| File.executable?(path) && !File.directory?(path) }
      end

      def open_in_default_browser(address)
        command = case Dialogs.system_name
                  when :mac then ["open", address]
                  when :windows then ["rundll32", "url.dll,FileProtocolHandler", address]
                  else ["xdg-open", address]
                  end
        Process.detach(Process.spawn(*command, out: File::NULL, err: File::NULL))
      end
    end

    # A window of a browser.
    # @api private
    class BrowserWindow
      def initialize(app)
        @app = app
        @done = Latch.new
        @mutex = Mutex.new
        @open_streams = 0
        @gone_at = nil
      end

      def title=(_title); end # the page changes its own title (set_title)

      def close
        return if @closing
        @closing = true
        # WHY the page closes itself: the process of the browser may be one that was already open
        Thread.new do
          begin
            @app.server.request("kind" => "eval", "script" => "window.close(); 0")
          rescue PageGone, Error
            nil
          end
        end
        Thread.new do
          sleep(0.3)
          @done.set
        end
      end

      def open(address, is_tab)
        @app.control = self
        watch_stream
        browser = is_tab ? nil : Window.find_browser
        pid = nil
        if browser
          # WHY a profile of the program: the browser is a process of its own then, which ends with the window (a
          #      browser that was already open would take the window into its process, with its tabs and its size)
          profile = File.join(Window.cache_folder, "browser-profile-#{Window.program_name}")
          begin
            FileUtils.mkdir_p(profile)
            pid = Process.spawn(browser, "--app=#{address}", "--window-size=#{@app.options[:width]},#{@app.options[:height]}",
                                "--user-data-dir=#{profile}", "--no-first-run", "--no-default-browser-check",
                                out: File::NULL, err: File::NULL)
          rescue SystemCallError
            pid = nil
          end
        end
        unless pid
          begin
            Window.open_in_default_browser(address)
          rescue SystemCallError => error
            $stderr.puts "ozdenui: no browser could be opened (#{error.message}). The page of the program: #{address}"
          end
        end
        @done.wait
      ensure
        end_process(pid) if pid # WHY: on macOS a browser without a window keeps running
      end

      private

      def end_process(pid)
        Process.kill(Dialogs.system_name == :windows ? "KILL" : "TERM", pid)
        Process.detach(pid)
      rescue SystemCallError
        nil
      end

      # The window is closed when the page stopped listening and did not come back (a closed tab or window; a page that
      # is loaded again comes back at once).
      def watch_stream
        @app.server.on_stream = lambda do |is_open|
          @mutex.synchronize do
            @open_streams += is_open ? 1 : -1
            @gone_at = @open_streams.zero? ? Process.clock_gettime(Process::CLOCK_MONOTONIC) : nil
          end
        end
        Thread.new do
          until @done.set?
            sleep(0.1)
            gone_at = @mutex.synchronize { @gone_at }
            @done.set if gone_at && Process.clock_gettime(Process::CLOCK_MONOTONIC) - gone_at > Window::STREAM_GONE_AFTER
          end
        end
      end
    end
  end
end
