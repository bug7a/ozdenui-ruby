# Bismillah
#
# ozdenui.rb - ozdenui v0.1 (OzdenUI: basic.js for Ruby)
# A desktop window in plain Ruby, made of the objects of basic.js and the components of the OzdenUI kit.
#
#   require "ozdenui"
#   include OzdenUI
#
#   run(title: "Hello", width: 360, height: 200) do
#     Label(text: "Hello", font_size: 28)
#   end
#
# Without the include, every name is a method of the module: OzdenUI.run { OzdenUI.Label(text: "Hello") }
#
# Started Date: November 2026
# Webpage: https://bug7a.github.io/ozdenui-ruby/
#
# Copyright 2026 Bugra Ozden <bugra.ozden@gmail.com> (https://bug7a.github.io/)
# Licensed under the Apache License, Version 2.0
# SPDX-License-Identifier: Apache-2.0

require_relative "ozdenui/version"
require_relative "ozdenui/values"
require_relative "ozdenui/kit"
require_relative "ozdenui/server"
require_relative "ozdenui/app"
require_relative "ozdenui/objects"
require_relative "ozdenui/components"
require_relative "ozdenui/dialogs"
require_relative "ozdenui/files"
require_relative "ozdenui/window"
require_relative "ozdenui/look"
