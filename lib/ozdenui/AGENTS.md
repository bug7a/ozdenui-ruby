# OzdenUI for Ruby: rules for an AI assistant

This project uses **OzdenUI** (`gem install ozdenui`): desktop windows written in plain Ruby. It is a new library, so
do not guess from Shoes, Tk, Glimmer, GTK or a web framework: there is no widget tree to build, no layout manager
object, no HTML, no CSS file and no JavaScript to write. Everything below is the whole way of working.

## Where the truth is

- **The params of a component:** `ozdenui doc SelectBox` in a terminal (every param with its default and what it
  takes, its looks, the values it gives back, its methods). Read it before you use a component for the first time.
  `ozdenui doc` lists every component.
- **Example programs:** https://github.com/bug7a/ozdenui-ruby/tree/main/examples (`gallery.rb` shows the main components).

## A program

```ruby
require "ozdenui"
include OzdenUI

PAGE_COLOR = "#F4F5F7"

@notes = [] # the data of the program is plain Ruby

def add_note
  typed = @name.text.strip # the state is in the program: reading asks nothing of the window
  if typed.empty?
    toast("Write a note first.", type: :warning)
    return
  end
  @notes << typed
  @list.add { Label(text: typed, font_size: 15) } # objects made later go into a box the same way
  @empty.hide
  @name.value = ""
  @count.text = "Notes: #{@notes.length}"
end

# Once, at the end of the program. The block runs when the window is ready: make the objects here.
run(title: "Notes", width: 480, height: 420) do |page|
  page.color = PAGE_COLOR
  VGroup(gap: 0) do # a group is as large as its box: here the whole window
    HGroup(height: 60, padding: [16, 0], gap: 10, align: "left center", color: "white") do
      @name = TextField(placeholder: "A new note", width: 260, on_enter: method(:add_note))
      SmartButton(label_text: "Add", tone: "cyan", on_click: method(:add_note))
    end
    @list = ScrollArea(padding: 16, gap: 10, align: "left top") do # takes the room that is left
      @empty = Label(text: "No notes yet", font_size: 15)
    end
    @count = Label(text: "Notes: 0", font_size: 13, height: 28)
  end
end
```

- `include OzdenUI` gives the short names (`Label(...)`, `run`, `toast`); without it every name is
  `OzdenUI.Label(...)`, `OzdenUI.run`. An object maker starts with a capital letter: `Label(text: "x")`,
  `VGroup(gap: 8) do ... end`, `VGroup do ... end`. Alone, with no value and no block, it needs its brackets: `Box()`.
- `run(title:, width:, height:, theme: "light" | "dark" | "auto", style: "minimal", accent: "#2A78D6")`; `width` and
  `height` are the size of the page. `close`, `set_title("...")`, `theme`, `dark?`. `language: "tr"` when the texts of
  the window are not English (the capital letters of Turkish: "İ").
- Objects are made in the block of `run` or later (an event, a timer), never before `run`. `run` returns when the
  window is closed.
- Keep the objects the program changes later in variables: `@name` (an instance variable is seen by the block and by
  the methods of the file) or a local variable the lambdas see. In a bigger program: a class of your own, with
  `OzdenUI.run { App.new.start }`.

## Objects and values

- Five plain objects: `Box`, `Label`, `Button`, `Input`, `Icon`. The rest are components (below): `CheckBox(...)`.
- **The names are the names of basic.js and the kit, in snake_case:** `fontSize` is `font_size:`, `labelText` is
  `label_text:`, `onClick` is `on_click:`. A value is a named value when the object is made and a setter later:
  `label.text = "Hi"`, `label.font_size = 20`, or more at once: `label.set(text: "Hi", font_size: 20)`.
- Reading: `label.text`, `field.text`, `select_box.value`, `box.checked?`, `list.selected_keys`:
  what the program gave, or what the window told. A value that was never given is `nil`.
- Every object: `color:` (the background), `border:`, `border_color:`, `round:`, `opacity:`, `visible:`, `width:`,
  `height:`, `css: { letterSpacing: "1px" }`. A size is a number (px) or a text: `"100%"`, `"auto"`. Flags take
  `true` / `false`.
- A value that is not written keeps the default of the kit; `nil` is "not written" (`""` is an empty text, written).
- `text:` is shown exactly as written (a `<b>` stays `<b>`); HTML goes in as `html:`.
- `obj.remove` removes it for good; to hide it for a while: `obj.hide`, `obj.show`.
- **Inside a table or a list (an item, a row, a column) the keys go to the window as they are written:** write them as
  the kit does (`{ key: "tr", text: "Türkiye", iconFile: "tr.png" }`), and the keys of your own rows as you like. Only
  the keys of a look (`style:`, `css:`) may be snake_case.

## Layout

- **Only a `Box`, a group and the areas of some components hold objects**: the objects made inside their block go
  into them. Later: `box.add { ... }`.
- `VGroup` (one under the other), `HGroup` (side by side), `GridGroup(columns: 4)`: `gap:`, `padding:` (`20` or
  `[x, y]`), `align:` (`"center"` is the default; `"left top"`, `"right center"`...), `wrap: true`.
- **A group is `width: "100%"`, `height: "100%"` by default.** A group inside another one almost always needs one
  of: `hug: true` (as large as its objects), `height: "auto"` / a number, or `fill: true` (the room the others leave:
  the height in a `VGroup`, the width in an `HGroup`). Two groups of 100% in one `VGroup` squeeze each other.
- A typical window: `VGroup(gap: 0) do ... end` holding a bar of a fixed height, a middle part with `fill: true` (or a
  `ScrollArea`, which takes the room by itself and scrolls), a line at the bottom.
- The block of a group gets the group: `GridGroup(columns: 4) { |grid| wide = SmartButton(...); grid.place(wide, column_span: 2) }`.
- In a group an object needs only its size. In a `Box` or on the page it has a place: `Box(20, 20, 200, 120, color: "white")`
  (left, top, width, height) or `left:`, `top:` (for a game or a drawing).

## Events

- `on_click: -> { ... }` or `on_click: method(:save)` when the object is made, `obj.on_click = -> { ... }` later,
  `obj.on(:key_down) { |obj, event| ... }` for one more handler (it returns a lambda that removes it). The page
  listens to the window: `page.on(:key_down) { |_page, event| ... }`, `page.on(:resize) { ... }`.
- A handler takes what it needs: `-> { }`, `->(obj) { }` or `->(obj, event) { }` (`event.key`, `event.x`, `event.y`,
  `event.shift`...).
- A component tells a change with a callback param: `on_change: ->(box) { puts box.checked? }`. The values after the
  object are the ones the kit names (`ozdenui doc`): `on_select: ->(table, row) { }`. **A change made by the code does
  not call it**, only the user's does.
- Everything runs one at a time on one thread, so no locks; but a slow block freezes the window. Never `sleep` in an
  event: `after(ms) { ... }` once, `every(ms) { ... }` again and again (both return a timer: `timer.stop`). A slow job
  (a download, a big file, an AI call) runs in a thread of its own and changes the objects only inside `ui { ... }`:

```ruby
Thread.new do
  text = download            # the window does not wait
  ui { @label.text = text }  # back on the thread of the window
end
```

## Components

Each is a method of its name; its state is read from the program (`field.text`, `select_box.value`, `box.checked?`,
`list.selected_keys`: `ozdenui doc` names them).

| For | Methods |
|---|---|
| Buttons | `SmartButton` (`label_text:`, `tone: "cyan"` main / `"orange"` delete / `"accent"`, `on_click:`) |
| Fields | `TextField`, `EmailField`, `PasswordField`, `NumberField`, `CurrencyField`, `PhoneField`, `UrlField`, `TextAreaField`, `SearchInput`, `TagInput` (`title_text:`, `placeholder:`, `value:`, `on_enter:`, `on_change:`) |
| Choices | `CheckBox`, `Toggle`, `RadioButton`, `SelectBox` (`options:`, `value:`), `Slider`, `SliderField`, `RangeSlider` (`low_value:`, `high_value:`; read `obj.low`, `obj.high`), `Stepper`, `DatePicker` (`date:`), `TimePicker` (`time:`), `ColorPicker` (`selected_color:`); the others give `obj.value` |
| Lists and tables | `ItemList` (`items:`), `SortableList`, `TreeView`, `SmartTable` (`title_data_list:`, `item_data_list:`: very many rows), `DataTable` |
| Areas that hold objects | `ScrollArea`, `GridGroup` (with a block), `Tabs` (`tabs.panel(key) { ... }`), `Accordion` (`acc.section(key) { ... }`), `Splitter` (`split.first { ... }`, `split.second { ... }`), `SidePanel` (`panel.body { ... }`) |
| Bars | `MenuBar`, `ToolBar`, `StatusBar`, `ContextMenu` |
| Messages | `alert`, `confirm`, `prompt`, `ask`, `toast`, `Tooltip`, `LoadingScreen`, `ProgressBar`, `StepBar` |
| Views | `GraphBox` (charts), `LogView`, `ImageView`, `MarkdownView`, `JsonView`, `JsonEditor`, `CodeEditor`, `Canvas`, `ChatView`, `WebView`, `FilePicker`, `Gauge` |

- A dialog returns its answer, like a question in a terminal: `if confirm("Delete it?", danger: true)`,
  `name = prompt("Name:")` (`nil`: cancelled), `alert("Saved.")`, `ask("Save?", "Save", "Don't save", "Cancel")` (the
  text of the pressed button, `nil`: closed). The window keeps working while the code waits.
- `toast("Saved.")` never waits; `type: :success` (default), `:error`, `:warning`, `:info`; `title:`.
- The file dialogs of the system: `open_file`, `open_files`, `save_file`, `choose_folder` return a real path or `nil`
  (`open_files`: a list); `open_file(title:, directory:, types: %w[png jpg])`, `save_file(file_name: "notes.txt")`.
  A click on a `FilePicker` opens that dialog too: `picker.paths` are the chosen files (a dropped file has no path).
- A picture (`Icon(picture: "photo.png")`, a param whose name ends with `_file`: `icon_file:`, `image_file:`) takes a
  path of this computer; in another place (an item of a list): `picture("photo.png")`, also of the text of an SVG or
  of bytes (`File.binread`).
- A param of the kit changes later with its setter (`gauge.unit_text = "kg"`); a method of the kit is a method of the
  object in snake_case: `list.add_item(key: "a", text: "A")` (not waited for); one that starts with `get_`, `is_` or
  `has_` returns its result (`list.get_selected_keys`: a question to the window, not in a loop). Any method:
  `obj.call(:method_name, values)`, `obj.ask(:method_name)`. What each takes is in its file of the kit:
  https://github.com/bug7a/ozdenui-ruby/tree/main/lib/ozdenui/web/comp
- What comes from the window (a row in a callback, the result of `ask`): a table is a Hash read with a text or a
  symbol (`row["name"]`, `row[:name]`), a flag of the kit is `1` / `0`, not `true` / `false`: `on?(value)` reads it.
- A big or fast value is asked, not kept: the text of a `CodeEditor` (`editor.get_value`), the value of a
  `JsonEditor`, the selected row of a `SmartTable` (`table.measure(:selected_item_data)`).
- The columns of a `SmartTable`: `title_data_list: [{ name: "NAME", dataTitle: "name", dataType: "string", width: 160,
  sortable: 1 }]`; its rows: `item_data_list: rows` (Hashes), later `table.item_data_list = rows`.
- Small helpers: `field.valid?` (shows the warning of a field, true when its text is right), `radio_value(group)` (the
  `value:` of the checked `RadioButton`), `show_hint(obj, "Copied", 1500)` (a bubble for a while),
  `log_view.writer(:info)` (an output like `$stdout`, from any thread), `obj.style_name = "dark"` (the look of one bar,
  editor or view while the program runs), `obj.measure(:width)` (a value as the window has it now).
- A picture given to a method is an address: `view.set_image(picture(path))`.
- A number a component writes (`format_value:` of a `GraphBox`, `value_format:` of a `Stepper`) takes a text like
  `"{:,.2f} TL"` (1,234.50 TL), `"{:.0f} kg"`, `"{:.1%}"`: not a block.
- A method of the kit named like a method every Ruby object has (`send` of a `ChatView`, `display`, `method`) is
  called with `obj.call(:send, text)`. Do not name your own top-level methods like the ones of Ruby (`send`, `format`,
  `display`, `open`, `test`) or of OzdenUI (`run`, `close`, `ask`, `page`, `after`).
- An icon may be the text of an SVG: `icon_file: picture(svg_text)`.
- A name of the kit that is not snake_case goes as a text: `LoginPage("tab_border" => 1)`. Any component by its name:
  `component("Gauge", value: 72)`.

## Looks

- `run(theme: "dark")`: every component takes its dark look by itself. For your own colors:
  `text_color = dark? ? "#9AA3B5" : "#5A6270"`.
- `run(style: "minimal", accent: "#2A78D6")`: a small look made of lines, in one color; the main button is
  `tone: "accent"`.
- `set_theme("dark")` changes the theme while the program runs: the page is made again and the block of `run` runs
  again, so every object is new and the timers set before are gone. Keep the data in variables outside the block,
  fill the objects from them in the block, and set the timers there.
- One component: `style_name: "..."` (`ozdenui doc` names its packages), or `style: { box: { color: "#FFF" } }`;
  `unframed: true`: no border and no rounded corners (a table or an editor that fills the room between two bars).
- Keep the colors of a program as constants at the top of its file.

## Mistakes to avoid

1. A nested group without `hug: true`, `fill: true` or a height (see Layout).
2. Changing an object from a thread of your own: it raises with the fix (`ui { ... }`).
3. Waiting in an event (`sleep`, a download): the window freezes.
4. Reading a value that was never given (`label.width` of an `"auto"` label) is `nil`: `obj.measure(:width)` asks the
   window. Keep `measure` and the `get_...` methods out of loops.
5. Putting an object into a `Label` or a button. Make it next to it, in the same box.
6. A name that does not exist. The terminal says it with the line of the program
   (`ozdenui: app.rb:12: Label: font_szie is not a value of Label (did you mean font_size?)`): run the program and
   **read the terminal**. An error in a block is told there too (`ozdenui: a task failed: ...`); the window stays open.
7. A kit name in snake_case inside an item or a column (`icon_file:` in an item of a list): there it is `iconFile:`.
8. Colors written for a light window only, in a program that may open dark.
9. A callback that must answer at once (a validator that returns `false`) can not be a block of the program.
10. Saying a window is right without a look at it (below).

## Running and checking

- **Look at the window you made:** `OZDENUI_LOOK=app.png ruby app.rb` runs the program as it is, saves a picture of
  its window as `app.png` and ends. Read the picture: a program that runs without an error can still have a part
  covered, cut or squeezed. `OZDENUI_THEME=dark OZDENUI_LOOK=dark.png OZDENUI_LOOK_WAIT=3 ruby app.rb`: the dark
  window, more seconds before the picture. (It needs Chrome, Edge or Chromium on the computer; no window opens.)
- `ruby app.rb` opens a real window and returns when it is closed. To check a program without a person, close it from
  the code: `after(3000) { close }` as the first line of the block of `run`, then read the terminal.
- A check that plays the program from code must not reach a dialog: it waits for a person.
- `run(debug: true)` gives the developer tools of the web view (right click > Inspect Element).
- macOS: the window is the web view of the system. Windows and Linux: the app window of Edge, Chrome or Chromium. The gem needs
  no other gem and no compiler; Ruby 2.6 or newer (also the Ruby that comes with macOS).
