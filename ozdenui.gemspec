# Bismillah
#
# ozdenui.gemspec - ozdenui v0.1 (OzdenUI: basic.js for Ruby)
# The gem: gem build ozdenui.gemspec
#
# Copyright 2026 Bugra Ozden <bugra.ozden@gmail.com> (https://bug7a.github.io/)
# SPDX-License-Identifier: Apache-2.0

require_relative "lib/ozdenui/version"

Gem::Specification.new do |spec|
  spec.name = "ozdenui"
  spec.version = OzdenUI::VERSION
  spec.authors = ["Bugra Ozden"]
  spec.email = ["bugra.ozden@gmail.com"]
  spec.summary = "Modern desktop windows in plain Ruby: no JavaScript, no HTML, no other gem."
  spec.description = "OzdenUI for Ruby opens a window of its own whose objects are the objects of basic.js and the " \
                     "80+ components of the OzdenUI kit (buttons, fields, lists, tables, charts, dialogs, editors), " \
                     "written in Ruby with blocks. On macOS the window is the web view of the system, made with the " \
                     "fiddle library of Ruby; on Windows and Linux it is an app window of Edge or Chrome. No other gem " \
                     "and no compiler are needed; it also works with the Ruby that comes with macOS."
  spec.homepage = "https://bug7a.github.io/ozdenui-ruby/"
  spec.license = "Apache-2.0"
  spec.required_ruby_version = ">= 2.6"
  spec.metadata = {
    "homepage_uri" => spec.homepage,
    "source_code_uri" => "https://github.com/bug7a/ozdenui-ruby",
    "bug_tracker_uri" => "https://github.com/bug7a/ozdenui-ruby/issues",
    "changelog_uri" => "https://github.com/bug7a/ozdenui-ruby/releases"
  }
  spec.files = Dir["lib/**/*", "exe/*", "LICENSE", "NOTICE", "README.md"].select { |path| File.file?(path) }
  spec.bindir = "exe"
  spec.executables = ["ozdenui"]
  spec.require_paths = ["lib"]
end
