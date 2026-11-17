#!/bin/sh
# Bismillah
#
# handbook.sh - ozdenui v0.1 (OzdenUI: basic.js for Ruby)
# Every whole program of the handbook (a Ruby block that starts with require "ozdenui", in handbook/*.md and
# handbook/turkce/*.md) is run and drawn in a hidden browser (OZDENUI_LOOK); one that fails, or that writes anything
# in its terminal (a wrong name: "ozdenui: ..."), fails the check. So the handbook stays true when the gem changes.
# Usage: checks/handbook.sh [folder of the pictures (default: pictures/handbook)] [a part of a chapter name (Ex: 03, turkce/05)]
#        RUBY=/usr/bin/ruby checks/handbook.sh        with another Ruby
# The pictures are named <chapter>-<number of the program in it>.png: look at them after writing a chapter.
#
# Started Date: November 2026
# Webpage: https://bug7a.github.io/ozdenui-ruby/
#
# Copyright 2026 Bugra Ozden <bugra.ozden@gmail.com> (https://bug7a.github.io/)
# Licensed under the Apache License, Version 2.0
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname "$0")/.." || exit 1
PICTURES="${1:-pictures/handbook}"
ONLY="${2:-}"
RUBY="${RUBY:-ruby}"
WORK="$(mktemp -d "${TMPDIR:-/tmp}/ozdenui-handbook.XXXXXX")" || exit 1  # its own folder: two checks may run at the same time
mkdir -p "$PICTURES"
case "$PICTURES" in /*) ;; *) PICTURES="$(pwd)/$PICTURES" ;; esac
LIB="$(pwd)/lib"

"$RUBY" - "$WORK" "$ONLY" <<'RUBY'
work, only = ARGV
chapters = Dir["handbook/*.md"].sort + Dir["handbook/turkce/*.md"].sort
chapters.each do |chapter|
  name = chapter.sub(%r{\Ahandbook/}, "").sub(/\.md\z/, "")
  next if only && !only.empty? && !name.include?(only)
  blocks = File.read(chapter, encoding: "UTF-8").scan(/^```ruby\n(.*?)^```/m).map(&:first)
  programs = blocks.select { |code| code.start_with?("require \"ozdenui\"") }
  programs.each_with_index do |code, index|
    File.write(File.join(work, "#{name.tr('/', '-')}-#{index + 1}.rb"), code)
  end
end
RUBY

FAILED=0
COUNT=0
for file in "$WORK"/*.rb; do
    [ -f "$file" ] || continue
    name="$(basename "$file" .rb)"
    COUNT=$((COUNT + 1))
    picture="$PICTURES/$name.png"
    rm -f "$picture"
    # WHY the filter: the line that names the picture is not a fault; "Ignoring ..." is a word of RubyGems
    # WHY from the work folder: a program that reads or writes a file of its own does it there, not in the gem
    output="$(cd "$WORK" && OZDENUI_LOOK_WAIT=0.6 OZDENUI_LOOK="$picture" "$RUBY" -I"$LIB" "$file" 2>&1 | grep -v "the picture of the window\|^Ignoring ")"
    if [ ! -s "$picture" ] || [ -n "$output" ]; then
        FAILED=1
        echo "FAIL $name"
        echo "$output" | sed 's/^/     /'
    else
        echo "ok   $name"
    fi
done
rm -rf "$WORK"
[ "$FAILED" = "0" ] && echo "ALL PASS ($COUNT programs)" || echo "SOME FAILED"
exit $FAILED
