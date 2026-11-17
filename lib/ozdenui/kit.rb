# Bismillah
#
# kit.rb - ozdenui v0.1 (OzdenUI: basic.js for Ruby)
# What the gem knows of every component of the kit: kit.json, written by tools/gen.rb from the copy of the kit in
# web/ and from tools/spec.json (by hand: the state a component sends back, the callbacks that carry it, short names,
# the dark looks, the areas that hold objects).
#
# Started Date: November 2026
# Webpage: https://bug7a.github.io/ozdenui-ruby/
#
# Copyright 2026 Bugra Ozden <bugra.ozden@gmail.com> (https://bug7a.github.io/)
# Licensed under the Apache License, Version 2.0
# SPDX-License-Identifier: Apache-2.0

require "json"

module OzdenUI
  # What the gem is made of. A program uses the methods of OzdenUI; these classes are behind them.
  module Runtime
    # @api private
    class Spec
      DEFAULT_DATA_PARAMS = %w[value options items rows columns tabs selectedKeys group itemDataList titleDataList].freeze
      PLAIN_PARAMS = %w[styleName style key].freeze # every component takes them besides its own

      attr_reader :name, :params, :methods, :setters, :defaults, :aliases, :state, :sync, :state_defaults, :whole_args,
                  :container, :container_hint, :focus_part, :dark_style

      def initialize(name, entry)
        @name = name
        @params = entry["params"] || []    # the params of the component (its defaults in the kit)
        @methods = entry["methods"] || []
        @setters = entry["setters"] || {}  # the params it has a method for: param -> [method, silent]
        @defaults = entry["defaults"] || {} # params given unless the program gives them
        @aliases = entry["aliases"] || {}  # a short name of a param: text -> labelText
        @state = entry["state"] || {}      # the values the page sends back with every event: { "checked" => "checked" }
        @sync = entry["sync"] || []        # callbacks always given to the page, so the state stays current
        @state_defaults = entry["stateDefaults"] || {}
        @data_params = entry["dataParams"] || DEFAULT_DATA_PARAMS # a true in them stays true (the others go as 1 / 0)
        @format_params = entry["formatParams"] || []
        @whole_args = entry["wholeArgs"] || {}
        @container = entry["container"]     # "self": objects go into it; a name: into that box inside it
        @container_hint = entry["containerHint"]
        @focus_part = entry["focusPart"]    # the part that takes the keyboard (the input of a field)
        @dark_style = entry["darkStyle"]    # its package in a dark window
        @flags = entry
      end

      def own_place?
        @flags["hasOwnPlace"] ? true : false # it knows its place without one (a StatusBar: at the bottom of its box)
      end

      def on_page?
        @flags["onPage"] ? true : false # it is made on the page, not in the box it was written in (a LoadingScreen)
      end

      def size_in_style?
        @flags["sizeInStyle"] ? true : false # it reads its width and height from its style (SmartTable)
      end

      def minimal?
        @flags["hasMinimal"] ? true : false
      end

      def theme_param?
        @flags["themeParam"] ? true : false # it takes theme: "dark", not a package (GraphBox)
      end

      def function?
        !@flags["noFunction"]
      end

      def data_param?(key)
        @data_params.include?(key)
      end

      def format_param?(key)
        @format_params.include?(key)
      end

      # Every name the component takes: its params, the values of a box (not text and html: it fills its box itself).
      # nil: a component the kit copy does not describe.
      def known_names
        return nil if @params.empty?
        @known_names ||= ((Kit::OBJECT_PROPS - %w[text html]) + @params + PLAIN_PARAMS + @aliases.keys).uniq
      end
    end

    # @api private
    module Kit
      DATA = JSON.parse(File.read(File.join(__dir__, "kit.json"), encoding: "UTF-8")).freeze
      VERSION = DATA["kitVersion"]
      GROUP_PARAMS = %w[flow align gap padding wrap justify hug fit stretch].freeze
      # Values of an object that are not setters of basic.js but that the bridge or basic.js takes.
      EXTRA_PROPS = %w[plainText grow shrink].freeze
      OBJECT_PROPS = (DATA["objectProps"] + EXTRA_PROPS).uniq.freeze
      GROUP_NAMES = (OBJECT_PROPS + GROUP_PARAMS).freeze
      # A method every basic.js object has (not in the list of a component).
      OBJECT_METHODS = %w[focus blur setMotion center centerBy aline props load select remove setFocusRing withMotion
                          dontMotion add scrollTo click].freeze
      SPECS = DATA["components"].map { |name, entry| [name, Spec.new(name, entry)] }.to_h.freeze

      def self.[](name)
        SPECS[name]
      end

      # The components a program makes with a method of their name: SmartButton(...), SelectBox(...)
      def self.component_names
        SPECS.select { |_name, spec| spec.function? }.keys
      end
    end
  end

  # The version of basic.js in this gem.
  KIT_VERSION = Runtime::Kit::VERSION
end
