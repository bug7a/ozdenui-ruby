/* Bismillah */

/*

OzdenUI for Ruby Website - Samples - v26.11

The Ruby code of the page (shown, not run) and the commands of the terminal.
NOTE: SAMPLES.counter is examples/counter.rb of the gem (its picture is images/counter.webp), SAMPLES.own the code of
tools/shots/card.rb (images/card.webp) and SAMPLES.others the code of tools/shots/gauge.rb (images/gauge.webp):
change them together (each without its two lines of comments at the top). The pictures are made by
tools/make-images.sh from the real windows.
Every whole program here runs: put it into a file and run it with OZDENUI_LOOK=x.png ruby file.rb.

Started Date: November 2026
Webpage: https://bug7a.github.io/ozdenui-ruby/

Copyright 2026 Bugra Ozden <bugra.ozden@gmail.com> (https://bug7a.github.io/)
Licensed under the Apache License, Version 2.0
SPDX-License-Identifier: Apache-2.0

*/

"use strict";

const SAMPLES = {};

SAMPLES.counter = [
    'require "ozdenui"',
    'include OzdenUI',
    '',
    'PAGE_COLOR = "#F4F5F7"',
    '',
    '@count = 0',
    '',
    'def add(step)',
    '  @count += step',
    '  @label.text = @count.to_s',
    'end',
    '',
    'run(title: "Counter", width: 360, height: 260) do |page|',
    '  page.color = PAGE_COLOR',
    '  VGroup(gap: 16) do',
    '    @label = Label(text: "0", font_size: 48)',
    '    HGroup(hug: true, gap: 10) do',
    '      SmartButton(label_text: "Minus", on_click: -> { add(-1) })',
    '      SmartButton(label_text: "Plus", tone: "cyan", on_click: -> { add(1) })',
    '    end',
    '  end',
    'end',
].join("\n");

SAMPLES.dialogs = [
    'def replace_file',
    '  if confirm("The old copy will be replaced.", title: "Replace it?", confirm_text: "Replace")',
    '    write_the_new_copy',
    '    toast("Replaced.")',
    '  end',
    'end',
    '',
    '# the text, or nil when it is cancelled',
    'name = prompt("A name for the folder:", value: "Photos")',
    '',
    '# the text of the pressed button',
    'choice = ask("Save the changes?", "Save", "Don\'t save", "Cancel")',
    '',
    '# the file dialog of the system: a real path, or nil',
    'path = open_file(types: %w[csv])',
].join("\n");

SAMPLES.others = [
    'require "ozdenui"',
    'include OzdenUI',
    '',
    'run(title: "Disk", width: 460, height: 240) do',
    '  HGroup(gap: 24) do',
    '    # the method of the component: the params of the kit in snake_case',
    '    Gauge(value: 72, sub_text: "Disk")',
    '    # the same component by its name',
    '    component("Gauge", value: 35, sub_text: "Memory")',
    '  end',
    'end',
].join("\n");

SAMPLES.own = [
    'require "ozdenui"',
    'include OzdenUI',
    '',
    '# A component of this program: a title, a text and a button.',
    'class Card',
    '  attr_reader :box',
    '',
    '  # Makes a card in the group it is called in.',
    '  def initialize(title, text, &on_open)',
    '    @box = VGroup(width: 220, height: "auto", align: "left top", padding: 16, gap: 8, color: "white", round: 12) do',
    '      @title = Label(text: title, font_size: 18, bold: true)',
    '      Label(text: text, text_color: "#5A6270")',
    '      SmartButton(label_text: "Open", on_click: -> { on_open.call(self) })',
    '    end',
    '  end',
    '',
    '  # Changes its title.',
    '  def title=(text)',
    '    @title.text = text',
    '  end',
    'end',
    '',
    'run(title: "Cards", width: 760, height: 240) do |page|',
    '  page.color = "#F4F5F7"',
    '  HGroup(gap: 16, padding: 24, wrap: true) do',
    '    %w[Sales Stock Orders].each do |name|',
    '      Card.new(name, "Updated today.") { |card| card.title = "Opened" }',
    '    end',
    '  end',
    'end',
].join("\n");

// One line (or a few) for each component of the COMPONENTS section (the same order as the texts)
SAMPLES.componentLines = {
    SmartButton: 'SmartButton(\n  label_text: "Save",\n  tone: "cyan",\n  on_click: method(:save))',
    TextField: 'TextField(\n  title_text: "Name",\n  on_enter: method(:save))\nsend_it if email.valid?',
    "UrlField, PhoneField": 'UrlField(value: "github.com")\nCurrencyField(value: 1234.5)',
    TextAreaField: 'TextAreaField(\n  title_text: "Note",\n  show_count: true)',
    SearchInput: 'SearchInput(\n  on_change: method(:find))',
    CheckBox: 'agree = CheckBox(\n  label_text: "I agree")\nagree.checked?',
    Toggle: 'Toggle(value: true,\n  on_change: ->(t) { })',
    RadioButton: 'RadioButton(group: "size",\n  value: "M")\nradio_value("size")',
    SelectBox: 'SelectBox(\n  options: options,\n  searchable: true)',
    "Slider, RangeSlider": 'Slider(value: 5,\n  max_value: 10)\nRangeSlider(\n  low_value: 2,\n  high_value: 8)',
    Stepper: 'Stepper(value: 2,\n  max_value: 10)',
    DatePicker: 'DatePicker(\n  on_change: ->(d) { })\nTimePicker(time: "19:30")',
    FilePicker: 'FilePicker(multiple: true,\n  on_change: ->(f) { })\npath = open_file',
    "ProgressBar, StepBar": 'bar.value = 40\nStepBar(steps: steps,\n  current_step: 1)',
    ItemList: 'ItemList(items: items)',
    SortableList: 'SortableList(\n  items: items,\n  on_change: ->(l) { })',
    SmartTable: 'SmartTable(\n  title_data_list: columns,\n  item_data_list: people)',
    TreeView: 'TreeView(items: nodes,\n  on_select: ->(t) { })',
    Tabs: 'tabs.panel("general") do\n  # its objects\nend',
    Accordion: 'accordion.section("more") do\n  # its objects\nend',
    GridGroup: 'GridGroup(columns: 3) do\n  # the cells\nend',
    GraphBox: 'GraphBox(\n  type: "bar",\n  values: sales,\n  format_value:\n    "{:,.0f} TL")',
    LogView: 'out = log_view.writer(:info)\nlog_view.error(\n  "It failed")',
    ImageView: 'view.set_image(\n  picture("photo.png"))',
    Canvas: 'canvas.add_circle(\n  100, 80, 30,\n  draggable: 1)',
    "MarkdownView, JsonView": 'view.append_text(\n  "The next words")\nJsonView(value: answer)',
    JsonEditor: 'JsonEditor(\n  value: products,\n  on_change: ->(e) { })',
    ChatView: 'chat.append_text(\n  key, piece)',
    WebView: 'WebView(html_text: html)',
    "MenuBar, ToolBar": 'MenuBar(menus: menus)\nToolBar(items: tools)',
    "StatusBar, Splitter": 'bar.set_message_text(\n  "Saved")\nsplitter.first do\n  # the left area\nend',
    CodeEditor: 'code = editor.get_value',
    "ContextMenu, Tooltip": 'Tooltip(target: button,\n  hint_text: "Saves")',
    "Dialog, toast": 'if confirm("Delete?")\n  toast("Done")\nend',
};

SAMPLES.dark = [
    'run(theme: "dark") do |page| # "light", "dark", "auto"',
    '  # the same objects',
    'end',
].join("\n");

SAMPLES.install = 'gem install ozdenui';

SAMPLES.gemInstall = 'gem install ozdenui';

SAMPLES.hello = [
    'require "ozdenui"',
    'include OzdenUI',
    '',
    'run(title: "Hello") do',
    '  VGroup do',
    '    Label(text: "Hello, window!", font_size: 32)',
    '  end',
    'end',
].join("\n");

SAMPLES.run = [
    'ruby hello.rb',
    '',
    '# a picture of the window, without a window',
    'OZDENUI_LOOK=hello.png ruby hello.rb',
].join("\n");

SAMPLES.agents = [
    '# the rules of OzdenUI for your assistant, into AGENTS.md',
    'ozdenui agents',
    '',
    '# a picture of the window, without a window',
    'OZDENUI_LOOK=app.png ruby app.rb',
].join("\n");

