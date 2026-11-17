#!/bin/sh
# Bismillah
#
# look-all.sh - ozdenui v0.1 (OzdenUI: basic.js for Ruby)
# A picture of the window of every example, light and dark, without a window (OZDENUI_LOOK: a hidden Chrome or Edge).
# An example that fails, or that tells a wrong name ("ozdenui: ..." in its terminal), fails the check.
# Usage: checks/look-all.sh [folder of the pictures (default: pictures)] [an example (default: all)]
#        RUBY=/usr/bin/ruby checks/look-all.sh        with another Ruby
#
# Started Date: November 2026
# Webpage: https://bug7a.github.io/ozdenui-ruby/
#
# Copyright 2026 Bugra Ozden <bugra.ozden@gmail.com> (https://bug7a.github.io/)
# Licensed under the Apache License, Version 2.0
# SPDX-License-Identifier: Apache-2.0

cd "$(dirname "$0")/.." || exit 1
PICTURES="${1:-pictures}"
ONLY="${2:-}"
RUBY="${RUBY:-ruby}"
mkdir -p "$PICTURES"
FAILED=0
for file in examples/*.rb; do
    name="$(basename "$file" .rb)"
    [ -n "$ONLY" ] && [ "$ONLY" != "$name" ] && continue
    for theme in light dark; do
        picture="$PICTURES/$name-$theme.png"
        rm -f "$picture"
        # WHY the filter: the line that names the picture is not a fault; "Ignoring ..." is a word of RubyGems
        output="$(OZDENUI_THEME=$theme OZDENUI_LOOK="$picture" "$RUBY" -Ilib "$file" 2>&1 | grep -v "the picture of the window\|^Ignoring ")"
        if [ ! -s "$picture" ] || [ -n "$output" ]; then
            FAILED=1
            echo "FAIL $name ($theme)"
            echo "$output" | sed 's/^/     /'
        else
            echo "ok   $name ($theme)"
        fi
    done
done
[ "$FAILED" = "0" ] && echo "ALL PASS" || echo "SOME FAILED"
exit $FAILED
