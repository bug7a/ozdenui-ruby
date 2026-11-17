# Bismillah
#
# objects.rb - ozdenui v0.1 (OzdenUI: basic.js for Ruby)
# UIObject (every object of the window is one: it keeps an id and the values it was given, and sends commands to the
# page, where the real basic.js object lives) and the basic objects: Box, Label, Button, Input, Icon, VGroup, HGroup.
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
    # Every object of the window: a basic object, a group or a component.
    #
    #   label.text = "Saved"                 # a value by its name (the names of the kit, in snake_case)
    #   label.set(text: "Saved", text_color: "green")
    #   field.text, box.checked?, list.selected_keys   # what was given, or what the page told: no question to the page
    #   list.add_item(key: "a", text: "A")   # a method of the kit
    #   keys = list.get_selected_keys        # a method of the kit that answers (get..., is..., has...)
    class UIObject
      DARK_TEXT = "rgba(255, 255, 255, 0.86)"
      DARK_VALUES = {
        "Box" => { "color" => "#232322", "textColor" => DARK_TEXT },
        "Label" => { "textColor" => DARK_TEXT },
        "Input" => { "color" => "#2A2A29", "textColor" => DARK_TEXT, "borderColor" => "rgba(255, 255, 255, 0.2)" }
      }.freeze
      # WHY the basis and the minimum: a flex item is as large as its content unless it may shrink (no scroll bar came)
      FILL_IN_COLUMN = [{ "width" => "100%", "height" => "auto", "grow" => 1 }, { "flexBasis" => "0", "minHeight" => "0" }].freeze
      FILL_IN_ROW = [{ "width" => "auto", "height" => "100%", "grow" => 1 }, { "flexBasis" => "0", "minWidth" => "0" }].freeze
      POSITION_NAMES = %w[left top width height].freeze
      ASKING_METHOD = /\A(get|is|has)[A-Z]/.freeze

      # @api private
      attr_reader :id, :object_kind, :kit_spec, :kept_values

      # The name of the object in the kit: "Label", "SmartButton".
      attr_reader :type_name

      # @api private
      def initialize(app, type_name, kind, spec = nil)
        @app = app
        @id = app.new_id
        @type_name = type_name
        @object_kind = kind # :basic, :box, :group, :part, :page, :component
        @kit_spec = spec
        @kept_values = {}          # the values given, by their kit names
        @handlers = Hash.new { |hash, key| hash[key] = [] }
        @listened = {}
        @prop_handlers = {}   # event -> the remover of the handler given as a value (on_click:)
        @param_callbacks = {} # param -> the ids of the blocks given to it (also in its items)
        @parts = {}
      end

      # @api private
      def become_page(width, height)
        @id = "page"
        @kept_values["width"] = width
        @kept_values["height"] = height
        @listened["resize"] = true
        @app.objects["page"] = self
        # WHY always: the width and the height of the page come with an event of the page; without a handler of the
        #      program they would keep the size of the start
        @app.send_command("op" => "listen", "id" => "page", "event" => "resize")
      end

      def row?
        @type_name == "HGroup"
      end

      # The page or a Box: its objects have a place of their own (in a group, the group places them).
      # @api private
      def free_place?
        @object_kind == :page || @object_kind == :box
      end

      def to_s
        "<#{@type_name} #{@id}>"
      end
      alias inspect to_s

      # The object in JavaScript, for evaluate: evaluate("#{label.js}.elem.offsetWidth")
      def js
        "__bp.objectOf('#{@id}')"
      end

      # *** VALUES:

      # Changes values by their names: label.set(text: "Hi", font_size: 20). On a component, a param it has a method for
      # in the kit (setUnitText) is changed with that method: the component draws it again, and its callback is not
      # called (only a change of the user calls it).
      def set(given = {}, **props)
        @app.check("#{@type_name}.set")
        values = {}
        given.merge(props).each do |name, value|
          key = Values.kit_name(name)
          raise Error, "fill: is given when the object is made" if key == "fill"
          values[key] = value unless take_special_value(key, value)
        end
        return self if values.empty?
        warn_about_unknown_names(values)
        keep_values(values)
        @app.send_command("op" => "set", "id" => @id, "props" => page_values(values), "src" => Values.source_line)
        self
      end

      # A value the object was given, or the state the page told (the checked of a CheckBox), by its name. A value that
      # was never given is nil: obj.measure(:width) asks the page.
      def get(name)
        @kept_values[Values.kit_name(name)]
      end
      alias [] get

      def []=(name, value)
        set(name => value)
      end

      # The text of the object: of a Label, of an Input or a field as it is on the page now, of a button.
      def text
        %w[text html value].each { |key| return Values.text_of(@kept_values[key]) if @kept_values.key?(key) }
        ""
      end

      def text=(text)
        set("text" => text.to_s)
      end

      # The value of a component: of a SelectBox, a Slider, a Toggle, a DatePicker... (nil: none).
      def value
        @kept_values["value"]
      end

      # Changes the value of a component; its on_change is not called (only a change of the user calls it).
      def value=(value)
        set("value" => value)
      end

      # true for a checked CheckBox or RadioButton, and for a Toggle that is on.
      def checked?
        Values.on?(@kept_values.key?("checked") ? @kept_values["checked"] : @kept_values["value"])
      end
      alias checked checked?
      alias on? checked?

      # The width and the height of the page are current (the page tells them at every resize); of another object they
      # are the values it was given (a size of "auto" or "100%": measure(:width)).
      def width
        @kept_values["width"]
      end

      def height
        @kept_values["height"]
      end

      # A hidden object keeps its place in the program, not on the page.
      def show
        set("visible" => true)
      end

      def hide
        set("visible" => false)
      end

      # A value as basic.js reads it on the page now (a size of "auto", the scrollTop of a box...). It is a question to
      # the page: keep it out of loops.
      def measure(name)
        @app.check("measure")
        @app.read(@id, page_key(Values.kit_name(name)))
      rescue PageGone, Error => error
        @app.warn_at("#{@type_name}.measure(#{name.inspect}): #{error.message}")
        nil
      end

      # Calls a method of the object on the page: box.call(:set_motion, "left 0.3s"). Its result is not waited for.
      # A method of the kit is also a method of the object: list.add_item(item).
      def call(method, *args)
        send_call(Values.kit_name(method), args)
        self
      end

      # Calls a method of the object on the page and returns its result: table.ask(:get_selected_data). It is a question
      # to the page: keep it out of loops.
      def ask(method, *args)
        @app.check("ask")
        page_args = args.map { |value| to_page(value, nil) }
        @app.ask(@id, Values.kit_name(method), page_args)
      rescue PageGone, Error => error
        @app.warn_at("#{@type_name}.ask(#{method.inspect}): #{error.message}")
        nil
      end

      # Puts the keyboard into the object (an Input, a field).
      def focus
        return part(@kit_spec.focus_part).call(:focus) && self if @kit_spec && @kit_spec.focus_part
        call(:focus)
      end

      # Removes the object and every object inside it, for good. To hide it for a while: obj.hide
      def remove
        @app.check("#{@type_name}.remove")
        raise Error, "the page can not be removed: close the window with close" if @object_kind == :page
        @app.send_command("op" => "remove", "id" => @id, "src" => Values.source_line)
        nil
      end

      # *** EVENTS (of the page: click, input, keydown, mouseenter...):

      # Listens to an event of the object: button.on(:click) { ... }, input.on(:key_down) { |input, event| ... }.
      # The block gets the object and the event (event.key, event.x...). It returns a lambda that removes the handler.
      # The page listens to its window: page.on(:key_down) { ... }, page.on(:resize) { ... }.
      def on(event, handler = nil, &block)
        handler ||= block
        @app.check("#{@type_name}.on")
        Values.check_handler(handler, "on(#{event.inspect})")
        raise Error, "on(#{event.inspect}) takes a block" unless handler
        name = Values.event_name(event)
        @handlers[name] << handler
        unless @listened[name]
          @listened[name] = true
          @app.send_command("op" => "listen", "id" => @id, "event" => name, "src" => Values.source_line)
        end
        -> { @handlers[name].delete_if { |candidate| candidate.equal?(handler) } }
      end

      # @api private
      def receive_event(name, data)
        @kept_values["text"] = data["text"] if data["text"].is_a?(String)
        take_state(data["state"]) if data["state"].is_a?(Hash)
        handlers = @handlers[name]
        return if handlers.empty?
        event = Event.new(name, data["key"], data["code"], data["shift"], data["ctrl"], data["alt"], data["meta"],
                          data["x"], data["y"], data["text"], @app.ruby_value(data["detail"]))
        handlers.dup.each { |handler| Values.call_handler(handler, [self, event]) }
      end

      # The state the page sent with an event: the values the program reads without a question (checked, value...).
      # @api private
      def take_state(state)
        state.each do |key, value|
          value = @app.ruby_value(value)
          @kept_values[key] = value
          @kept_values[@kit_spec.aliases[key]] = value if @kit_spec && @kit_spec.aliases[key] # the "text" of a field is its "value"
        end
        uncheck_others_of_group
      end

      # *** A BOX HOLDS OBJECTS:

      # Makes the objects of the block inside this box or group, also later (in an event, a timer):
      #
      #   list.add { Label(text: "One more") }
      #
      # Only a Box, a group and the areas of the components hold objects (a ScrollArea, the panel of a Tabs...).
      def add
        @app.check("#{@type_name}.add")
        raise Error, "add takes a block: box.add { Label(text: \"...\") }" unless block_given?
        target = container_object
        @app.containers.push(target.id)
        begin
          yield target
        ensure
          @app.containers.pop
        end
        self
      end

      # A box inside a component, to put objects into or to call: field.part(:input).call(:select). A step of the path
      # is the name of a property, a place in a list (0) or a call of a method: { call: "getPanel", args: ["details"] }.
      # The same path gives the same object.
      def part(*path)
        @app.check("#{@type_name}.part")
        steps = path.map { |step| step.is_a?(Symbol) ? Values.kit_name(step) : step }
        key = steps.inspect
        known = @parts[key]
        return known if known && @app.objects[known.id]
        part = UIObject.new(@app, "Part", :part)
        @app.objects[part.id] = part
        @parts[key] = part
        @app.send_command("op" => "part", "id" => part.id, "of" => @id, "path" => to_page(steps, nil), "src" => Values.source_line)
        part
      end

      # The box that takes the objects: the object itself, or a box inside a component (the content of a ScrollArea).
      # @api private
      def container_object
        return self if %i[box group part page].include?(@object_kind)
        if @object_kind == :component
          return self if @kit_spec.container == "self"
          return part(@kit_spec.container) if @kit_spec.container
        end
        hint = "only a Box, a group or an area of a component can. Make the object next to it, in the same box."
        hint = @kit_spec.container_hint if @kit_spec && @kit_spec.container_hint
        raise Error, "a #{@type_name} can not hold other objects: #{hint}"
      end

      # *** NAMES THAT ARE NOT METHODS OF THIS CLASS: a value (label.font_size, label.font_size = 20, box.enabled?) or a
      # method of the kit (list.add_item(item), table.get_selected_data).

      def method_missing(name, *args, &block)
        text = name.to_s
        super if text.start_with?("to_") # WHY: Ruby asks an object for to_ary, to_str... to know what it is
        return set(text.chomp("=").to_sym => args.first) if text.end_with?("=") && args.length == 1
        return Values.on?(@kept_values[Values.kit_name(text.chomp("?").to_sym)]) if text.end_with?("?") && args.empty?
        key = Values.kit_name(name)
        return @kept_values[key] if args.empty? && @kept_values.key?(key)
        if kit_method?(key)
          return ask(key, *args) if ASKING_METHOD.match?(key)
          return call(key, *args)
        end
        names = known_names
        return nil if args.empty? && (names.nil? || names.include?(key)) # a value that was not given
        guess = Values.closest_name(key, (names || []) + kit_methods)
        hint = guess ? " (did you mean #{Values.ruby_name(guess)}?)" : ""
        raise NoMethodError, "#{name} is not a value or a method of #{@type_name}#{hint}"
      end

      def respond_to_missing?(name, include_private = false)
        return super if name.to_s.start_with?("to_")
        key = Values.kit_name(name.to_s.chomp("=").chomp("?").to_sym)
        names = known_names
        @kept_values.key?(key) || kit_method?(key) || names.nil? || names.include?(key) || super
      end

      # @api private
      def known_names
        case @object_kind
        when :component then @kit_spec.known_names
        when :part then nil # what it is, is known only on the page
        when :group then Kit::GROUP_NAMES
        else Kit::OBJECT_PROPS
        end
      end

      # @api private
      def warn_about_unknown_names(values)
        known = known_names
        return unless known
        values.each_key do |name|
          next if known.include?(name)
          guess = Values.closest_name(name, known)
          hint = guess ? " (did you mean #{Values.ruby_name(guess)}?)" : ""
          @app.warn_at("#{@type_name}: #{Values.ruby_name(name)} is not a value of #{@type_name}#{hint}")
        end
      end

      # The values given (not the blocks), kept to be read back without a question to the page.
      # @api private
      def keep_values(values)
        values.each do |key, value|
          next if Values.callable?(value)
          if plain_text?
            # WHY: after one of them, the other one is not what the object shows
            @kept_values.delete("html") if key == "text"
            @kept_values.delete("text") if key == "html"
          end
          @kept_values[key] = value
          next unless @kit_spec
          # A value with two names (the "text" of a field is its "value") is read by both.
          @kit_spec.aliases.each do |short, long|
            @kept_values[short] = value if key == long
            @kept_values[long] = value if key == short
          end
        end
      end

      # The values as they go to the page. The blocks given to a param replace the ones given to it before.
      # @api private
      def page_values(values)
        result = {}
        values.each { |key, value| result[page_key(key)] = page_value(key, value) }
        result
      end

      # @api private
      def page_value(key, value)
        value = value.to_s if value.is_a?(Symbol)
        value = Values.flag_as_number(value) unless data_param?(key)
        value = Values.picture_of_path(value) if value.is_a?(String) && Values.file_param?(key)
        value = Values.number_format(value) if value.is_a?(String) && @kit_spec && @kit_spec.format_param?(key)
        ids = []
        converted = @app.to_page(value, @id, ids, Values.style_name?(key))
        replace_callbacks(key, ids)
        if converted.is_a?(Hash) && converted["__bpCallback"] && @kit_spec && @kit_spec.whole_args[key]
          converted["wholeArgs"] = @kit_spec.whole_args[key]
        end
        converted
      end

      # @api private
      def to_page(value, ids)
        @app.to_page(value, @id, ids)
      end

      # @api private
      def send_call(method, args, refresh: false, slot: nil)
        @app.check("#{@type_name}.#{Values.ruby_name(method)}")
        if @kit_spec && !@kit_spec.methods.empty? && !kit_method?(method)
          guess = Values.closest_name(method, @kit_spec.methods)
          hint = guess ? " (did you mean #{Values.ruby_name(guess)}?)" : ""
          @app.warn_at("#{@type_name}: #{Values.ruby_name(method)} is not a method of #{@type_name}#{hint}")
        end
        ids = []
        page_args = args.map { |value| to_page(value, ids) }
        replace_callbacks(slot, ids) if slot
        command = { "op" => "call", "id" => @id, "method" => method, "args" => page_args, "src" => Values.source_line }
        # WHY: a method of the kit may change what the program reads without a question (set_selected, clear_selection)
        command["refresh"] = 1 if refresh || (@kit_spec && !@kit_spec.state.empty?)
        @app.send_command(command)
      end

      # The handler given as a value (on_click: block, obj.on_click = block): a new one replaces it, nil takes it away;
      # the handlers of on() stay.
      # @api private
      def set_dom_handler(name, handler)
        remover = @prop_handlers.delete(name)
        remover&.call
        return unless handler
        if name == "onEnter"
          # The Enter key of an Input
          @prop_handlers[name] = on("keydown") do |obj, event|
            Values.call_handler(handler, [obj, event]) if event.key == "Enter"
          end
          return
        end
        @prop_handlers[name] = on(Values.event_name(name), handler)
      end

      # WHY a method and not a value: an Icon loads its file with load(); a value named picture would do nothing.
      # @api private
      def set_picture(source)
        @kept_values["picture"] = source
        call(:load, Values.picture(source))
      end

      private

      def plain_text?
        @type_name == "Label" || @type_name == "Button"
      end

      # WHY plainText: the text of basic.js is HTML, so a typed "<b>" would be bold and a "<img onerror=...>" would run.
      # Here text is the text as it is written; html is the HTML (a Label and a Button of basic.js take it as their text).
      def page_key(key)
        return "plainText" if plain_text? && key == "text"
        return "text" if plain_text? && key == "html"
        key
      end

      def data_param?(key)
        @kit_spec ? @kit_spec.data_param?(key) : key == "value"
      end

      def kit_methods
        (@kit_spec ? @kit_spec.methods : []) + Kit::OBJECT_METHODS
      end

      def kit_method?(name)
        (@kit_spec && @kit_spec.methods.include?(name)) || Kit::OBJECT_METHODS.include?(name) || (@object_kind == :part && name.match?(/\A[a-z]\w*\z/))
      end

      # WHY: every obj.on_change = block would keep a new block for ever, and so would every new list of items whose
      # items have an onClick (with what each block holds).
      def replace_callbacks(slot, ids)
        (@param_callbacks.delete(slot) || []).each { |id| @app.callbacks.delete(id) }
        @param_callbacks[slot] = ids unless ids.empty?
      end

      # A value that is not a plain value of the page: an event, the picture of an Icon, a param with a method.
      def take_special_value(name, value)
        return set_component_value(name, value) if @object_kind == :component
        if Values.callback_name?(name)
          Values.check_handler(value, Values.ruby_name(name))
          set_dom_handler(name, value)
          return true
        end
        if name == "picture" && @type_name == "Icon"
          set_picture(value)
          return true
        end
        false
      end
    end

    # @api private
    class App
      # A value as it goes to the page (JSON). A block becomes a callback of the owner ({ __bpCallback: id }), an object
      # its id. ids takes the ids of the callbacks made. kit_keys: the keys of a table are names of the kit (a style):
      # a symbol in snake_case is written as the kit writes it.
      def to_page(value, owner_id, ids, kit_keys = false)
        case value
        when nil, true, false, String, Integer then value
        when Float then value.finite? ? value : nil
        when Symbol then value.to_s
        when UIObject then { "__bpObject" => value.id }
        when NumberFormat
          { "__bpFormat" => { "prefix" => value.prefix, "suffix" => value.suffix, "thousands" => value.thousands,
                              "decimals" => value.decimals, "percent" => value.percent } }
        when Proc, Method
          id = register_callback(value, owner_id)
          ids&.push(id)
          { "__bpCallback" => id }
        when Hash
          result = {}
          value.each do |key, item|
            name = kit_keys ? Values.kit_name(key) : key.to_s
            result[name] = to_page(item, owner_id, ids, kit_keys)
          end
          result
        when Array then value.map { |item| to_page(item, owner_id, ids, kit_keys) }
        when Time then value.iso8601
        when Struct then to_page(value.to_h, owner_id, ids, kit_keys)
        else
          return value.iso8601 if value.respond_to?(:iso8601) # a Date, a DateTime
          return to_page(value.to_h, owner_id, ids, kit_keys) if value.respond_to?(:to_h)
          return value.to_f if value.is_a?(Numeric) # a Rational, a BigDecimal
          value.to_s
        end
      end
    end

    # @api private
    module Maker
      module_function

      # The values of a call: Box(10, 20, 200, 100, color: "white") -> { "left" => 10, ..., "color" => "white" }, by the
      # names of the kit, and what is not a value of the page (fill:, unframed:).
      def read(type_name, args, props)
        # WHY: Ruby 2.6 gives a table with text keys ("tab_border" => 1) as the last value, not as a named one
        props = args.pop.merge(props) if args.last.is_a?(Hash)
        if args.length > 4 || args.any? { |value| !value.is_a?(Numeric) && !value.is_a?(String) }
          raise Error, "#{type_name}(#{args.map(&:inspect).join(', ')}): the values without a name are left, top, width, height; " \
                       "the others have names: #{type_name}(text: \"...\")"
        end
        values = {}
        args.each_with_index { |value, index| values[UIObject::POSITION_NAMES[index]] = value }
        extra = {}
        props.each do |name, value|
          key = Values.kit_name(name)
          if %w[fill unframed].include?(key)
            extra[key] = Values.on?(value)
          elsif !value.nil? || Values.callback_name?(key)
            values[key] = value.is_a?(Symbol) ? value.to_s : value
          end
        end
        [values, extra]
      end

      def take_fill(values, parent)
        props, css = parent && parent.row? ? UIObject::FILL_IN_ROW : UIObject::FILL_IN_COLUMN
        props.each { |key, value| values[key] = value unless values.key?(key) }
        own = values["css"].is_a?(Hash) ? values["css"].map { |key, value| [Values.kit_name(key), value] }.to_h : {}
        values["css"] = css.merge(own)
      end

      def basic(type_name, kind, args, props, content)
        app = OzdenUI.current_app
        app.check(type_name)
        values, extra = read(type_name, args, props)
        obj = UIObject.new(app, type_name, kind)
        parent = app.objects[app.container_id]
        if parent && parent.free_place?
          # WHY: basic.js puts an object without a place at -1000, -1000 (out of sight until it is placed). Outside a
          #      group it gets the top left corner: the commands go together, so nothing is seen early.
          values["left"] = 0 unless values.key?("left")
          values["top"] = 0 unless values.key?("top")
        end
        take_fill(values, parent) if extra["fill"]
        handlers = {}
        values.keys.each do |name|
          next unless Values.callback_name?(name)
          Values.check_handler(values[name], "#{type_name}(#{Values.ruby_name(name)}: ...)")
          handlers[name] = values.delete(name)
        end
        picture = values.delete("picture") if type_name == "Icon"
        obj.warn_about_unknown_names(values)
        if kind == :group && !Values.on?(values["scrollY"]) && !Values.on?(values["scrollX"]) && !values.key?("clipContent")
          # WHY: a group of basic.js cuts a button that grows, a focus ring or a shadow at its edge, so nearly every
          #      group of a program would say clip_content: false.
          values["clipContent"] = 0
        end
        if app.dark? && kind != :group
          (UIObject::DARK_VALUES[type_name] || {}).each { |key, value| values[key] = value unless values.key?(key) }
        end
        obj.keep_values(values)
        app.objects[obj.id] = obj
        app.send_command("op" => "create", "id" => obj.id, "type" => type_name, "args" => [], "props" => obj.page_values(values),
                         "parent" => app.container_id, "src" => Values.source_line)
        if type_name == "Input"
          # The page always tells the text of an Input
          obj.on("input") {}
        end
        handlers.each { |name, handler| obj.set_dom_handler(name, handler) }
        obj.set_picture(picture) if picture
        obj.add(&content) if content
        obj
      end
    end
  end

  module_function

  # A rectangle that holds other objects: the objects made in its block go into it, each with a place of its own.
  #
  #   Box(20, 20, 200, 120, color: "white", round: 8) do
  #     Label(12, 12, text: "In the box")
  #   end
  def Box(*args, **props, &content)
    Runtime::Maker.basic("Box", :box, args, props, content)
  end

  # Holds objects one under the other (flexbox). A group is 100% x 100% by default; hug: true wraps its objects,
  # fill: true takes the room the other objects of its group leave. Unlike in basic.js, a group does not cut what goes
  # out of it (clip_content: true cuts).
  def VGroup(*args, **props, &content)
    Runtime::Maker.basic("VGroup", :group, args, props, content)
  end

  # Holds objects side by side (flexbox). See VGroup.
  def HGroup(*args, **props, &content)
    Runtime::Maker.basic("HGroup", :group, args, props, content)
  end

  # A text. text: is shown as it is written; html: takes HTML.
  def Label(*args, **props)
    Runtime::Maker.basic("Label", :basic, args, props, nil)
  end

  # The plain button of basic.js. SmartButton is the modern one.
  def Button(*args, **props)
    Runtime::Maker.basic("Button", :basic, args, props, nil)
  end

  # A plain text box: input.text is always the text on the page. TextField is the modern one.
  def Input(*args, **props)
    Runtime::Maker.basic("Input", :basic, args, props, nil)
  end

  # A picture: Icon(width: 48, height: 48, picture: "photo.png"). ImageView is the one with a zoom.
  def Icon(*args, **props)
    Runtime::Maker.basic("Icon", :basic, args, props, nil)
  end

  # The box that takes the objects made now: inside the block of a group, the group itself.
  def current
    app = OzdenUI.current_app
    app.check("current")
    app.objects[app.container_id]
  end
end
