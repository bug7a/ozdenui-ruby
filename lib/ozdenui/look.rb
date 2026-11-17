# Bismillah
#
# look.rb - ozdenui v0.1 (OzdenUI: basic.js for Ruby)
# The picture of a window without a window: OZDENUI_LOOK=app.png ruby app.rb runs the program as it is in a hidden
# Chrome or Edge, saves the picture of its page and ends. OZDENUI_WINDOW=headless runs it there until the program
# closes it (the tests). The browser is driven over its DevTools protocol, with a small WebSocket client of its own.
#
# OZDENUI_THEME=dark: the dark window. OZDENUI_LOOK_WAIT=3: seconds before the picture (default 1.5).
# OZDENUI_LOOK_SCALE=2: a picture with twice the dots.
#
# Started Date: November 2026
# Webpage: https://bug7a.github.io/ozdenui-ruby/
#
# Copyright 2026 Bugra Ozden <bugra.ozden@gmail.com> (https://bug7a.github.io/)
# Licensed under the Apache License, Version 2.0
# SPDX-License-Identifier: Apache-2.0

require "socket"
require "json"
require "uri"
require "securerandom"
require "tmpdir"
require "fileutils"

module OzdenUI
  # What the gem is made of. A program uses the methods of OzdenUI; these classes are behind them.
  module Runtime
    # @api private
    module Look
      DEFAULT_WAIT = 1.5
      BROWSER_START_WAIT = 20

      # @api private
      class HeadlessWindow
        attr_reader :done

        def initialize
          @done = Latch.new
        end

        def title=(_title); end

        def close
          @done.set
        end
      end

      module_function

      def env_number(name, fallback)
        number = Float(ENV[name].to_s, exception: false)
        number && number.positive? ? number : fallback
      end

      def open(app, address)
        picture = ENV["OZDENUI_LOOK"].to_s
        browser = Window.find_browser
        unless browser
          $stderr.puts "ozdenui: a picture of the window needs Chrome, Edge or Chromium on this computer (OZDENUI_BROWSER: its path)"
          return
        end
        window = HeadlessWindow.new
        app.control = window
        profile = Dir.mktmpdir("ozdenui-look-")
        width, height = app.options.values_at(:width, :height)
        reader, writer = IO.pipe
        pid = Process.spawn(browser, "--headless=new", "--remote-debugging-port=0", "--user-data-dir=#{profile}",
                            "--no-first-run", "--no-default-browser-check", "--hide-scrollbars", "--disable-gpu",
                            *Window::PROFILE_FLAGS, "--window-size=#{width},#{height}", "about:blank",
                            out: File::NULL, err: writer)
        writer.close
        link = WebSocket.new(devtools_address(reader))
        target = link.call(nil, "Target.createTarget", "url" => "about:blank")
        session = link.call(nil, "Target.attachToTarget", "targetId" => target["targetId"], "flatten" => true)["sessionId"]
        link.call(session, "Emulation.setDeviceMetricsOverride", "width" => width, "height" => height,
                                                                 "deviceScaleFactor" => env_number("OZDENUI_LOOK_SCALE", 1), "mobile" => false)
        link.call(session, "Page.navigate", "url" => address)
        if picture.empty?
          window.done.wait # a check without a screen: the program closes it
          return
        end
        started_at = Time.now
        until app.drawn.set? || window.done.set?
          raise Error, "the page did not start: no picture" if Time.now - started_at > App::READY_TIMEOUT + BROWSER_START_WAIT
          sleep(0.02)
        end
        return if window.done.set?
        window.done.wait(env_number("OZDENUI_LOOK_WAIT", DEFAULT_WAIT))
        shot = link.call(session, "Page.captureScreenshot", "format" => "png")
        File.binwrite(picture, shot["data"].to_s.unpack1("m"))
        $stderr.puts "ozdenui: the picture of the window: #{picture}"
      rescue Error, SystemCallError, IOError => error
        $stderr.puts "ozdenui: #{error.message}"
      ensure
        link&.close
        if pid
          begin
            Process.kill("KILL", pid)
            Process.wait(pid)
          rescue SystemCallError
            nil
          end
        end
        reader&.close
        FileUtils.rm_rf(profile) if profile
      end

      # The browser writes "DevTools listening on ws://127.0.0.1:port/devtools/browser/..." when it is ready.
      def devtools_address(output)
        found = Queue.new
        Thread.new do
          begin
            told = false
            output.each_line do |line| # WHY to its end: a full pipe would stop the browser
              address = told ? nil : line[%r{ws://\S+}]
              next unless address
              told = true
              found.push(address)
            end
          rescue IOError
            nil
          end
        end
        ends_at = Time.now + BROWSER_START_WAIT
        sleep(0.02) while found.empty? && Time.now < ends_at
        raise Error, "the hidden browser did not start" if found.empty?
        found.pop
      end

      # A small WebSocket client, for the DevTools protocol of the browser (text messages of JSON).
      # @api private
      class WebSocket
        def initialize(address)
          uri = URI.parse(address)
          @socket = TCPSocket.new(uri.host, uri.port)
          key = [SecureRandom.random_bytes(16)].pack("m0")
          @socket.write("GET #{uri.path} HTTP/1.1\r\nHost: #{uri.host}:#{uri.port}\r\nUpgrade: websocket\r\n" \
                        "Connection: Upgrade\r\nSec-WebSocket-Key: #{key}\r\nSec-WebSocket-Version: 13\r\n\r\n")
          status = @socket.gets("\r\n").to_s
          raise Error, "the hidden browser refused the link: #{status.strip}" unless status.include?("101")
          nil while (line = @socket.gets("\r\n")) && line != "\r\n"
          @mutex = Mutex.new
          @write_mutex = Mutex.new
          @waiting = {}
          @next_id = 0
          @reader = Thread.new { read_messages }
        end

        def close
          @socket.close
        rescue IOError
          nil
        end

        # Calls a method of the DevTools protocol and returns its result.
        def call(session, method, params = {})
          waiter = Queue.new
          id = @mutex.synchronize do
            @next_id += 1
            @waiting[@next_id] = waiter
            @next_id
          end
          message = { "id" => id, "method" => method, "params" => params }
          message["sessionId"] = session if session
          write(JSON.generate(message))
          ends_at = Time.now + BROWSER_START_WAIT
          sleep(0.005) while waiter.empty? && Time.now < ends_at
          raise Error, "#{method}: no answer of the hidden browser" if waiter.empty?
          answer = waiter.pop
          raise Error, "#{method}: the hidden browser is gone" unless answer
          raise Error, "#{method}: #{answer['error']['message']}" if answer["error"]
          answer["result"] || {}
        end

        private

        # One text frame; a client masks what it sends.
        def write(text)
          payload = text.b
          header = [0x81].pack("C")
          length = payload.bytesize
          header << if length < 126 then [0x80 | length].pack("C")
                    elsif length < 65_536 then [0x80 | 126, length].pack("Cn")
                    else [0x80 | 127, length].pack("CQ>")
                    end
          mask = SecureRandom.random_bytes(4).bytes
          masked = payload.bytes.each_with_index.map { |byte, index| byte ^ mask[index % 4] }.pack("C*")
          @write_mutex.synchronize { @socket.write(header + mask.pack("C*") + masked) }
        end

        def read_messages
          message = +"".b
          loop do
            head = @socket.read(2)
            break unless head && head.bytesize == 2
            first, second = head.bytes
            opcode = first & 0x0F
            length = second & 0x7F
            length = @socket.read(2).unpack1("n") if length == 126
            length = @socket.read(8).unpack1("Q>") if length == 127
            payload = length.zero? ? "".b : @socket.read(length)
            break if opcode == 0x8 || payload.nil? # closed
            next if opcode > 0x2 # a ping or a pong: the browser does not wait for an answer on this link
            message << payload
            next if (first & 0x80).zero?
            take(message)
            message = +"".b
          end
        rescue IOError, SystemCallError
          nil
        ensure
          waiting = @mutex.synchronize do
            taken = @waiting
            @waiting = {}
            taken
          end
          waiting.each_value { |waiter| waiter.push(nil) }
        end

        def take(message)
          answer = JSON.parse(message.force_encoding("UTF-8"))
          waiter = @mutex.synchronize { @waiting.delete(answer["id"]) }
          waiter&.push(answer)
        rescue JSON::ParserError
          nil
        end
      end
    end
  end
end
