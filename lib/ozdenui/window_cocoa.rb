# Bismillah
#
# window_cocoa.rb - ozdenui v0.1 (OzdenUI: basic.js for Ruby)
# The window of macOS: a window of the system with its web view (WKWebView), made with fiddle, the library of Ruby
# that calls the functions of the system. No gem and no compiler are needed.
#
# The main thread runs the events of the window. WHY its own loop and not [NSApp run]: between two events it does the
# small jobs the other threads ask for (a title, a close) and sees that the window was closed; the calls of fiddle
# leave Ruby free, so the thread of the program and the server work meanwhile. A thread that has a job for the window
# posts an event of its own, so the loop sleeps until something happens (a loop that looked every 10 ms took a
# tenth of a CPU core in a window nobody touched).
#
# Started Date: November 2026
# Webpage: https://bug7a.github.io/ozdenui-ruby/
#
# Copyright 2026 Bugra Ozden <bugra.ozden@gmail.com> (https://bug7a.github.io/)
# Licensed under the Apache License, Version 2.0
# SPDX-License-Identifier: Apache-2.0

require "fiddle"

module OzdenUI
  # What the gem is made of. A program uses the methods of OzdenUI; these classes are behind them.
  module Runtime
    # @api private
    class CocoaWindow
      POINTER = Fiddle::TYPE_VOIDP
      DOUBLE = Fiddle::TYPE_DOUBLE
      LONG = Fiddle::TYPE_LONG
      BOOL = Fiddle::TYPE_CHAR
      VOID = Fiddle::TYPE_VOID
      EVENT_WAIT = 0.5       # seconds the loop sleeps at most (Ctrl+C in the terminal is seen when it wakes)
      APPLICATION_EVENT = 15 # NSEventTypeApplicationDefined: the event that wakes the loop for a job
      EVENT_TYPES = [LONG, DOUBLE, DOUBLE, LONG, DOUBLE, LONG, POINTER, Fiddle::TYPE_SHORT, LONG, LONG].freeze
      STYLE_MASK = 1 | 2 | 4 | 8 # a title, and the buttons to close, to make small and to resize
      ALL_EVENTS = -1
      DEFAULT_ICON = File.join(__dir__, "icon.png")
      # The menus: without them Cmd+C / V / Q do nothing in a program that is not an app bundle.
      EDIT_ITEMS = [["Undo", "undo:", "z"], ["Redo", "redo:", "Z"], nil, ["Cut", "cut:", "x"], ["Copy", "copy:", "c"],
                    ["Paste", "paste:", "v"], ["Select All", "selectAll:", "a"]].freeze

      def initialize(app)
        @app = app
        @jobs = Queue.new
        @objc = Fiddle.dlopen("/usr/lib/libobjc.A.dylib")
        Fiddle.dlopen("/System/Library/Frameworks/AppKit.framework/AppKit")
        Fiddle.dlopen("/System/Library/Frameworks/WebKit.framework/WebKit")
        @get_class = Fiddle::Function.new(@objc["objc_getClass"], [POINTER], POINTER)
        @selector = Fiddle::Function.new(@objc["sel_registerName"], [POINTER], POINTER)
        @functions = {}
        @selectors = {}
      end

      def title=(title)
        ask_window { send_message(VOID, @window, "setTitle:", [POINTER], string(title)) }
      end

      def close
        ask_window { send_message(VOID, @window, "close") }
      end

      # Opens the window and returns when it is closed.
      def open(address)
        pool = new_pool
        make_window(address)
        @app.control = self
        mode = string("kCFRunLoopDefaultMode")
        send_message(POINTER, mode, "retain")
        drain(pool)
        loop do
          pool = new_pool
          run_events(mode)
          @jobs.pop.call until @jobs.empty?
          is_open = send_message(BOOL, @window, "isVisible") != 0 || send_message(BOOL, @window, "isMiniaturized") != 0
          drain(pool)
          break unless is_open
        end
      ensure
        # WHY: an error of the program in the loop (Ctrl+C) must not leave the window on the screen
        send_message(VOID, @window, "close") if @window
      end

      private

      # A job for the thread of the window, from any thread: the loop is woken to do it.
      def ask_window(&job)
        @jobs.push(job)
        pool = new_pool
        event = send_message(POINTER, class_named("NSEvent"),
                             "otherEventWithType:location:modifierFlags:timestamp:windowNumber:context:subtype:data1:data2:",
                             EVENT_TYPES, APPLICATION_EVENT, 0.0, 0.0, 0, 0.0, 0, nil, 0, 0, 0)
        send_message(VOID, @ns_app, "postEvent:atStart:", [POINTER, BOOL], event, 1)
        drain(pool)
      end

      # objc_msgSend with the types of this call. WHY a function for every set of types: the system reads the values of a
      # call by their types (a double is not where a pointer is).
      def send_message(returns, receiver, name, types = [], *values)
        function = (@functions[[returns, types]] ||= Fiddle::Function.new(@objc["objc_msgSend"], [POINTER, POINTER] + types, returns))
        function.call(receiver, selector(name), *values)
      end

      def selector(name)
        @selectors[name] ||= @selector.call(name)
      end

      def class_named(name)
        @get_class.call(name)
      end

      def create(class_name)
        send_message(POINTER, send_message(POINTER, class_named(class_name), "alloc"), "init")
      end

      def string(text)
        send_message(POINTER, class_named("NSString"), "stringWithUTF8String:", [POINTER], text.to_s.encode("UTF-8"))
      end

      def new_pool
        create("NSAutoreleasePool")
      end

      def drain(pool)
        send_message(VOID, pool, "drain")
      end

      def responds?(object, name)
        send_message(BOOL, object, "respondsToSelector:", [POINTER], selector(name)) != 0
      end

      def make_window(address)
        options = @app.options
        name_the_program(options[:title])
        @ns_app = send_message(POINTER, class_named("NSApplication"), "sharedApplication")
        send_message(VOID, @ns_app, "setActivationPolicy:", [LONG], 0) # a program with a Dock icon and a menu
        make_menus(options[:title])
        show_icon(options[:icon] || DEFAULT_ICON)

        @window = create("NSWindow")
        send_message(VOID, @window, "setReleasedWhenClosed:", [BOOL], 0)
        send_message(VOID, @window, "setStyleMask:", [LONG], STYLE_MASK)
        # WHY the content: the page is as large as the program asked, the title bar comes on top of it
        send_message(VOID, @window, "setContentSize:", [DOUBLE, DOUBLE], options[:width].to_f, options[:height].to_f)
        send_message(VOID, @window, "setTitle:", [POINTER], string(options[:title]))
        @web_view = create("WKWebView")
        allow_developer_tools if options[:debug]
        send_message(VOID, @window, "setContentView:", [POINTER], @web_view)
        url = send_message(POINTER, class_named("NSURL"), "URLWithString:", [POINTER], string(address))
        request = send_message(POINTER, class_named("NSURLRequest"), "requestWithURL:", [POINTER], url)
        send_message(POINTER, @web_view, "loadRequest:", [POINTER], request)
        send_message(VOID, @window, "center")
        send_message(VOID, @window, "makeKeyAndOrderFront:", [POINTER], nil)
        send_message(VOID, @window, "makeFirstResponder:", [POINTER], @web_view)
        send_message(VOID, @ns_app, "finishLaunching")
        send_message(VOID, @ns_app, "activateIgnoringOtherApps:", [BOOL], 1)
      end

      # WHY: the menu bar and the Dock would name the program "ruby".
      def name_the_program(title)
        bundle = send_message(POINTER, class_named("NSBundle"), "mainBundle")
        info = send_message(POINTER, bundle, "infoDictionary")
        return if info.null? || !responds?(info, "setObject:forKey:")
        send_message(VOID, info, "setObject:forKey:", [POINTER, POINTER], string(title), string("CFBundleName"))
      end

      def menu_item(title, action, key)
        item = send_message(POINTER, class_named("NSMenuItem"), "alloc")
        send_message(POINTER, item, "initWithTitle:action:keyEquivalent:", [POINTER, POINTER, POINTER],
                     string(title), action ? selector(action) : nil, string(key))
      end

      def add_menu(bar, title, items)
        menu = send_message(POINTER, send_message(POINTER, class_named("NSMenu"), "alloc"), "initWithTitle:", [POINTER], string(title))
        items.each do |item|
          entry = item ? menu_item(*item) : send_message(POINTER, class_named("NSMenuItem"), "separatorItem")
          send_message(VOID, menu, "addItem:", [POINTER], entry)
        end
        holder = menu_item(title, nil, "")
        send_message(VOID, holder, "setSubmenu:", [POINTER], menu)
        send_message(VOID, bar, "addItem:", [POINTER], holder)
      end

      def make_menus(title)
        bar = create("NSMenu")
        # WHY performClose: and not terminate: Quit closes the window, so run returns and the program ends its own way
        add_menu(bar, title, [["Hide #{title}", "hide:", "h"], nil, ["Quit #{title}", "performClose:", "q"]])
        add_menu(bar, "Edit", EDIT_ITEMS)
        add_menu(bar, "Window", [["Minimize", "performMiniaturize:", "m"], ["Close", "performClose:", "w"]])
        send_message(VOID, @ns_app, "setMainMenu:", [POINTER], bar)
      end

      def show_icon(path)
        return unless File.file?(path.to_s)
        image = send_message(POINTER, send_message(POINTER, class_named("NSImage"), "alloc"), "initWithContentsOfFile:", [POINTER], string(File.expand_path(path)))
        send_message(VOID, @ns_app, "setApplicationIconImage:", [POINTER], image) unless image.null?
      end

      # run(debug: true): right click > Inspect Element.
      def allow_developer_tools
        configuration = send_message(POINTER, @web_view, "configuration")
        preferences = send_message(POINTER, configuration, "preferences")
        yes = send_message(POINTER, class_named("NSNumber"), "numberWithBool:", [BOOL], 1)
        send_message(VOID, preferences, "setValue:forKey:", [POINTER, POINTER], yes, string("developerExtrasEnabled"))
        send_message(VOID, @web_view, "setInspectable:", [BOOL], 1) if responds?(@web_view, "setInspectable:")
      end

      # The events of the window that wait, after a short wait for the first one.
      def run_events(mode)
        wait_until = send_message(POINTER, class_named("NSDate"), "dateWithTimeIntervalSinceNow:", [DOUBLE], EVENT_WAIT)
        loop do
          event = send_message(POINTER, @ns_app, "nextEventMatchingMask:untilDate:inMode:dequeue:",
                               [Fiddle::TYPE_LONG_LONG, POINTER, POINTER, BOOL], ALL_EVENTS, wait_until, mode, 1)
          break if event.null?
          send_message(VOID, @ns_app, "sendEvent:", [POINTER], event)
          wait_until = nil # the others that wait already, without a wait
        end
        send_message(VOID, @ns_app, "updateWindows")
      end
    end
  end
end
