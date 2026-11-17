# Bismillah
#
# ozdenui_test.rb - ozdenui v0.1 (OzdenUI: basic.js for Ruby)
# The checks of the gem: ruby test/ozdenui_test.rb. The names, the values and the table of the kit; then a real page
# played in a hidden Chrome or Edge (no window opens): objects, components, dialogs, timers, threads, a theme change.
#
# Started Date: November 2026
# Webpage: https://bug7a.github.io/ozdenui-ruby/
#
# Copyright 2026 Bugra Ozden <bugra.ozden@gmail.com> (https://bug7a.github.io/)
# Licensed under the Apache License, Version 2.0
# SPDX-License-Identifier: Apache-2.0

require "minitest/autorun"
require "json"
require "rbconfig"
require_relative "../lib/ozdenui"
require_relative "../lib/ozdenui/command"

ROOT = File.expand_path("..", __dir__)

class OzdenUITest < Minitest::Test
  Values = OzdenUI::Runtime::Values
  Kit = OzdenUI::Runtime::Kit
  Files = OzdenUI::Runtime::Files

  def test_names
    { label_text: "labelText", id: "id", on_key_down: "onKeyDown", labelText: "labelText", x: "x", item_2: "item2" }.each do |name, want|
      assert_equal want, Values.kit_name(name)
    end
    assert_equal "tab_border", Values.kit_name("tab_border"), "a text is a name of the kit as it is"
    assert_equal "label_text", Values.ruby_name("labelText")
    assert_equal "keydown", Values.event_name("onKeyDown")
    assert_equal "keydown", Values.event_name(:key_down)
    assert Values.callback_name?("onChange")
    refute Values.callback_name?("only")
    assert_equal "fontSize", Values.closest_name("fontSzie", %w[fontSize color text])
  end

  def test_values_of_a_call
    maker = OzdenUI::Runtime::Maker
    values, extra = maker.read("Label", [10, 20], { text: "Hi", gap: 0, visible: false, fill: true, font_size: nil, align: :center })
    assert_equal({ "left" => 10, "top" => 20, "text" => "Hi", "gap" => 0, "visible" => false, "align" => "center" }, values)
    assert_equal({ "fill" => true }, extra)
    values, = maker.read("Tabs", [{ "tab_border" => 1 }], { width: 200 })
    assert_equal({ "tab_border" => 1, "width" => 200 }, values)
    assert_raises(OzdenUI::Runtime::Error) { maker.read("Label", [:oops], {}) }
  end

  def test_number_format
    {
      "{:,.2f} TL" => ["", " TL", 1, 2, 0], "$ {:,}" => ["$ ", "", 1, nil, 0], "{:.1%}" => ["", "", 0, 1, 1],
      "{} kg" => ["", " kg", 0, nil, 0], "{:d}" => ["", "", 0, 0, 0]
    }.each { |pattern, want| assert_equal want, OzdenUI.number_format(pattern).to_a, pattern }
    assert_raises(OzdenUI::Runtime::Error) { OzdenUI.number_format("no place") }
  end

  def test_reading_values
    assert OzdenUI.on?(1)
    assert OzdenUI.on?("yes")
    refute OzdenUI.on?(0)
    refute OzdenUI.on?("0")
    refute OzdenUI.on?(nil)
    assert_equal "300", Values.text_of(300.0)
    assert_equal "1.5", Values.text_of(1.5)
    data = JSON.parse('{"name": "Ali", "in": {"x": 1}}', object_class: OzdenUI::Runtime::Data)
    assert_equal ["Ali", "Ali", 1, true], [data[:name], data["name"], data.dig(:in, :x), data.key?(:name)]
  end

  def test_files_of_this_computer
    { "" => nil, ".pdf,.docx" => %w[pdf docx], ".CSV, .txt" => %w[csv txt], "image/*" => %w[png jpg jpeg gif webp svg bmp],
      "nobody/knows" => nil, ".pdf, nobody/x" => nil, "image/png" => %w[png] }.each do |accept, want|
      if want.nil?
        assert_nil Files.file_types_of(accept), accept
      else
        assert_equal want, Files.file_types_of(accept), accept
      end
    end
    file = Files.file_for_page(File.join(ROOT, "LICENSE"), false)
    assert_equal "LICENSE", file["name"]
    assert_equal File.join(ROOT, "LICENSE"), file["path"]
    assert file["size"].positive?
    assert_nil Files.file_for_page(File.join(ROOT, "lib"), false)
    assert_nil Files.file_for_page("no-such-file", false)
  end

  def test_picture
    svg = OzdenUI.picture(%(<?xml version="1.0"?><svg xmlns="http://www.w3.org/2000/svg"></svg>))
    png = OzdenUI.picture("\x89PNG\r\n\x1a\n".b)
    icon = OzdenUI.picture(File.join(ROOT, "lib", "ozdenui", "icon.png"))
    assert svg.start_with?("data:image/svg+xml;base64,")
    assert png.start_with?("data:image/png;base64,")
    assert icon.start_with?("data:image/png;base64,iVBOR")
    assert_equal "https://example.com/a.png", OzdenUI.picture("https://example.com/a.png")
  end

  def given_to(*args)
    args
  end

  def test_call_handler
    got = []
    Values.call_handler(-> { got << "none" }, [:obj, 3])
    Values.call_handler(->(obj) { got << obj }, [:obj, 3])
    Values.call_handler(->(obj, count, missing) { got << [obj, count, missing] }, [:obj, 3])
    Values.call_handler(->(obj, *rest) { got << rest }, [:obj, 1, 2])
    Values.call_handler(proc { |obj, count| got << [obj, count] }, [:obj, 3, 4])
    Values.call_handler(->(obj, count = 9) { got << count }, [:obj])
    got << Values.call_handler(method(:given_to), [:obj, 5])
    Values.call_handler(nil, [])
    assert_equal ["none", :obj, [:obj, 3, nil], [1, 2], [:obj, 3], 9, [:obj, 5]], got
    assert_raises(OzdenUI::Runtime::Error) { Values.check_handler("save", "on_click") }
  end

  # tools/spec.json names only what the kit has (a renamed param of the kit shows here).
  def test_kit_table
    props = Kit::OBJECT_PROPS
    Kit::SPECS.each do |name, spec|
      spec.sync.each { |callback| assert_includes spec.params, callback, "#{name}: the state callback #{callback} is not a param of the kit (renamed?)" }
      spec.aliases.each do |short, long|
        assert spec.params.include?(long) || props.include?(long) || long == "styleName", "#{name}: the short name #{short} names #{long}, which is not a param of the kit"
      end
      spec.defaults.each_key do |key|
        assert spec.params.include?(key) || props.include?(key) || key == "styleName", "#{name}: the default #{key} is not a param of the kit"
      end
    end
    assert_equal ["setValue", false], Kit["TextField"].setters["value"]
    assert_equal true, Kit["CheckBox"].setters["checked"][1]
    assert_operator Kit.component_names.length, :>, 80
    assert_respond_to OzdenUI, :SmartButton
    # A name of a component must not be a method of the gem with another job
    clash = Kit.component_names.map(&:to_sym) & %i[Box Label Button Input Icon VGroup HGroup]
    assert_empty clash
  end

  # A method of UIObject hides a method of the kit of the same name (list.remove is "remove it", not a kit call).
  def test_methods_of_the_kit_stay_reachable
    own = OzdenUI::Runtime::UIObject.public_instance_methods(false).map { |name| Values.kit_name(name) }
    allowed = %w[focus remove add call set get show hide addFiles place] # the same job, or reached with obj.call(:name)
    hidden = Kit::SPECS.flat_map { |name, spec| (spec.methods & own).map { |method| "#{name}.#{method}" } }
    hidden.reject! { |entry| allowed.include?(entry.split(".").last) }
    assert_empty hidden, "methods of the kit hidden by a method of UIObject"
  end

  # The files of the gem start with Bismillah and carry the notice (the rule of the project).
  # Ruby 4.0 removed CGI.parse (the gem did not start there): no part of cgi in the gem.
  def test_no_cgi
    uses = Dir["lib/**/*.rb", "exe/*"].select { |path| File.read(path) =~ /\bCGI\b|require "cgi/ }
    assert_empty uses
  end

  # Edge signed the profile of the program into the Microsoft account and synced the passwords into it (winpc).
  def test_browser_stays_private
    %w[lib/ozdenui/window.rb lib/ozdenui/look.rb].each do |path|
      assert_includes File.read(path), "*Window::PROFILE_FLAGS", path
    end
    assert_includes OzdenUI::Runtime::Window::PROFILE_FLAGS, "--disable-sync"
    assert_includes File.read("lib/ozdenui/web/index.html"), %(<meta name="google" content="notranslate">)
  end

  def test_headers
    files = Dir[File.join(ROOT, "lib", "**", "*.rb")] + Dir[File.join(ROOT, "{tools,test}", "*.rb")] + [File.join(ROOT, "exe", "ozdenui")]
    assert_operator files.length, :>, 12
    files.each do |path|
      text = File.read(path, encoding: "UTF-8")
      assert text.sub(/\A#!.*\n/, "").start_with?("# Bismillah\n"), "#{path} does not start with Bismillah"
      assert_includes text, "SPDX-License-Identifier: Apache-2.0", path
      assert_includes text, "Copyright 2026 Bugra Ozden", path
    end
    Dir[File.join(ROOT, "examples", "*.rb")].each do |path|
      assert File.read(path, encoding: "UTF-8").start_with?("# Bismillah\n# "), "#{path}: Bismillah, then one comment line"
    end
  end

  # The texts people and assistants read name only what the gem has.
  def test_documents
    readme = File.read(File.join(ROOT, "README.md"), encoding: "UTF-8")
    table = readme[/\| For \| Methods \|.*?\n\n/m]
    refute_nil table, "README.md: the table of the components"
    table.scan(/`([A-Z][A-Za-z]+)`/).flatten.each { |name| assert Kit[name], "README.md: #{name} is not a component of the kit copy" }
    rules = File.read(File.join(ROOT, "lib", "ozdenui", "AGENTS.md"), encoding: "UTF-8")
    program = rules[/```ruby\n(require "ozdenui".*?)```/m, 1]
    example = File.read(File.join(ROOT, "examples", "notes.rb"), encoding: "UTF-8")
    assert example.end_with?(program), "the program of AGENTS.md is not examples/notes.rb (the example is the one that is run and pictured)"
    rules.scan(/\| [A-Z][^|]+\| (.*) \|/).flatten.join.scan(/`([A-Z][A-Za-z]+)`/).flatten.each do |name|
      assert Kit[name], "AGENTS.md: #{name} is not a component of the kit copy"
    end
    gemspec = File.read(File.join(ROOT, "ozdenui.gemspec"), encoding: "UTF-8")
    assert_includes gemspec, "OzdenUI::VERSION"
  end

  def test_command
    text = OzdenUICommand.with_rules("# Mine\n")
    assert text.start_with?("# Mine\n\n<!-- ozdenui-ruby: start")
    assert_equal text, OzdenUICommand.with_rules(text), "the second run changes nothing"
    assert_includes OzdenUICommand.sections["SelectBox"], "`options:`"
  end

  # *** THE WINDOW:

  def equal(what, got, want)
    @problems << "#{what}: got #{got.inspect}, want #{want.inspect}" unless got == want
  end

  # Lets the page and the tasks of the program work for a while.
  def pause(milliseconds)
    done = false
    OzdenUI.after(milliseconds) { done = true }
    OzdenUI.app.wait_for { done }
  end

  def click(obj)
    OzdenUI.evaluate("#{obj.js}.elem.click(); 0")
    pause(60)
  end

  def type_into(input_js, text)
    OzdenUI.evaluate("#{input_js}.value = #{text.to_json}; #{input_js}.dispatchEvent(new Event('input', { bubbles: true })); 0")
    pause(80)
  end

  def test_window
    skip "no Chrome, Edge or Chromium on this computer" unless OzdenUI::Runtime::Window.find_browser
    ENV["OZDENUI_WINDOW"] = "headless"
    @problems = []
    finished = false
    guard = Thread.new do
      sleep(90)
      @problems << "the window test did not end in 90 seconds"
      OzdenUI.close
    end
    starts = 0
    OzdenUI.run(title: "Test", width: 900, height: 700) do |page|
      starts += 1
      if starts == 2
        # set_theme made the page again: the block runs again, in the dark window
        box = OzdenUI.CheckBox(label_text: "Dark")
        equal "the theme of the second start", [OzdenUI.theme, OzdenUI.dark?, box.style_name, page.measure(:color)], ["dark", true, "dark", "#1C1C1B"]
        finished = true
        OzdenUI.close
      else
        window_objects(page)
        window_components
        window_dialogs
        window_tasks
        OzdenUI.set_theme("dark")
      end
    end
    guard.kill
    assert_empty @problems
    assert finished, "the program of the test did not reach its end"
  end

  def window_objects(page)
    ui = OzdenUI
    equal "the size of the page", [page.width, page.height], [900, 700]
    equal "the title of the page", ui.evaluate("document.title"), "Test"
    equal "page is the page", ui.page, page
    clicks = 0
    label = button = input = inner = nil
    group = ui.VGroup(gap: 10, padding: 20, align: "left top") do |itself|
      equal "the block of a group gets the group", [itself.type_name, ui.current], ["VGroup", itself]
      label = ui.Label(text: "<b>plain</b>", font_size: 20)
      button = ui.Button(text: "Press", width: 120, on_click: lambda { |obj, event|
        clicks += 1
        obj.text = "Pressed #{clicks} #{event.name}"
      })
      input = ui.Input(width: 200, placeholder: "A name")
      ui.Box(width: 100, height: 50, color: "#DDD") { inner = ui.Label(text: "in") }
    end
    equal "a text is not HTML", ui.evaluate("#{label.js}.elem.innerText"), "<b>plain</b>"
    equal "the font size", [label.measure(:font_size), label.font_size], [20, 20]
    equal "an object in a Box stands at its corner", [inner.measure(:left), inner.measure(:top)], [0, 0]
    equal "a group does not cut", ui.evaluate("#{group.js}.elem.style.overflow"), "visible"
    click(button)
    click(button)
    equal "the clicks", clicks, 2
    equal "the text of the button", button.text, "Pressed 2 click"
    label.set(html: "<i>x</i>", text_color: "red")
    equal "html is HTML", ui.evaluate("#{label.js}.elem.querySelector('i') !== null"), true
    equal "a value read back", [label.text_color, label.html, label.get(:text_color), label[:text_color]], ["red", "<i>x</i>", "red", "red"]
    type_into("#{input.js}.inputElement", "Ali")
    equal "the text of an Input comes with its event", input.text, "Ali"
    keys = []
    remove_handler = input.on(:key_down) { |_obj, event| keys << event.key }
    press_key = "#{input.js}.inputElement.dispatchEvent(new KeyboardEvent('keydown', { key: 'a', bubbles: true })); 0"
    ui.evaluate(press_key)
    pause(60)
    remove_handler.call
    ui.evaluate(press_key)
    pause(60)
    equal "a handler of on() and its remover", keys, ["a"]
    group.add { ui.Label(text: "later") }
    equal "an object made later is in its group", ui.evaluate("#{group.js}.elem.children.length"), 5
    label.hide
    equal "hide", [label.visible?, label.measure(:visible)], [false, 0]
    problem = begin
      label.add { ui.Label(text: "no") }
    rescue OzdenUI::Runtime::Error => error
      error.message
    end
    equal "a Label holds no objects", problem.to_s.include?("can not hold other objects"), true
    problem = begin
      label.no_such_thing(1)
    rescue NoMethodError => error
      error.message
    end
    equal "a wrong name is told", problem.to_s.include?("no_such_thing is not a value or a method of Label"), true
    inner.remove
    ui.flush
    equal "a removed object is forgotten", ui.app.objects[inner.id], nil
    group.remove
  end

  def window_components
    ui = OzdenUI
    changes = []
    check = field = slider = select_box = tabs = table = toggle = list = nil
    ui.ScrollArea(gap: 10, padding: 20, align: "left top") do
      check = ui.CheckBox(label_text: "Agree", on_change: ->(obj) { changes << "check #{obj.checked?}" })
      toggle = ui.Toggle(value: true)
      field = ui.TextField(title_text: "Name", value: "Ali", width: 200)
      slider = ui.Slider(value: 30, width: 200)
      select_box = ui.SelectBox(options: %w[Red Green], value: "Green")
      list = ui.ItemList(width: 200, height: 120, selected_keys: ["b"], items: [{ key: "a", text: "Apple" }, { key: "b", text: "Banana" }])
      tabs = ui.Tabs(tabs: [{ key: "one", text: "One" }, { key: "two", text: "Two" }])
      tabs.panel("one") { ui.Label(text: "Panel one") }
      table = ui.SmartTable(width: 300, height: 160, item_line_count: 3,
                            title_data_list: [{ name: "ID", dataTitle: "id", width: 60 }, { name: "NAME", dataTitle: "name", width: 140 }],
                            item_data_list: [{ id: 1, name: "Ali" }, { "id" => 2, "name" => "Can" }])
      ui.component("Gauge", value: 72, width: 120, height: 100)
    end
    equal "the state of the start", [check.checked?, toggle.checked?, field.text, slider.value, select_box.value, tabs.value],
          [false, true, "Ali", 30, "Green", "one"]
    equal "the selected item of the list", list.get_selected_keys, ["b"]
    rows = table.measure(:item_data_list)
    equal "the rows of the table", rows, [{ "id" => 1, "name" => "Ali" }, { "id" => 2, "name" => "Can" }]
    equal "a row is read with a symbol too", rows[1][:name], "Can"
    equal "a panel of the tabs holds its label", ui.evaluate("#{tabs.js}.elem.innerText.includes('Panel one')"), true

    # A change of the user tells the program; a change of the program does not call on_change.
    click(check)
    equal "the click of the user", [check.checked?, changes], [true, ["check true"]]
    check.checked = false
    field.value = "Veli"
    field.title_text = "Full name"
    slider.value = 250
    select_box.value = "Nope"
    pause(80)
    equal "on_change is not called by the program", changes.length, 1
    equal "the page keeps what the program gave", [check.measure(:checked), field.get_value, field.measure(:title_text)], [0, "Veli", "Full name"]
    equal "the page corrects a value, and the program reads it", [slider.value, select_box.value], [100, nil]
    list.add_item(key: "c", text: "Cherry")
    equal "a method of the kit", list.ask(:get_items).length, 3
    check.on_change = ->(obj) { changes << "new #{obj.checked?}" }
    click(check)
    equal "a callback given later replaces the first", changes, ["check true", "new true"]

    low = high = date = number = grid = wide = editor = nil
    ui.VGroup(hug: true, gap: 6) do
      low = ui.RadioButton(label_text: "Low", group: "level", value: "low", checked: true)
      high = ui.RadioButton(label_text: "High", group: "level", value: "high")
      date = ui.DatePicker(date: "2026-11-16")
      number = ui.NumberField(value: 250, width: 120)
      grid = ui.GridGroup(columns: 2, width: 200) do |itself|
        wide = ui.Label(text: "wide")
        itself.place(wide, column_span: 2)
      end
      editor = ui.CodeEditor(width: 200, height: 60, value: "x = 1")
    end
    click(high)
    equal "the radio buttons of a group", [low.checked?, high.checked?, ui.radio_value("level")], [false, true, "high"]
    low.checked = true
    equal "a radio checked by the program", [high.checked?, ui.radio_value("level")], [false, "low"]
    equal "the value of a DatePicker is its date", date.value, "2026-11-16"
    date.value = "2026-12-01"
    pause(80)
    equal "the value of a DatePicker set later", [date.value, ui.evaluate("#{date.js}.getDate().getDate()")], ["2026-12-01", 1]
    type_into("#{number.js}.input.inputElement", "300")
    equal "the value of a NumberField follows the user", number.value.to_s, "300"
    equal "a span in a grid", ui.evaluate("#{wide.js}.elem.style.gridColumn.includes('span 2')"), true
    equal "the grid", grid.measure(:columns), 2
    editor.theme = "dark"
    equal "the theme of one object", editor.measure(:style_name), "dark"
    hint = ui.show_hint(low, "A hint", 0)
    equal "a hint is on the page", ui.evaluate("document.body.innerText.includes('A hint')"), true
    hint.remove
    equal "a removed hint", ui.evaluate("document.body.innerText.includes('A hint')"), false
    equal "a field that is right", field.valid?, true

    # A text typed by the user is read without a question.
    type_into("#{field.js}.input.inputElement", "Typed")
    equal "the text of a field", [field.text, field.value], ["Typed", "Typed"]
    entered = []
    field.on_enter = ->(obj) { entered << obj.text }
    ui.evaluate("#{field.js}.input.elem.dispatchEvent(new KeyboardEvent('keydown', { key: 'Enter', bubbles: true })); 0")
    pause(60)
    equal "the Enter key of a field", entered, ["Typed"]
  end

  def window_dialogs
    ui = OzdenUI
    # The dialog waits for its answer while the window works: a timer of the program presses its button.
    press = lambda do |text|
      ui.after(250) do
        ui.evaluate(%{Array.from(document.querySelectorAll("button, [role=button]")).filter(function (b) { return b.innerText.trim() === "#{text}"; }).forEach(function (b) { b.click(); }); 0})
      end
    end
    press.call("Confirm")
    equal "confirm: yes", ui.confirm("Delete it?"), true
    press.call("Cancel")
    equal "confirm: no", ui.confirm("Delete it?"), false
    press.call("Later")
    equal "ask", ui.ask("Save the changes?", "Save", "Later"), "Later"
    press.call("OK")
    equal "prompt", ui.prompt("Name:", value: "Ali"), "Ali"
    press.call("Cancel")
    equal "prompt: cancelled", ui.prompt("Name:"), nil
    ui.toast("Saved.")
    pause(100)
    equal "a toast is on the page", ui.evaluate("document.body.innerText.includes('Saved.')"), true
  end

  def window_tasks
    ui = OzdenUI
    order = []
    timer = ui.every(20) { order << "tick" }
    ui.after(70) do
      order << "once"
      timer.stop
    end
    Thread.new { ui.ui { order << "ui" } }
    pause(200)
    # WHY not a count of ticks: a slow machine (the macOS runners of CI) runs fewer of them in the same time; what must
    # hold is that the timer ran, that it stopped, and that ui { } came first.
    once_at = order.index("once")
    ticked = order.include?("tick")
    stopped = once_at && !order[(once_at + 1)..-1].include?("tick")
    @problems << "the timers and ui { }: #{order.inspect}" unless ticked && stopped && order.first == "ui"
    # Another thread may not change an object: it is told how.
    label = ui.Label(text: "x")
    told = Thread.new do
      begin
        label.text = "no"
        nil
      rescue OzdenUI::Runtime::Error => error
        error.message
      end
    end.value
    equal "a change from another thread", told.to_s.include?("ui { ... }"), true
    # A block that fails is told in the terminal; the window goes on.
    was = $stderr
    $stderr = StringIO.new
    ui.after(10) { raise "a block that fails" }
    pause(80)
    said = $stderr.string
    $stderr = was
    equal "a failed block is told", said.include?("a task failed: a block that fails"), true
  end
end
