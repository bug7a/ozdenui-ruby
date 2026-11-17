# Bismillah
#
# command.rb - ozdenui v0.1 (OzdenUI: basic.js for Ruby)
# The ozdenui command of the gem: the rules of OzdenUI for the AI assistant of a project (agents), and the params of a
# component in the terminal (doc).
#
# Started Date: November 2026
# Webpage: https://bug7a.github.io/ozdenui-ruby/
#
# Copyright 2026 Bugra Ozden <bugra.ozden@gmail.com> (https://bug7a.github.io/)
# Licensed under the Apache License, Version 2.0
# SPDX-License-Identifier: Apache-2.0

require_relative "version"

module OzdenUICommand
  LIB = __dir__
  START_MARK = "<!-- ozdenui-ruby: start (written by `ozdenui agents`; the next run writes this part again) -->"
  END_MARK = "<!-- ozdenui-ruby: end -->"
  MESSAGES = {
    made: "%s: made, with the rules of OzdenUI for Ruby %s.",
    added: "%s: the rules of OzdenUI for Ruby %s are added at its end; your lines are as they were.",
    updated: "%s: the rules of OzdenUI for Ruby are updated to %s; your lines are as they were.",
    same: "%s: already has the rules of OzdenUI for Ruby %s."
  }.freeze
  HELP = <<~TEXT
    ozdenui %s (OzdenUI for Ruby)

    ozdenui agents              The rules of OzdenUI for an AI assistant, into AGENTS.md of this folder.
    ozdenui agents CLAUDE.md    Into another file.
    ozdenui agents --print      Only prints them.
    ozdenui doc                 The names of the components.
    ozdenui doc SelectBox       The params of a component, with their defaults.

    OZDENUI_LOOK=app.png ruby app.rb    Runs your program, saves a picture of its window as app.png and ends.
  TEXT

  module_function

  def rules
    File.read(File.join(LIB, "AGENTS.md"), encoding: "UTF-8").strip
  end

  # The text of the file with the rules between the marks: in the place of the old ones, or at its end.
  def with_rules(old_text)
    block = "#{START_MARK}\n#{rules}\n#{END_MARK}\n"
    start = old_text.index(START_MARK)
    finish = old_text.index(END_MARK)
    return old_text[0...start] + block + old_text[(finish + END_MARK.length)..-1].sub(/\A\n+/, "") if start && finish && finish > start
    return block if old_text.strip.empty?
    old_text.sub(/\n+\z/, "") + "\n\n" + block
  end

  # Writes the rules into the file; it returns what it did.
  def write_rules(target)
    old_text = File.exist?(target) ? File.read(target, encoding: "UTF-8") : ""
    new_text = with_rules(old_text)
    return :same if new_text == old_text
    File.write(target, new_text)
    return :made if old_text.strip.empty?
    old_text.include?(START_MARK) ? :updated : :added
  end

  def sections
    text = File.read(File.join(LIB, "COMPONENTS.md"), encoding: "UTF-8")
    text.split(/^## /).drop(1).map { |part| [part[/\A\S+/], "## " + part.rstrip] }.to_h
  end

  def doc(name)
    all = sections
    if name.nil?
      puts all.keys.each_slice(6).map { |row| row.join("  ") }, "", "ozdenui doc <name>: its params"
      return 0
    end
    found = all.keys.find { |key| key.downcase == name.downcase.delete("_") }
    unless found
      close = all.keys.select { |key| key.downcase.include?(name.downcase) }
      warn "No component #{name}.#{close.empty? ? '' : " Did you mean: #{close.join(', ')}?"} (ozdenui doc: every name)"
      return 1
    end
    puts all[found]
    0
  end

  def run(words)
    case words.first
    when "doc" then doc(words[1])
    when "agents"
      if words[1] == "--print"
        puts rules
        return 0
      end
      target = words[1] || "AGENTS.md"
      puts format(MESSAGES[write_rules(target)], target, OzdenUI::VERSION)
      0
    when "version", "--version", "-v"
      puts OzdenUI::VERSION
      0
    else
      puts format(HELP, OzdenUI::VERSION)
      words.empty? ? 0 : 2
    end
  rescue SystemCallError => error
    warn error.message
    1
  end
end
