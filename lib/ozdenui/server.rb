# Bismillah
#
# server.rb - ozdenui v0.1 (OzdenUI: basic.js for Ruby)
# The page of the window and its messages, served on this computer only (127.0.0.1, a port of its own).
#
# The program sends its messages over an event stream ("commands"); the page answers and tells its events with POST
# "emit", one request at a time, so they come in the order they happened (web/bridge.js). Only the socket library of
# Ruby is used: the gem needs no other gem.
#
# Started Date: November 2026
# Webpage: https://bug7a.github.io/ozdenui-ruby/
#
# Copyright 2026 Bugra Ozden <bugra.ozden@gmail.com> (https://bug7a.github.io/)
# Licensed under the Apache License, Version 2.0
# SPDX-License-Identifier: Apache-2.0

require "socket"
require "securerandom"
require "json"
require "uri" # WHY not the cgi library: Ruby 4.0 removed its parse, and the rest of it is going too

module OzdenUI
  # What the gem is made of. A program uses the methods of OzdenUI; these classes are behind them.
  module Runtime
    # @api private
    class PageGone < StandardError; end

    # A queue with a pop that gives up after a time (Queue#pop takes a timeout only since Ruby 3.2).
    # @api private
    class Channel
      def initialize
        @items = []
        @mutex = Mutex.new
        @condition = ConditionVariable.new
      end

      def push(item)
        @mutex.synchronize do
          @items << item
          @condition.signal
        end
      end

      def pop(seconds)
        @mutex.synchronize do
          @condition.wait(@mutex, seconds) if @items.empty?
          @items.shift
        end
      end
    end

    # @api private
    class Server
      WEB_FOLDER = File.join(__dir__, "web")
      STREAM_CHECK_SECONDS = 0.25 # this often a silent stream looks whether its page is still there

      attr_accessor :on_stream # the window of a browser is known to be closed by its stream (window.rb)

      def initialize(app)
        @app = app
        @listener = TCPServer.new("127.0.0.1", 0)
        # WHY: another program or page of this computer must not reach the page of the window
        @token = SecureRandom.hex(16)
        @prefix = "/#{@token}/"
        @mutex = Mutex.new
        @emit_mutex = Mutex.new # one batch of the page at a time, in order
        @page_id = nil          # the page that listens now (a page loaded again is a new one)
        @outgoing = Channel.new # the messages for it
        @waiting = {}           # the answers the program waits for
        @next_reply = 0
        @stopped = false
        @thread = Thread.new { accept_connections }
      end

      def address
        "http://127.0.0.1:#{@listener.addr[1]}#{@prefix}index.html"
      end

      def stop
        @mutex.synchronize { @stopped = true }
        fail_waiting
        @listener.close
      rescue IOError
        nil
      end

      # Sends a message to the page and waits for its answer (the value the page gave).
      def request(message)
        waiter = Queue.new
        number = nil
        outgoing = nil
        @mutex.synchronize do
          raise PageGone, "the page is gone" if @stopped
          number = (@next_reply += 1)
          @waiting[number] = waiter
          outgoing = @outgoing
        end
        begin
          text = JSON.generate(message.merge("n" => number))
        rescue StandardError => error
          @mutex.synchronize { @waiting.delete(number) }
          raise Error, "a value can not be sent to the page: #{error.message}"
        end
        outgoing.push(text)
        reply = waiter.pop
        raise reply if reply.is_a?(Exception)
        reply["value"]
      end

      private

      def accept_connections
        loop do
          socket = @listener.accept
          Thread.new(socket) { |connection| serve(connection) }
        end
      rescue IOError, SystemCallError
        nil # the server was stopped
      end

      def serve(socket)
        socket.setsockopt(Socket::IPPROTO_TCP, Socket::TCP_NODELAY, 1)
        loop do
          line = socket.gets("\r\n")
          break unless line
          method, target, = line.split(" ")
          headers = {}
          while (header = socket.gets("\r\n")) && header != "\r\n"
            name, value = header.split(":", 2)
            headers[name.downcase] = value.to_s.strip
          end
          length = headers["content-length"].to_i
          body = length.positive? ? socket.read(length) : ""
          path, query = target.to_s.split("?", 2)
          unless path.start_with?(@prefix)
            respond(socket, 404, "text/plain", "not found")
            next
          end
          name = path[@prefix.length..-1]
          case name
          when "commands"
            serve_commands(socket, query.to_s)
            break
          when "emit" then serve_emit(socket, method, body)
          when "index.html" then serve_index(socket)
          else serve_file(socket, name)
          end
        end
      rescue IOError, SystemCallError
        nil # the page closed the link
      ensure
        close_quietly(socket)
      end

      # WHY: on Windows close itself can raise ECONNRESET when the page already dropped the link, and the error ended
      # the thread with a message in the terminal.
      def close_quietly(socket)
        socket.close unless socket.closed?
      rescue IOError, SystemCallError
        nil
      end

      def respond(socket, status, kind, body)
        reason = { 200 => "OK", 204 => "No Content", 400 => "Bad Request", 404 => "Not Found" }[status]
        head = "HTTP/1.1 #{status} #{reason}\r\nContent-Length: #{body.bytesize}\r\n"
        head += "Content-Type: #{kind}\r\n" unless body.empty?
        # WHY no-store: a web view keeps a file of an older version of the gem under the same address of another run
        socket.write(head + "Cache-Control: no-store\r\nConnection: keep-alive\r\n\r\n", body)
      end

      HTML_ESCAPES = { "&" => "&amp;", "<" => "&lt;", ">" => "&gt;", '"' => "&quot;", "'" => "&#39;" }.freeze

      def escape_html(text)
        text.to_s.gsub(/[&<>"']/, HTML_ESCAPES)
      end

      # The page, with the title of the window (a browser window shows the title of its page).
      def serve_index(socket)
        page = File.read(File.join(WEB_FOLDER, "index.html"), encoding: "UTF-8")
        options = @app.options
        title = "<title>#{escape_html(options[:title])}</title>"
        # The size of the page the program asked for: a browser window fits itself to it before the program starts
        size = %(<meta name="ozdenui-size" content="#{options[:width]}x#{options[:height]}">)
        page = page.sub("<title>ozdenui</title>", "#{title}\n        #{size}")
        page = page.sub('<html lang="en">', %(<html lang="#{escape_html(options[:language])}">)) if options[:language]
        respond(socket, 200, "text/html; charset=utf-8", page.b)
      end

      def serve_file(socket, name)
        relative = URI.decode_www_form_component(name.gsub("+", "%2B"))
        path = File.expand_path(relative, WEB_FOLDER)
        is_inside = path.start_with?(WEB_FOLDER + File::SEPARATOR)
        unless is_inside && File.file?(path)
          respond(socket, 404, "text/plain", "not found")
          return
        end
        kind = Values::MIME_TYPES[File.extname(path).downcase] || "application/octet-stream"
        respond(socket, 200, kind, File.binread(path))
      rescue ArgumentError # a broken %-code in the address
        respond(socket, 404, "text/plain", "not found")
      end

      # The page=... of an address ("" when there is none, or when the address is broken).
      def page_of(query)
        pair = URI.decode_www_form(query).assoc("page")
        pair ? pair.last.to_s : ""
      rescue ArgumentError
        ""
      end

      # The event stream of the page: every message of the program is one "data:" line.
      def serve_commands(socket, query)
        page_id = page_of(query)
        socket.write("HTTP/1.1 200 OK\r\nContent-Type: text/event-stream\r\nCache-Control: no-store\r\nConnection: keep-alive\r\n\r\n")
        outgoing = @mutex.synchronize { channel_of(page_id) }
        @on_stream&.call(true)
        begin
          loop do
            message = outgoing.pop(STREAM_CHECK_SECONDS)
            if message
              socket.write("data: #{message}\n\n")
            elsif page_left?(socket)
              break
            end
          end
        ensure
          @on_stream&.call(false)
        end
      end

      # WHY: a stream that has nothing to send does not see that its page was closed.
      def page_left?(socket)
        return false unless IO.select([socket], nil, nil, 0)
        socket.read_nonblock(1024)
        false
      rescue IO::WaitReadable
        false
      rescue EOFError, SystemCallError
        true
      end

      def serve_emit(socket, method, body)
        batch = method == "POST" ? JSON.parse(body, object_class: Data) : nil
        unless batch.is_a?(Array)
          respond(socket, 400, "text/plain", "bad request")
          return
        end
        @emit_mutex.synchronize { batch.each { |message| take(message) } }
        respond(socket, 204, "", "")
      rescue JSON::ParserError
        respond(socket, 400, "text/plain", "bad request")
      end

      def take(message)
        if message["ready"]
          # A new page: what waited for the old one gets no answer, and its messages are not for the new one.
          @mutex.synchronize { channel_of(message["ready"]["page"].to_s) }
          fail_waiting
          @app.on_page_ready(message["ready"])
        elsif message["reply"]
          waiter = @mutex.synchronize { @waiting.delete(message["reply"]) }
          return unless waiter
          waiter.push(message["error"] ? Error.new(message["error"].to_s) : message)
        else
          @app.on_page_event(message["target"].to_s, message["event"].to_s, message["data"])
        end
      end

      # The messages of a page, by its name (the lock is held). WHY by its name: the stream of a page may open before or
      # after the server took its "ready"; a channel made new at "ready" was sometimes not the one its stream listened
      # to, and the program waited for ever for an answer.
      def channel_of(page_id)
        if page_id != @page_id
          @page_id = page_id
          @outgoing = Channel.new
        end
        @outgoing
      end

      def fail_waiting
        waiting = @mutex.synchronize do
          taken = @waiting
          @waiting = {}
          taken
        end
        waiting.each_value { |waiter| waiter.push(PageGone.new("the page is gone")) }
      end
    end
  end
end
