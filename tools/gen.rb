# Bismillah
#
# gen.rb - ozdenui v0.1 (OzdenUI: basic.js for Ruby)
# Writes lib/ozdenui/kit.json (what the gem knows of every component: its params, its methods, the methods that change
# a param, and what tools/spec.json says by hand) and COMPONENTS.md (every param with its default and the comment of
# the kit), from the copy of the kit in lib/ozdenui/web. Run it after the copy or spec.json changed: ruby tools/gen.rb
#
# Started Date: November 2026
# Webpage: https://bug7a.github.io/ozdenui-ruby/
#
# Copyright 2026 Bugra Ozden <bugra.ozden@gmail.com> (https://bug7a.github.io/)
# Licensed under the Apache License, Version 2.0
# SPDX-License-Identifier: Apache-2.0

require "json"

ROOT = File.expand_path("..", __dir__)
WEB = File.join(ROOT, "lib", "ozdenui", "web")

LIST_LINE = /^\s+(\w+): \["([^"]+)"/
DEFAULTS_LINE = /\A( *)const \w*[Dd]efaults = \{[ \t]*\z/
SET_METHOD = /\bbox\.(set[A-Z]\w*)\s*=\s*(?:async\s+)?function\s*\(([^)]*)\)/
ANY_METHOD = /\bbox\.([a-z]\w*)\s*=\s*(?:async\s+)?(?:function\b|\([^)]*\)\s*=>)/
PARENT_OF = /startExtendedObject\((\w+),/
OBJECT_SETTER = /\bset (\w+)\(/
# WHY: the page calls them while it draws and needs their answer at once; a block of the program answers later
NOT_FOR_PROGRAM = /\A(create|update)\w*View\z/
WHEN_TO_USE = /WHEN TO USE IT: ([^\n]+(?:\n[^\n]+)*)/
INNER_METHOD = /\A(create|update|calc|apply|render|draw|refresh|paint|handle|on[A-Z]|build|make|layout|init|_)/
# Not components to make: helpers of the kit and the ones with methods of their own in this gem.
NO_FUNCTION = %w[UI UIEffects TapEffect ScrollBar MinimalAccent Toast].freeze

def read_text(path)
  File.read(path, encoding: "UTF-8").gsub("\r\n", "\n") # a checkout of Windows
end

# The name of a component -> its file, from the list of the loader (components.js).
def component_files
  read_text(File.join(WEB, "components.js")).scan(LIST_LINE).to_h
end

# The code of a component and of the component it is made from (startExtendedObject).
def source_of(name, files)
  source = read_text(File.join(WEB, files[name]))
  parent = source[PARENT_OF, 1]
  source += "\n" + source_of(parent, files) if parent && parent != name && files[parent]
  source
end

def split_comment(text)
  text = text.strip
  comment = ""
  at = text.index(" // ")
  if at
    comment = text[(at + 4)..-1].strip
    text = text[0...at].strip
  elsif text.start_with?("// ")
    return ["", text[3..-1].strip]
  end
  [text.sub(/,\z/, ""), comment]
end

# The params of a component, in the order of the kit: the keys of its defaults blocks, the first one of a name wins.
def defaults_of(source)
  params = []
  seen = {}
  lines = source.split("\n")
  i = 0
  while i < lines.length
    start = DEFAULTS_LINE.match(lines[i])
    unless start
      i += 1
      next
    end
    key_line = /\A#{start[1]}    ([A-Za-z_$][\w$]*)\s*:\s*(.*)\z/
    i += 1
    while i < lines.length && lines[i].rstrip != start[1] + "};"
      match = key_line.match(lines[i])
      if match && !seen[match[1]]
        seen[match[1]] = true
        value, comment = split_comment(match[2])
        is_open = value.end_with?("[") || value.end_with?("{")
        if is_open && comment.empty? && i + 1 < lines.length
          # A list or a table written over lines: its first line shows how an item is written
          example = lines[i + 1].strip.sub(/,\z/, "")
          comment = "Ex: " + example if example.start_with?("{") && example.end_with?("}")
        end
        params << { name: match[1], value: value, comment: comment } unless NOT_FOR_PROGRAM.match?(match[1])
      end
      i += 1
    end
  end
  params
end

def callback?(param)
  param[:name].match?(/\Aon[A-Z]/) || param[:value].start_with?("function") || param[:value].include?("=>")
end

# The packages of looks of a component: X.styles = { light: ..., dark: ... } and X.styles.name = ...
def looks_of(name, source)
  looks = source.scan(/^#{name}\.styles\.(\w+)\s*=/).flatten
  lines = source.split("\n")
  lines.each_with_index do |line, i|
    next unless line.start_with?("#{name}.styles = {")
    lines[(i + 1)..-1].each do |inner|
      break if inner.start_with?("}")
      looks << inner[/\A    (\w+)\s*:/, 1] if inner.match?(/\A    (\w+)\s*:/)
    end
  end
  looks.uniq.sort
end

def snake(name)
  name.gsub(/([a-z0-9])([A-Z])/) { "#{$1}_#{$2.downcase}" }
end

def camel(name)
  name.gsub(/_([a-z0-9])/) { $1.upcase }
end

# How a program writes a name of the kit: label_text:, or "aName" => when its snake_case does not come back to it.
def ruby_name(name)
  camel(snake(name)) == name ? "`#{snake(name)}:`" : "`\"#{name}\" =>`"
end

def short_value(param)
  return "a block" if callback?(param)
  value = param[:value]
  return value + "...}" if value.end_with?("{")
  return value + "...]" if value.end_with?("[")
  value.length > 60 ? value[0, 57] + "..." : value
end

def cell(text)
  text.to_s.gsub("|", "\\|")
end

files = component_files
spec = JSON.parse(read_text(File.join(ROOT, "tools", "spec.json")))
spec.each_key do |name|
  abort "spec.json: #{name} is not a component of the kit copy" unless files[name]
end

basic = read_text(File.join(WEB, "basic", "basic.min.js"))
version = basic[/basic\.js \(v([0-9.]+)\)/, 1]
kit = { "kitVersion" => version, "objectProps" => basic.scan(OBJECT_SETTER).flatten.uniq.sort, "components" => {} }
docs = +"# The components of OzdenUI for Ruby\n\n"
docs << "Made by `tools/gen.rb` from the kit (basic.js v#{version}); do not edit. Every component is a method of `OzdenUI`\n"
docs << "(`SelectBox(options: [...])`); its params are the params of the kit in snake_case, each with the default of the kit\n"
docs << "and the comment of the kit (written for JavaScript: a `1 / 0` flag also takes `true / false`, `function (self) {}`\n"
docs << "is a block or a lambda that gets the object). Every component also takes `left:`, `top:`, `width:`, `height:`,\n"
docs << "`style_name:`, `style:`, `visible:`, `opacity:`, `fill:` and `unframed:`. In a terminal: `ozdenui doc SelectBox`.\n\n"
count = 0

files.keys.sort.each do |name|
  source = source_of(name, files)
  params = defaults_of(source)
  item = spec[name]
  next if params.empty? && item.nil?
  item ||= {}
  names = params.map { |param| param[:name] }
  methods = source.scan(ANY_METHOD).flatten.uniq.sort
  setters = {}
  source.scan(SET_METHOD) do |method, arguments|
    param_name = method[3].downcase + method[4..-1]
    next unless names.include?(param_name) && !setters[param_name]
    second = arguments.split(",")[1].to_s.split("=")[0].to_s.strip
    setters[param_name] = [method, second == "silent"]
  end
  # A param the kit changes with a method of another name (selectedKeys: setSelected), told by spec.json
  setters.merge!(item["setters"] || {})
  entry = { "file" => files[name], "params" => names.sort, "methods" => methods }
  entry["setters"] = setters.sort.to_h unless setters.empty?
  item.each { |key, value| entry[key] = value unless %w[boxFields doc setters].include?(key) }
  entry["noFunction"] = true if NO_FUNCTION.include?(name)
  kit["components"][name] = entry
  next if NO_FUNCTION.include?(name)

  count += 1
  looks = looks_of(name, source)
  public_methods = methods.reject { |method| INNER_METHOD.match?(method) }
  docs << "## #{name}\n\n"
  lines = [item["doc"] || "`#{name}(...)` makes the #{name} of the kit (#{files[name]})."]
  use = source[WHEN_TO_USE, 1]
  if use && !item["doc"]
    text = use.split.join(" ")
    text = text[0..text.index(". ")] if text.index(". ")
    lines << "When to use it: " + text
  end
  lines << "`style_name:` " + looks.map { |look| "`\"#{look}\"`" }.join(", ") + "." unless looks.empty?
  lines << "A dark window gives it its dark look." if item["darkStyle"] || item["themeParam"]
  unless (item["state"] || {}).empty?
    lines << "Read without a question to the page: " + item["state"].keys.sort.map { |key| "`obj.#{snake(key)}`" }.join(", ") + "."
  end
  lines << "Objects go into it with its block: `#{name}(...) { ... }`." if item["container"]
  lines << "Objects go into it with `#{item["containerHint"]}`." if item["containerHint"]
  unless public_methods.empty?
    lines << "Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): " +
             public_methods.map { |method| "`#{snake(method)}`" }.join(", ") + "."
  end
  docs << lines.join("\n\n") << "\n\n"
  format_params = item["formatParams"] || []
  rows = params.map do |param|
    comment = param[:comment]
    if format_params.include?(param[:name])
      comment = 'a format text, made by the page at once: "{:,.2f} TL", "{:.0f} kg", "{:.1%}" (not a block)'
    end
    default = short_value(param)
    own = (item["defaults"] || {})[param[:name]]
    default = "#{own.to_json} (the kit alone: #{default})" if (item["defaults"] || {}).key?(param[:name])
    "| #{ruby_name(param[:name])} | `#{cell(default)}` | #{cell(comment)} |"
  end
  (item["boxFields"] || []).each do |field|
    rows << "| `#{field}:` | | a value of its box |" unless names.include?(field)
  end
  rows << "| `on_enter:` | | the Enter key: a block or a lambda that gets the field |" if item["focusPart"] && !names.include?("onEnter")
  docs << "| Param | Default | The kit says |\n|---|---|---|\n" << rows.join("\n") << "\n\n" unless rows.empty?
end

File.write(File.join(ROOT, "lib", "ozdenui", "kit.json"), JSON.generate(kit) + "\n")
File.write(File.join(ROOT, "lib", "ozdenui", "COMPONENTS.md"), docs)
puts "kit.json and COMPONENTS.md: basic.js v#{version}, #{count} components"
