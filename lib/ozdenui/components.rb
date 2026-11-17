# Bismillah
#
# components.rb - ozdenui v0.1 (OzdenUI: basic.js for Ruby)
# The components of the kit: every one is a method of its name (SmartButton(...), SelectBox(...)), made from the table
# of kit.rb. What a table can not say is here: the look of the window, the areas that hold objects, a param changed
# later with the method of the kit.
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
    # @api private
    module Maker
      # A light package the code names, and its dark twin: a dark window takes the twin.
      DARK_TWINS = {
        "ItemList" => { "gallery" => "galleryDark" },
        "SmartButton" => { "minimalDanger" => "minimalDangerDark" }
      }.freeze
      DARK_TONES = %w[cyan orange yellow green blue ink].push(App::ACCENT_STYLE_NAME).freeze
      # The callback of a component that only keeps its state in the program (the page sends it with every call).
      KEEP_STATE = proc {}

      module_function

      def component(type_name, args, props, content)
        app = OzdenUI.current_app
        app.check(type_name)
        spec = Kit[type_name] || Spec.new(type_name, {})
        values, extra = read(type_name, args, props)
        obj = UIObject.new(app, type_name, :component, spec)
        if content && !spec.container
          hint = spec.container_hint ? "objects go into it with #{spec.container_hint}" : "it holds no other objects"
          raise Error, "#{type_name}(...) { ... }: a #{type_name} takes no block: #{hint}"
        end

        parent_id = spec.on_page? ? "page" : app.container_id
        parent = app.objects[parent_id]
        if !spec.own_place? && !spec.on_page? && parent && parent.free_place?
          values["left"] = 0 unless values.key?("left")
          values["top"] = 0 unless values.key?("top")
        end
        take_fill(values, parent) if extra["fill"]
        values["style"] = unframed_style(values["style"]) if extra["unframed"]
        # WHY: on_enter is not a param of the kit: the Enter key of the field
        on_enter = values.delete("onEnter") if spec.focus_part
        obj.warn_about_unknown_names(values)
        spec.aliases.each do |short, long|
          values[long] = values.delete(short) if values.key?(short) && !spec.params.include?(short)
        end
        is_window_look = take_window_look(app, spec, values)
        spec.defaults.each do |key, value|
          next if key == "styleName" && is_window_look # WHY: the look of a light window; the window chose another one
          values[key] = value unless values.key?(key)
        end
        if type_name == "FilePicker" && values["onOpenDialog"].nil?
          values["onOpenDialog"] = Files.method(:open_dialog_of_picker) # WHY: the dialog of the page gives no path
        end
        # WHY: the state of the component comes back with these callbacks
        spec.sync.each { |name| values[name] = KEEP_STATE if values[name].nil? }
        values.each do |key, value|
          Values.check_handler(value, "#{type_name}(#{Values.ruby_name(key)}: ...)") if Values.callback_name?(key)
        end
        size_into_style(values) if spec.size_in_style?
        spec.state_defaults.each { |key, value| obj.kept_values[key] = value }
        obj.keep_values(values)
        if type_name == "Tabs" && obj.kept_values["value"].nil?
          obj.kept_values["value"] = first_key(values["tabs"]) # the kit selects the first tab
        end
        app.objects[obj.id] = obj
        command = { "op" => "create", "id" => obj.id, "type" => type_name, "args" => [], "props" => obj.page_values(values),
                    "parent" => parent_id, "src" => Values.source_line }
        command["state"] = spec.state unless spec.state.empty?
        app.send_command(command)
        obj.set_dom_handler("onEnter", on_enter) if on_enter
        obj.add(&content) if content
        obj
      end

      # The key of the first item of a list of the kit: its "key", else its "text", else the item itself.
      def first_key(list)
        first = list.is_a?(Array) ? list.first : nil
        return first unless first.is_a?(Hash)
        first[:key] || first["key"] || first[:text] || first["text"]
      end

      def kit_keys(table)
        table.is_a?(Hash) ? table.map { |key, value| [Values.kit_name(key), value] }.to_h : {}
      end

      # The style of a component without its frame: no border and no rounded corners on its box. The keys of the code win.
      def unframed_style(style)
        result = kit_keys(style)
        result["box"] = { "border" => 0, "round" => 0 }.merge(kit_keys(result["box"]))
        result
      end

      # WHY: a SmartTable reads its size from its style; a width given as a param would change only its box.
      def size_into_style(values)
        style = kit_keys(values["style"])
        %w[width height].each { |name| style[name] = values[name] if values.key?(name) && !style.key?(name) }
        # WHY: with a height of its own the rows keep their height and their count follows the table; without it the 16
        #      rows of the kit share the height, each a few px high in a small table
        values["fitLineCount"] = 1 if values.key?("height") && !values.key?("fitLineCount")
        values["style"] = style unless style.empty?
      end

      # A minimal window: the minimal look; a dark window: the dark look; unless the code chose one. It is true when the
      # window chose the look.
      def take_window_look(app, spec, values)
        take_window_tone(app, values) if spec.name == "SmartButton"
        if values["styleName"].is_a?(String)
          twin = (DARK_TWINS[spec.name] || {})[values["styleName"]]
          values["styleName"] = twin if app.dark? && twin
          return false
        end
        if spec.theme_param?
          theme = app.minimal? ? (app.dark? ? "minimalDark" : "minimal") : (app.dark? ? "dark" : nil)
          values["theme"] = theme if theme && !values.key?("theme")
          return false
        end
        if app.minimal? && spec.minimal?
          name = app.options[:accent] ? App::ACCENT_STYLE_NAME : "minimal"
          values["styleName"] = app.dark? ? "#{name}Dark" : name
          return true
        end
        if app.dark? && spec.dark_style
          values["styleName"] = spec.dark_style
          return true
        end
        false
      end

      # The tone of a SmartButton in this window: "accent" is the main action in the color of the window, and a dark
      # window takes the dark twin of a tone.
      def take_window_tone(app, values)
        tone = values["tone"]
        return if !tone.is_a?(String) || (values.key?("styleName") && tone != "accent")
        if tone == "accent"
          tone = if app.options[:accent] then App::ACCENT_STYLE_NAME
                 elsif app.minimal? then "ink"
                 else "cyan"
                 end
        end
        tone += "Dark" if app.dark? && DARK_TONES.include?(tone)
        values["tone"] = tone
      end
    end

    class UIObject
      # *** THE AREAS OF THE COMPONENTS THAT HOLD OBJECTS:

      # The area of a tab of a Tabs, by the key of the tab; the objects made in the block go into it.
      #
      #   tabs.panel("general") { Label(text: "General") }
      def panel(key, &content)
        must_be("Tabs", "panel")
        key = key.to_s
        unless @parts["panel:#{key}"]
          # WHY once: it makes the wrapper of the panel, and a second call would clear it
          send_call("setPanelContent", [key, { "__bpNoop" => 1 }])
          @parts["panel:#{key}"] = part({ "call" => "getPanel", "args" => [key] }, "wrapper")
        end
        fill_part(@parts["panel:#{key}"], content)
      end

      # The content of a section of an Accordion, by its key.
      def section(key, &content)
        must_be("Accordion", "section")
        fill_part(part({ "call" => "getContent", "args" => [key.to_s] }), content)
      end

      # The first area of a Splitter (the left or the top one).
      def first(&content)
        must_be("Splitter", "first")
        fill_part(part("first"), content)
      end

      # The second area of a Splitter.
      def second(&content)
        must_be("Splitter", "second")
        fill_part(part("second"), content)
      end

      # The area of a SidePanel: its objects stand one under the other.
      def body(&content)
        must_be("SidePanel", "body")
        fill_part(part({ "call" => "getBody" }), content)
      end

      # Gives an object a cell of its own in a GridGroup (from 0), or a span:
      #
      #   grid.place(wide, column_span: 2)      # also column:, row:, row_span:, align:
      #
      # Inside the block of the grid, the grid itself is what the block gets: GridGroup(columns: 4) { |grid| ... }
      def place(item, **where)
        must_be("GridGroup", "place")
        send_call("place", [item, where.map { |key, value| [Values.kit_name(key), value] }.to_h])
        item
      end

      # Shows the warning of a field (TextField and its kin) when its text is not right, and is true when it is right: a
      # required field that is empty, an e-mail that is not one...
      def valid?
        unless @kit_spec && @kit_spec.focus_part
          raise Error, "valid? is of a field (TextField, EmailField...), not of a #{@type_name}"
        end
        send_call("checkInputValue", [])
        Values.number_of(measure(:status)).zero?
      end

      # Lines into a LogView from any thread: log.writer(:error).puts("the file is missing"); $stdout = log.writer
      # The level is "info", "warn", "error", "debug" or "success".
      def writer(level = :info)
        must_be("LogView", "writer")
        LineWriter.new(self, level.to_s)
      end

      # @api private
      def set_component_value(name, value)
        spec = @kit_spec
        name = spec.aliases[name] if spec.aliases[name] && !spec.params.include?(name)
        if name == "onEnter" && spec.focus_part
          Values.check_handler(value, "on_enter")
          set_dom_handler("onEnter", value)
          return true
        end
        if Values.callback_name?(name)
          Values.check_handler(value, Values.ruby_name(name))
          value ||= Maker::KEEP_STATE # WHY: a nil would go to the page as null, and the component calls it
          @app.send_command("op" => "set", "id" => @id, "props" => { name => page_value(name, value) }, "src" => Values.source_line)
          return true
        end
        if name == "styleName" && spec.methods.include?("setTheme")
          # The look of one object while the program runs (a dark switch of its own, without a new page)
          keep_values(name => value)
          send_call("setTheme", [value.to_s])
          return true
        end
        method, silent = spec.setters[name]
        unless method
          if %w[styleName style].include?(name)
            @app.warn_at("#{@type_name}: #{Values.ruby_name(name)} is the look the component is made with; it does not change later")
          end
          return false
        end
        keep_values(name => value)
        uncheck_others_of_group
        args = [page_value(name, value)]
        args << 1 if silent
        command = { "op" => "call", "id" => @id, "method" => method, "args" => args, "src" => Values.source_line }
        # WHY: the method may change the state too (a slider keeps its value inside its range)
        command["refresh"] = 1 unless spec.state.empty?
        @app.send_command(command)
        true
      end

      # WHY: the page tells only of the radio the user pressed; the one that was checked before would stay checked in
      # the program.
      # @api private
      def uncheck_others_of_group
        return unless @type_name == "RadioButton" && Values.on?(@kept_values["checked"])
        @app.objects.each_value do |other|
          next if other.equal?(self) || other.type_name != "RadioButton" || other.kept_values["group"] != @kept_values["group"]
          other.kept_values["checked"] = 0
        end
      end

      private

      def must_be(type_name, method)
        raise Error, "#{method} is of a #{type_name}, not of a #{@type_name}" unless @type_name == type_name
      end

      def fill_part(part, content)
        part.add(&content) if content
        part
      end
    end

    # @api private
    class LineWriter
      def initialize(obj, level)
        @obj = obj
        @level = level
      end

      def write(*texts)
        text = texts.join
        lines = text.chomp.split("\n", -1)
        OzdenUI.ui { lines.each { |line| @obj.call(@level, line) } }
        text.bytesize
      end

      def puts(*texts)
        write(texts.empty? ? "\n" : texts.flatten.map { |text| text.to_s.chomp + "\n" }.join)
        nil
      end

      def print(*texts)
        write(*texts.map(&:to_s))
        nil
      end

      def <<(text)
        write(text.to_s)
        self
      end

      def flush
        self
      end

      def sync
        true
      end

      def sync=(value); end
    end
  end

  module_function

  # Makes a component of the kit by its name, with its params: component("Gauge", value: 72, width: 200). Every
  # component is also a method of its name: Gauge(value: 72, width: 200).
  def component(type_name, *args, **props, &content)
    Runtime::Maker.component(type_name.to_s, args, props, content)
  end

  Runtime::Kit.component_names.each do |name|
    define_method(name) { |*args, **props, &content| Runtime::Maker.component(name, args, props, content) }
  end

  # The value: of the checked RadioButton of a group ("default" when no group: was given), or nil.
  def radio_value(group = "default")
    OzdenUI.current_app.objects.each_value do |obj|
      next unless obj.type_name == "RadioButton" && obj.checked?
      return obj.value if (obj.kept_values["group"] || "default").to_s == group.to_s
    end
    nil
  end

  # Shows a small bubble with a text at an object, for a while (milliseconds; 0: until hint.remove).
  # side: "top" (default), "bottom", "left", "right". A bubble that comes under the mouse by itself is a Tooltip.
  def show_hint(target, text, milliseconds = 2500, side: "top")
    app = OzdenUI.current_app
    app.check("show_hint")
    look = { "color" => "#FFFFFF", "textColor" => "rgba(0, 0, 0, 0.85)", "border" => 1,
             "borderColor" => "rgba(0, 0, 0, 0.12)", "shadow" => "0 10px 30px rgba(0, 0, 0, 0.12)" }
    if app.dark?
      # WHY a frame: the bubble of the kit has no line and no shadow, so it is not seen on a card of its own color
      look = { "color" => "#2A2A29", "textColor" => Runtime::UIObject::DARK_TEXT, "border" => 1,
               "borderColor" => "rgba(255, 255, 255, 0.14)", "shadow" => "0 10px 30px rgba(0, 0, 0, 0.4)" }
    end
    bubble = Runtime::UIObject.new(app, "Part", :part)
    app.objects[bubble.id] = bubble
    app.call_static("Tooltip", "show", [{ "__bpObject" => target.id }, text.to_s, look, side.to_s], keep: bubble.id)
    if milliseconds.positive?
      OzdenUI.after(milliseconds) { bubble.remove if app.objects[bubble.id] }
    end
    bubble
  end
end
