# Bismillah
#
# values.rb - ozdenui v0.1 (OzdenUI: basic.js for Ruby)
# Names (label_text <-> labelText), the values that go to the page and come from it, the blocks the page calls,
# the text of a number (a format) and pictures.
#
# Started Date: November 2026
# Webpage: https://bug7a.github.io/ozdenui-ruby/
#
# Copyright 2026 Bugra Ozden <bugra.ozden@gmail.com> (https://bug7a.github.io/)
# Licensed under the Apache License, Version 2.0
# SPDX-License-Identifier: Apache-2.0

require "json"
require "time"

module OzdenUI
  # What the gem is made of. A program uses the methods of OzdenUI; these classes are behind them.
  module Runtime
    # What a program did wrong, told at its own line: a wrong value, an object that can not hold others...
    class Error < StandardError; end

    # A table that came from the page (a row, an item, the detail of an event): a Hash with the keys of the page as
    # texts, read with a text or a symbol: row["name"], row[:name].
    class Data < Hash
      def [](key)
        super(key.is_a?(Symbol) ? key.to_s : key)
      end

      def fetch(key, *rest, &block)
        super(key.is_a?(Symbol) ? key.to_s : key, *rest, &block)
      end

      def key?(key)
        super(key.is_a?(Symbol) ? key.to_s : key)
      end
      alias has_key? key?
      alias include? key?

      def dig(key, *rest)
        value = self[key]
        return value if rest.empty? || value.nil?
        value.dig(*rest)
      end

      def values_at(*keys)
        keys.map { |key| self[key] }
      end
    end

    # What the page tells of an event of an object: event.key ("Enter"), event.x, event.text (an Input)...
    Event = Struct.new(:name, :key, :code, :shift, :ctrl, :alt, :meta, :x, :y, :text, :detail)

    # The text of a number, made by the page at once (OzdenUI.number_format).
    NumberFormat = Struct.new(:prefix, :suffix, :thousands, :decimals, :percent)

    # @api private
    module Values
      LIB_FOLDER = File.expand_path("..", __dir__) + File::SEPARATOR
      FORMAT_PATTERN = /\A(.*?)\{:?(,?)(?:\.(\d+))?([fd%]?)\}(.*)\z/m.freeze
      PICTURE_ENDING = /\.(png|jpe?g|gif|webp|bmp|svg)\z/i.freeze
      SVG_START = /\A\s*(<\?xml.*?\?>\s*)?(<!--.*?-->\s*)*<svg[\s>]/m.freeze
      ADDRESS_PATTERN = /\A(https?:|data:|blob:|file:)/.freeze
      MIME_TYPES = {
        ".html" => "text/html; charset=utf-8", ".htm" => "text/html; charset=utf-8", ".js" => "text/javascript; charset=utf-8",
        ".css" => "text/css; charset=utf-8", ".json" => "application/json", ".png" => "image/png", ".jpg" => "image/jpeg",
        ".jpeg" => "image/jpeg", ".gif" => "image/gif", ".webp" => "image/webp", ".svg" => "image/svg+xml",
        ".bmp" => "image/bmp", ".ico" => "image/x-icon", ".ttf" => "font/ttf", ".woff" => "font/woff",
        ".woff2" => "font/woff2", ".txt" => "text/plain; charset=utf-8", ".md" => "text/markdown; charset=utf-8",
        ".csv" => "text/csv", ".pdf" => "application/pdf", ".mp3" => "audio/mpeg", ".wav" => "audio/wav",
        ".mp4" => "video/mp4", ".zip" => "application/zip"
      }.freeze

      module_function

      # *** NAMES: label_text (Ruby) <-> labelText (the kit)

      # A symbol is a Ruby name (:label_text -> "labelText"); a text is a name of the kit as it is ("tab_border").
      def kit_name(name)
        return name if name.is_a?(String)
        text = name.to_s
        text.include?("_") ? text.gsub(/_([a-z0-9])/) { Regexp.last_match(1).upcase } : text
      end

      def ruby_name(name)
        name.to_s.gsub(/([a-z0-9])([A-Z])/) { "#{Regexp.last_match(1)}_#{Regexp.last_match(2).downcase}" }
      end

      # "onClick" -> "click", "onKeyDown" -> "keydown", :key_down -> "keydown"
      def event_name(name)
        name.to_s.sub(/\Aon(?=[A-Z_])/, "").delete("_").downcase
      end

      def callback_name?(name)
        name.match?(/\Aon[A-Z]/)
      end

      # style, look, buttonStyle, searchParams...: a param of looks, whose keys are names of the kit.
      def style_name?(name)
        name == "style" || name == "look" || name == "css" || name == "aria" || name.end_with?("Style", "Params")
      end

      # A param that names a picture file: iconFile, imageFile, checkIconFile...
      def file_param?(name)
        name.end_with?("File")
      end

      def closest_name(name, known)
        best = nil
        best_distance = 3
        lower = name.downcase
        known.each do |candidate|
          distance = edit_distance(lower, candidate.downcase)
          if distance < best_distance || (distance == best_distance && best && candidate < best)
            best = candidate
            best_distance = distance
          end
        end
        best
      end

      def edit_distance(first, second)
        previous = (0..second.length).to_a
        (1..first.length).each do |i|
          row = [i]
          (1..second.length).each do |j|
            cost = first[i - 1] == second[j - 1] ? 0 : 1
            row << [previous[j] + 1, row[j - 1] + 1, previous[j - 1] + cost].min
          end
          previous = row
        end
        previous[second.length]
      end

      # *** THE LINE OF THE PROGRAM: "app.rb:12", the first line of the stack that is not of this gem.

      def source_line
        place = caller_locations(1, 40).find { |location| program_line?(location) }
        place ? "#{File.basename(place.path)}:#{place.lineno}" : ""
      end

      def program_line?(location)
        path = location.absolute_path || location.path.to_s
        !path.start_with?(LIB_FOLDER) && !path.start_with?("<internal:")
      end

      # The lines of the program in the trace of a failed task.
      def program_trace(error)
        (error.backtrace || []).reject { |line| line.start_with?(LIB_FOLDER) || line.start_with?("<internal:") }
      end

      # *** READING VALUES:

      # 1, true and a text that is not empty are on (the flags of basic.js are 1 / 0).
      def on?(value)
        case value
        when nil, false then false
        when true then true
        when String then !["", "0", "false"].include?(value)
        when Numeric then !value.zero?
        else true
        end
      end

      def number_of(value)
        case value
        when Numeric then value
        when true then 1
        when String then Float(value.strip, exception: false) || 0
        else 0
        end
      rescue ArgumentError, TypeError
        0 # WHY: Float(text, exception: false) is of Ruby 2.6; an older one raises
      end

      def text_of(value)
        return value.to_i.to_s if value.is_a?(Float) && value.finite? && value == value.to_i
        value.to_s
      end

      # true / false -> 1 / 0, as basic.js takes its flags (a Toggle compares value === 1).
      def flag_as_number(value)
        return 1 if value == true
        return 0 if value == false
        value
      end

      # *** BLOCKS OF THE PROGRAM, CALLED BY THE PAGE:

      def callable?(value)
        value.is_a?(Proc) || value.is_a?(Method)
      end

      def check_handler(handler, where)
        return if handler.nil? || callable?(handler)
        raise Error, "#{where} takes a block: a lambda (-> { ... }, ->(obj) { ... }) or a method (method(:save)), not #{handler.inspect}"
      end

      # Calls a block of the program with the values of the page. The block takes what it needs: -> { }, ->(obj) { },
      # ->(obj, value) { }: a lambda and a method get as many values as they ask for.
      def call_handler(handler, args)
        return unless handler
        strict = handler.is_a?(Method) || handler.lambda?
        return handler.call(*args) unless strict
        kinds = handler.parameters.map(&:first)
        return handler.call(*args) if kinds.include?(:rest)
        required = kinds.count(:req)
        count = [[args.length, required + kinds.count(:opt)].min, required].max
        given = args.first(count)
        given << nil while given.length < count
        handler.call(*given)
      end

      # *** THE TEXT OF A NUMBER, made by the page at once: "{:,.2f} TL"

      def number_format(pattern)
        parts = FORMAT_PATTERN.match(pattern.to_s)
        unless parts
          raise Error, "#{pattern.inspect} is not a format: a text around one place, Ex: \"{:,.2f} TL\", \"{:.0f} kg\", \"{:.1%}\""
        end
        decimals = nil
        decimals = parts[3].to_i if parts[3]
        decimals = 0 if parts[3].nil? && parts[4] == "d"
        NumberFormat.new(parts[1], parts[5], parts[2] == "," ? 1 : 0, decimals, parts[4] == "%" ? 1 : 0)
      end

      # *** PICTURES:

      def data_address(content, kind)
        "data:#{kind};base64,#{[content].pack('m0')}"
      end

      def kind_of_bytes(content)
        head = content.byteslice(0, 16).to_s.b
        return "image/png" if head.start_with?("\x89PNG".b)
        return "image/jpeg" if head.start_with?("\xFF\xD8".b)
        return "image/gif" if head.start_with?("GIF8".b)
        return "image/webp" if head.start_with?("RIFF".b) && head.byteslice(8, 4) == "WEBP".b
        return "image/bmp" if head.start_with?("BM".b)
        "application/octet-stream"
      end

      def svg_text?(text)
        SVG_START.match?(text.byteslice(0, 2000).to_s.scrub)
      end

      def bytes?(text)
        text.encoding == Encoding::BINARY || !text.valid_encoding? || text.include?("\0")
      end

      def picture(source)
        raise Error, "picture() takes a path, the text of an SVG or bytes (File.binread), not #{source.class}" unless source.is_a?(String)
        return data_address(source, "image/svg+xml") if svg_text?(source)
        return data_address(source, kind_of_bytes(source)) if bytes?(source)
        picture_of_path(source)
      end

      # The address of a file of this computer; a text that is not a file stays as it is (an address, an icon of the kit).
      # WHY a data address: the page comes from the program, not from the disk, so it can not read a file by its path.
      def picture_of_path(path)
        return path if path.empty? || ADDRESS_PATTERN.match?(path) || path.start_with?("comp/")
        return data_address(path, "image/svg+xml") if svg_text?(path)
        content = File.binread(path)
        kind = MIME_TYPES[File.extname(path).downcase]
        kind = kind_of_bytes(content) if kind.nil?
        data_address(content, kind.split(";").first)
      rescue SystemCallError => error
        OzdenUI.warning("the picture #{path} could not be read: #{error.message}") if PICTURE_ENDING.match?(path)
        path
      end
    end
  end
end
