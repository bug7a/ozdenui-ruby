# 5. Components

A component is a ready part of a window, made of the objects of chapter 2: a button with a waiting clock, a field with
a title and a warning, a list with a search box, a table of 100000 rows. 83 of them have a method of their own;
`component("Name", ...)` makes any of them by its name.

## How every component works

```ruby
remember = CheckBox(label_text: "Remember me", checked: true, on_change: method(:show))
```

- **Params are named values**: the params of the kit in snake_case: `title_text:`, `selected_keys:`,
  `panel_height:`. `ozdenui doc CheckBox` in a terminal lists every param with its default and what it takes, its
  looks, the values it keeps and its methods. A wrong name is told in the terminal, with the line of your program and
  the name it was close to.
- **A param that is not written keeps the default of the kit.** `nil` is "not written"; `""` is an empty text, written
  (`label_text: ""`: a button with only an icon).
- **A callback is a param**: `on_change: method(:show)`. Like an event, it takes what it needs: `-> { }`,
  `->(box) { }`, or more. The values after the object are the ones `ozdenui doc` names:
  `on_select: ->(table, row) { puts row[:name] }` gets the row as a Hash, `on_step_click: ->(bar, index) { }` a number.
- **Its state is in Ruby**: `remember.checked?`, `select_box.value`, `field.text`, `list.selected_keys`. Reading it
  asks nothing of the page; `ozdenui doc` names what each one keeps.
- **Changing it**: `remember.checked = false`, `bar.value = 40`, `field.value = ""`, or any param by its name:
  `field.unit_text = "kg"`. A param the kit has a method for (`setUnitText`) is changed with that method, so the
  component draws itself again.
- **A method of the kit** is a method of the object, in snake_case: `list.add_item(key: "c", text: "Cherry")` (not
  waited for). One that starts with `get_`, `is_` or `has_` waits for its result: `list.get_selected_keys` (a question
  to the page, so not in a loop). What each takes is in
  [its file of the kit](https://github.com/bug7a/ozdenui-ruby/tree/main/lib/ozdenui/web/comp).
- **A change made by your code does not call the callback**; only the user's does.

## A form on two tabs

```ruby
require "ozdenui"
include OzdenUI

FORM_WIDTH = 400
QUALITIES = ["Low", "Normal", "High"].freeze

def profile_panel
  VGroup(width: "100%", height: "auto", gap: 14, padding: [0, 16], align: "left top") do
    @name = TextField(title_text: "Name", required: true, width: FORM_WIDTH)
    @language = SelectBox(options: ["English", "Türkçe", "Deutsch"], value: "English", width: FORM_WIDTH)
    @news = CheckBox(label_text: "Send me the news")
  end
end

def sound_panel
  VGroup(width: "100%", height: "auto", gap: 16, padding: [0, 16], align: "left top") do
    @volume = Slider(value: 7, min_value: 0, max_value: 10, width: FORM_WIDTH)
    HGroup(hug: true, gap: 18) do
      QUALITIES.each do |quality|
        RadioButton(group: "quality", value: quality, label_text: quality, checked: quality == "Normal")
      end
    end
    @sounds = Toggle(value: true)
  end
end

def save
  return unless @name.valid? # shows the warning on the field
  puts @name.text, @language.value, @news.checked?, @volume.value, radio_value("quality"), @sounds.checked?
  toast_success("Saved.")
end

run(title: "Settings", width: 540, height: 580) do |page|
  page.color = "#F4F5F7"
  VGroup(gap: 16, padding: 24, align: "left top") do
    Label(text: "Settings", font_size: 24, bold: true)
    VGroup(width: 460, height: "auto", padding: 20, gap: 16, align: "left top", color: "white", round: 12) do
      tabs = Tabs(tabs: ["Profile", "Sound"], panel_height: 240)
      tabs.panel("Profile") { profile_panel }
      tabs.panel("Sound") { sound_panel }
      SmartButton(label_text: "Save", tone: "cyan", on_click: method(:save))
    end
  end
end
```

`value` is the value your code gave (the `7` of the slider) until the user changes it, then the value the page tells:
a number of the page is an Integer or a Float, as JSON writes it. A flag that comes from the page is `1` / `0`:
`checked?` reads it, and `on?(value)` reads any of them. `examples/settings.rb` is a longer one with three tabs,
`examples/form.rb` a form with dates, a time and a color.

## The components, by what they do

### Buttons

| | |
|---|---|
| `SmartButton(label_text: "Save", tone: "cyan", on_click: method(:save))` | `tone:`: `"cyan"` the main action, `"orange"` a delete, `"yellow"`, `"green"`, `"blue"`, `"white"`; `"accent"`: the main action of a minimal window (chapter 7) |
| `SmartButton(label_text: "", icon_file: "plus.svg", aria_label: "Add")` | an icon button: a square |
| `button.waiting = true` | a clock on it; it takes no clicks until `button.waiting = false` |
| `SmartButton(label_text: "Delete", ask: "Click again to delete.")` | the first click asks, the second one runs `on_click` |
| `button.enabled = false`, `button.label_text = "Saved"` | |

### Fields

| | |
|---|---|
| `TextField(title_text: "Name", placeholder: "Ada", on_change: fn, on_enter: fn)` | `field.text`; `on_change` at every change, `on_enter` on Enter |
| `EmailField`, `PasswordField`, `NumberField`, `TextAreaField` | the same, for an e-mail, a password, a number, many lines |
| `required: true`, then `field.valid?` | shows the warning on the field; `true` when there is none |
| `max_length: 40`, `PasswordField(min_length: 8)` | the most and the fewest letters |
| `UrlField(title_text: "Site")` | an address, with its protocol |
| `PhoneField(...)`, `CurrencyField(unit_text: "$")` | the number in its mask; the amount in groups |
| `SearchInput(placeholder: "Find", on_change: fn)` | `fn` gets the search box at every change; `search.text` |
| `TagInput(tags: ["audio"], suggestions: [...])` | `field.tags` |

`valid?` shows the warning of one field. To show every warning of a form, check them all first, then decide:
`checks = [@name.valid?, @email.valid?]`, then `checks.all?` (with `&&` the second one would not be checked when the
first fails).

### Choices

| | |
|---|---|
| `CheckBox(label_text: "Remember me", checked: true)` | `box.checked?` |
| `Toggle(value: true)` | `toggle.checked?` |
| `RadioButton(group: "size", value: "M", label_text: "Medium")` | `radio_value("size")` |
| `SelectBox(options: ["Apple", "Pear"], value: "Pear")` | `select_box.value` |
| `Slider(value: 30, min_value: 0, max_value: 100, on_change_end: fn)` | `slider.value`; `on_change_end`: when the mouse lets it go |
| `SliderField(...)`, `Stepper(value: 2, min_value: 0, max_value: 10)` | `.value` |
| `RangeSlider(low_value: 200, high_value: 800, max_value: 1000, step: 50)` | `slider.low`, `slider.high` |
| `DatePicker(date: "2026-11-20")`, `TimePicker(time: "19:30")`, `ColorPicker(selected_color: "#3871E0")` | `.value`: `"2026-11-20"`, `"19:30"`, `"#3871E0"` |

### Lists, tables and trees

```ruby
fruits = ItemList(
  items: ["Apple", { key: "p", text: "Pear", description: "Green" }],
  selection: "multiple", height: 240,
  on_change: ->(list) { p list.selected_keys }
)
fruits.add_item(key: "c", text: "Cherry")
fruits.remove_item("p")
```

- **`ItemList`**: `list.selected_keys` (an Array of the keys), `list.selected`. A text item gets its index as its key
  (`"0"`); `enabled: false` in an item can not be chosen. `layout: "grid", style_name: "gallery"` shows pictures.
  `examples/todo.rb` is a to-do list made of one.
- **An item** is a text or a Hash. **Inside an item the keys go to the page as they are written**, so they are the
  names of the kit as the kit writes them: `text:`, `description:`, `iconFile:`, `enabled:`... (`iconFile:`, not
  `icon_file:`).
- **`SmartTable`**: very many rows (only the rows that are seen are made), a filter box and sorting. Its columns:
  `title_data_list: [{ name: "NAME", dataTitle: "name", width: 160, sortable: 1 }]`; its rows: `item_data_list:`
  (Hashes, or Structs); `on_select: ->(table, row) { }`. Chapter 8 has more.
- **`DataTable`** (`columns:`, `rows:`): a smaller table; `table.selected_row`. **`TreeView`**
  (`items: [{ key: "a", text: "A", children: ["b"] }, { key: "b", text: "B" }]`): `tree.value` is the selected key.
  **`SortableList`**: the user changes the order; `list.order` gives the keys in the new order.

### Areas that hold your objects

Some components hold objects of yours. Each gives a block of the area, as a box does:

```ruby
tabs = Tabs(tabs: ["Orders", "Customers"])
tabs.panel("Orders") { Label(text: "No orders yet") }

folds = Accordion(sections: ["General", "Advanced"])
folds.section("General") { CheckBox(label_text: "Start with the system") }

split = Splitter(first_size: 240) # two areas, a line to drag between them
split.first { Label(text: "Left") }
split.second { Label(text: "Right") }

panel = SidePanel(title_text: "Filters") # slides in from the side
panel.body { CheckBox(label_text: "Only the new ones") }
SmartButton(label_text: "Filters", on_click: -> { panel.open })
```

A tab or a section given as a text has that text as its key. A `Splitter` is as large as its box: in a group, give it
`fill: true` or a size. `ScrollArea` and `GridGroup` take their objects in their own block (chapter 3).

### The bars of a window

| | |
|---|---|
| `MenuBar(menus: [{ text: "File", items: [{ text: "Save", shortcut: "Ctrl+S", onClick: method(:save) }] }])` | in the page, in the look of the window; Ctrl is Cmd on a Mac |
| `ToolBar(items: [{ key: "save", icon: "save", hint: "Save" }, "-"], on_click: fn)` | `"-"` a line; `toggle: true` stays pressed; `fn` gets the bar and the item |
| `StatusBar(message_text: "Ready", items: ["UTF-8"])` | `bar.set_message_text("Saved", "success", 3000)`, `bar.set_busy(true)` |
| `ContextMenu(target: table, items: ["Open", "-", { text: "Delete", onClick: fn }])` | a right click on the target opens it |

A window with a menu, a tool bar, a list that takes the room and a status bar is a `VGroup` with `gap: 0` of them,
with `fill: true` on the middle part (chapter 3):

```ruby
require "ozdenui"
include OzdenUI

FILES = [
  { key: "report", text: "report.pdf", description: "120 KB" },
  { key: "photo", text: "photo.jpg", description: "2.4 MB" },
  { key: "notes", text: "notes.txt", description: "4 KB" }
].freeze

def tell(text)
  @status.set_message_text(text, "info", 2000)
end

def press_tool(_bar, item)
  tell("#{item[:hint]} was pressed")
end

def choose(list)
  tell("Chosen: #{list.selected_keys.join(', ')}")
end

run(title: "Files", width: 620, height: 420) do
  VGroup(gap: 0) do
    MenuBar(menus: [
      { text: "File", items: [
        { text: "New", shortcut: "Ctrl+N", onClick: -> { tell("New") } },
        "-",
        { text: "Close", onClick: -> { close } }
      ] }
    ])
    ToolBar(on_click: method(:press_tool), items: [
      { key: "new", icon: "new", hint: "New" },
      { key: "save", icon: "save", hint: "Save" }
    ])
    ItemList(fill: true, unframed: true, items: FILES, on_change: method(:choose))
    @status = StatusBar(message_text: "Ready", items: ["3 files"])
  end
end
```

`unframed: true` takes the border and the round corners of the list away: it fills the room between two bars.
`examples/editor.rb` and `examples/gallery.rb` are bigger windows of this kind.

### Progress and steps

| | |
|---|---|
| `ProgressBar(title_text: "Copying", value: 0)` | `bar.value = 40` |
| `LoadingScreen(title_text: "My App", message_text: "Reading...")` | covers the window; `loading.set_progress(0.4)`, `loading.close` |
| `StepBar(steps: ["Cart", "Address", "Payment"], current_step: 1)` | `bar.next`, `bar.previous`, `bar.step` |
| `Tooltip(target: button, hint_text: "Saves the file")` | a hint under the mouse; chapter 6 has its other forms |

### Views: chapter 8

`GraphBox` (charts), `LogView`, `ImageView`, `MarkdownView`, `JsonView`, `JsonEditor`, `CodeEditor`, `Canvas`,
`ChatView` and `WebView` show data, pictures, code, a conversation and web pages (`JsonEditor` and `CodeEditor` also
write them): chapter 8.

### The texts of a component

The texts a component writes itself (a warning, the buttons of a dialog, the message of an empty table) are in
English. Each one changes with a param:

```ruby
TextField(title_text: "Name", required: true, required_text: "Needed") # in the place of "Required"
confirm("The file will be deleted.", title: "Delete it?", confirm_text: "Delete", cancel_text: "Keep it", danger: true)
SmartTable(no_data_found_alert: "No records", all_titles_text: "ALL")
DatePicker(date: "2026-11-20", language: "tr") # the months and the days in Turkish
JsonEditor(texts: { addRow: "Row", search: "Search the rows", table: "Table" })
```

The text params of a component end with `_text` or say what they are (`placeholder:`, `empty_text:`); `ozdenui doc`
shows each one with its English default. The texts of a `JsonEditor` are in one `texts:` Hash, by the names of the
kit (`addRow:`).

## Any component by its name: component()

A method of its name is the easy way. `component()` makes the same component from its name; it is the way for a name
your program chooses while it runs:

```ruby
Gauge(value: 72, sub_text: "Disk")
component("Gauge", value: 35, sub_text: "Memory") # the same component, by its name
```

- The page loads a component the first time your program names it, with what it needs: a program pays only for what
  it uses. Nothing is listed before `run`.
- A name of the kit that can not be written in snake_case goes as a text, as it is: `LoginPage("tab_border" => 1)`.
- Every component, with an example of each: [the catalog](https://bug7a.github.io/js-components/) and `ozdenui doc`.
  A box inside a component, to put objects into or to call: `obj.part(:name)`.

## Next

[Chapter 6: Dialogs, messages and files](06-dialogs-and-files.md).
