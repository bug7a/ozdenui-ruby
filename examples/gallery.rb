# Bismillah
# The gallery: the main components on one page, in two columns of cards; the line at the bottom says what was changed last (OZDENUI_THEME=dark opens it dark; the Dark / Light button draws it again in the other theme).
require "ozdenui"
include OzdenUI

CARD_WIDTH = 440

# The colors of this page in each theme. (The components take their look from the theme of the window.)
LIGHT_COLORS = { page: "#F4F5F7", card: "#FFFFFF", soft: "#5A6270", line: "#E1E3E6" }.freeze
DARK_COLORS = { page: "#141413", card: "#232322", soft: "rgba(255, 255, 255, 0.6)", line: "rgba(255, 255, 255, 0.12)" }.freeze

PEOPLE = [
  { id: 1, name: "Ayşe Yılmaz", city: "İstanbul", age: 34 },
  { id: 2, name: "Mehmet Kaya", city: "Ankara", age: 41 },
  { id: 3, name: "Zeynep Demir", city: "İzmir", age: 28 },
  { id: 4, name: "Can Öztürk", city: "Bursa", age: 52 }
].freeze

COLUMNS = [
  { name: "Name", dataTitle: "name", width: 180, sortable: 1 },
  { name: "City", dataTitle: "city", width: 120, sortable: 1 },
  { name: "Age", dataTitle: "age", width: 70, dataType: "integer", sortable: 1 }
].freeze

PRODUCTS = [
  { name: "Honey", price: 150, in_stock: true },
  { name: "Olive oil", price: 420, in_stock: false },
  { name: "Tea", price: 95, in_stock: true }
].freeze

PICTURE = '<svg xmlns="http://www.w3.org/2000/svg" width="320" height="200"><rect width="320" height="200" fill="#DCEFF1"/>' \
          '<circle cx="160" cy="100" r="60" fill="#5BBAC1"/></svg>'

CODE = "def hello(name):\n    print(\"Hello\", name)  # a comment\n\nhello(\"world\")\n"

# A page of HTML with its own script: a click sends a message to the program (on_message of the WebView).
WEB_PAGE = <<~HTML
  <body style="margin: 16px; font: 15px -apple-system, 'Segoe UI', sans-serif">
  <p style="margin: 0 0 12px">An HTML page with its own script.</p><button id="send">Send to Ruby</button>
  <script>let count = 0; send.onclick = function () { parent.postMessage({count: ++count}, "*"); };</script></body>
HTML

MARKDOWN_NOTE = "### A small report\n\nThe **sales** went up. Read the [notes](https://example.com/notes).\n\n" \
                "| Product | Total |\n|:---|---:|\n| Honey | 3,150 TL |\n\n- [x] Write it\n- [ ] Send it\n\n" \
                "```python\ntotal = sum(rows)\n```\n"

# The state that stays when the page is drawn again for the other theme.
@wrap_lines = true
@size = "M"

# A small picture made here (an SVG): a ground and a sun.
def picture_of(ground, sun)
  picture('<svg xmlns="http://www.w3.org/2000/svg" width="200" height="200">' \
          "<rect width=\"200\" height=\"200\" fill=\"#{ground}\"/><circle cx=\"100\" cy=\"90\" r=\"46\" fill=\"#{sun}\"/>" \
          "<rect y=\"150\" width=\"200\" height=\"50\" fill=\"#{sun}\" opacity=\"0.5\"/></svg>")
end

def tell(text)
  @status.message_text = text
end

def press_tool(bar, item)
  if item["key"] == "theme"
    set_theme(dark? ? "light" : "dark") # the block of run runs again
    return
  end
  name = item["hint"] || item["text"]
  tell("#{name}, pressed: #{bar.checked_keys.inspect}")
end

def toggle_wrap(bar)
  @wrap_lines = !@wrap_lines
  @logs.wrap_lines = @wrap_lines
  bar.set_item_checked("wrap", @wrap_lines)
  tell("Word wrap: #{@wrap_lines}")
end

# A card with a title; the objects of the block go under the title.
def card(title)
  VGroup(width: CARD_WIDTH, height: "auto", align: "left top", gap: 14, padding: 20, color: @colors[:card], round: 12) do
    Label(text: title, font_size: 13, bold: true, text_color: @colors[:soft])
    yield
  end
end

# A column of cards.
def column(&cards)
  VGroup(width: CARD_WIDTH, height: "auto", align: "left top", gap: 20, &cards)
end

def draw_cards
  Label(text: "OzdenUI: the components", font_size: 24, bold: true)
  # WHY one row of two columns: a new row started under the taller column and left an empty area beside the shorter one.
  HGroup(width: "auto", height: "auto", align: "left top", gap: 20) do
    column { draw_first_column }
    column { draw_second_column }
  end
end

def draw_first_column
  card("SmartButton") do
    HGroup(hug: true, gap: 8) do
      SmartButton(label_text: "Save", tone: "cyan", on_click: -> { toast_success("Saved.") })
      SmartButton(label_text: "Cancel", on_click: -> { tell("Cancel was clicked.") })
      SmartButton(label_text: "Delete", tone: "orange", on_click: method(:ask_delete))
    end
  end

  card("CheckBox, Toggle, RadioButton") do
    CheckBox(label_text: "Remember me", checked: true,
             on_change: ->(box) { tell("Remember me: #{box.checked?}") })
    HGroup(hug: true, gap: 10, align: "left center") do
      Toggle(value: true, on_change: ->(toggle) { tell("Notifications: #{toggle.checked?}") })
      Label(text: "Notifications", font_size: 15)
    end
    HGroup(hug: true, gap: 18) do
      ["S", "M", "L"].each do |choice|
        RadioButton(group: "size", value: choice, label_text: choice, checked: choice == @size,
                    on_change: lambda {
                      @size = choice
                      tell("Size: #{@size}")
                    })
      end
    end
  end

  card("SelectBox, SliderField") do
    SelectBox(options: ["İstanbul", "Ankara", "İzmir", "Bursa"], value: "Ankara", width: "100%",
              on_change: ->(box) { tell("City: #{box.value}") })
    SliderField(label_text: "Volume", value: 6, min_value: 0, max_value: 10, width: "100%",
                on_change_end: ->(slider) { tell("Volume: #{slider.value}") })
  end

  card("ProgressBar") do
    bar = ProgressBar(title_text: "Uploading", value: 40, width: "100%")
    HGroup(hug: true, gap: 8) do
      SmartButton(label_text: "+10", on_click: -> { bar.add_value(10) })
      SmartButton(label_text: "Reset", on_click: -> { bar.value = 0 })
    end
  end

  card("LogView") do
    @logs = LogView(height: 170, wrap_lines: @wrap_lines, lines: [
      { text: "Started", level: "info" },
      { text: "14 files found", level: "success" },
      { text: "A file is very large", level: "warn" },
      { text: "A file can not be read", level: "error" }
    ])
    SmartButton(label_text: "Write a line", on_click: -> { @logs.info("A new line") })
  end

  card("Splitter") do
    Box(width: "100%", height: 120, color: "transparent", border: 1, border_color: @colors[:line], round: 8) do
      split = Splitter(first_size: "40%")
      split.first do
        Label(text: "Drag the line", font_size: 14, text_color: @colors[:soft], padding: 10)
      end
      split.second do
        Label(text: "The other area", font_size: 14, text_color: @colors[:soft], padding: 10)
      end
    end
  end

  card("Tabs") do
    tabs = Tabs(tabs: ["General", "Advanced"], on_change: ->(t) { tell("Tab: #{t.value}") })
    tabs.panel("General") { Label(text: "The general settings.", font_size: 14) }
    tabs.panel("Advanced") { Label(text: "The advanced settings.", font_size: 14) }
  end

  card("TextField, EmailField, PasswordField, NumberField") do
    TextField(title_text: "Name", placeholder: "Ada", width: "100%", on_change: ->(field) { tell("Name: #{field.text}") })
    EmailField(title_text: "E-mail", width: "100%")
    PasswordField(title_text: "Password", width: "100%")
    NumberField(title_text: "Count", value: 3, width: "100%", on_change: ->(field) { tell("Count: #{field.text}") })
  end

  card("SearchInput, Slider, Stepper") do
    SearchInput(width: "100%", on_change: ->(search) { tell("Search: #{search.text}") })
    Slider(value: 30, width: "100%", on_change_end: ->(slider) { tell("Slider: #{slider.value}") })
    Stepper(value: 2, min_value: 0, max_value: 10, on_change: ->(stepper) { tell("Stepper: #{stepper.value}") })
  end

  card("StepBar") do
    StepBar(steps: ["Cart", "Address", "Payment"], current_step: 1,
            on_step_click: lambda { |bar, index|
              bar.set_step(index)
              tell("Step: #{index + 1}")
            })
  end

  card("RangeSlider") do
    RangeSlider(low_value: 200, high_value: 800, max_value: 1000, step: 50, width: "100%", format_value: "{:,.0f} TL",
                on_change_end: ->(slider) { tell("Range: #{slider.low} - #{slider.high}") })
  end

  card("DatePicker, TimePicker, ColorPicker") do
    HGroup(hug: true, gap: 10) do
      DatePicker(date: "2026-11-20", width: 140, on_change: ->(picker) { tell("Date: #{picker.value}") })
      TimePicker(time: "19:30", width: 110, on_change: ->(picker) { tell("Time: #{picker.value}") })
      ColorPicker(selected_color: "#3871E0", width: 130, on_change: ->(picker) { tell("Color: #{picker.value}") })
    end
  end

  card("GridGroup") do
    GridGroup(columns: 3, gap: 8) do |grid|
      (1..6).each do |number|
        button = SmartButton(label_text: "Cell #{number}", width: "100%", on_click: -> { tell("A cell was clicked.") })
        grid.place(button, column_span: 2) if number == 4
      end
    end
  end

  card("UrlField, PhoneField, CurrencyField") do
    UrlField(title_text: "Site", width: "100%", on_change: ->(field) { tell("Site: #{field.text}") })
    PhoneField(title_text: "Phone", width: "100%", on_change: ->(field) { tell("Phone: #{field.text}") })
    CurrencyField(title_text: "Price", unit_text: "$", width: "100%", on_change: ->(field) { tell("Price: #{field.text}") })
  end

  card("SortableList") do
    SortableList(width: "100%", height: "auto",
                 items: ["Sales", "Stock", { key: "pay", text: "Payments", description: "Every Monday" }],
                 on_change: ->(list) { tell("Order: #{list.order.inspect}") })
  end

  card("WebView") do
    WebView(html_text: WEB_PAGE, width: "100%", height: 110,
            on_message: ->(_view, data) { tell("WebView: #{data['count']}") })
  end

  card("ChatView") do
    ChatView(width: "100%", height: 300,
             messages: [{ role: "user", text: "Hello!" }, "Hi! **How** can I help?"],
             on_send: ->(chat, text) { chat.add_message("You wrote: #{text}") })
  end
end

def draw_second_column
  card("TextAreaField") do
    TextAreaField(title_text: "Note", placeholder: "Write something...", width: "100%", height: 110,
                  on_change: ->(note) { tell("Note: #{note.text.length} letters") })
  end

  card("ItemList") do
    ItemList(width: "100%", height: 170,
             items: [
               { key: "a", text: "Apples", description: "Red" },
               { key: "p", text: "Pears", description: "Green" },
               { key: "g", text: "Grapes", description: "Purple" }
             ],
             on_change: ->(list) { tell("Fruit: #{list.selected_keys.inspect}") })
  end

  card("ItemList: pictures") do
    ItemList(layout: "grid", width: "100%", height: "auto", selected_keys: ["sun"],
             style_name: "gallery",                          # WHY no "galleryDark": a dark window takes it
             style: { tile: { width: 120, icon_size: 104 } }, # WHY: three in the row of this card
             items: [
               { key: "sea", text: "Sea", iconFile: picture_of("#DCEFF1", "#3F8D94") },
               { key: "sun", text: "Sun", iconFile: picture_of("#FBEBD3", "#E0913A") },
               { key: "wood", text: "Wood", iconFile: picture_of("#E3EEDC", "#5E8C4A") }
             ],
             on_change: ->(list) { tell("Picture: #{list.selected_keys.inspect}") })
  end

  card("Canvas") do
    Canvas(width: "100%", height: 170,
           shapes: [
             { key: "ground", type: "rect", x: 0, y: 125, width: CARD_WIDTH, height: 45, fill: "#E3EEDC" },
             { key: "hill", type: "polygon", points: [[20, 125], [80, 55], [140, 125]], fill: "#9DBE8C" },
             { key: "path", type: "line", x1: 170, y1: 150, x2: 330, y2: 150, color: "#5E8C4A", lineWidth: 3, dash: [8, 5] },
             { key: "sun", type: "circle", x: 300, y: 55, radius: 24, fill: "#E0913A", draggable: 1 },
             { key: "title", type: "text", x: 16, y: 12, text: "Drag the sun", fontSize: 15, bold: 1 }
           ],
           on_shape_move: ->(_canvas, shape) { tell("Moved: #{shape['key']}") },
           on_click: lambda { |_canvas, _x, _y, shape|
             if shape.nil?
               tell("Canvas: empty")
             else
               tell("Canvas: #{shape['key']}")
             end
           })
  end

  card("SmartTable") do
    SmartTable(title_data_list: COLUMNS, item_data_list: PEOPLE, width: "100%", height: 230, fit_line_count: true,
               on_select: ->(_table, row) { tell("Row: #{row['name']}") })
  end

  card("ImageView") do
    ImageView(height: 170, image_file: picture(PICTURE), enlarge_to_fit: true, alt_text: "A circle on a square")
  end

  card("CodeEditor") do
    CodeEditor(height: 150, language: "python", value: CODE)
  end

  card("GraphBox") do
    GraphBox(type: "bar", labels: ["Jan", "Feb", "Mar", "Apr"], values: [1200, 1900, 700, 1500],
             width: "100%", height: 210, format_value: "{:,.0f} TL",
             on_click: ->(_graph, item) { tell("Bar: #{item['label']}") })
  end

  card("TreeView, ContextMenu") do
    tree = TreeView(width: "100%", height: 130,
                    items: [
                      { key: "photos", text: "photos", expanded: 1, children: ["sea.jpg", "hill.jpg"] },
                      { key: "notes", text: "notes.txt", description: "4 KB" }
                    ],
                    on_select: ->(_tree, node) { tell("Node: #{node['text']}") })
    ContextMenu(target: tree, items: [
      { text: "Open them all", onClick: -> { tree.expand_all } },
      "-",
      { text: "Close them all", onClick: -> { tree.collapse_all } }
    ])
  end

  card("Tooltip") do
    HGroup(hug: true, gap: 8) do
      hint_button = SmartButton(label_text: "A hint")
      Tooltip(target: hint_button, hint_text: "A hint on the button")
      bubble_button = SmartButton(label_text: "A bubble", on_click: -> { show_bubble(bubble_button) })
      popover_button = SmartButton(label_text: "A popover")
      Tooltip(target: popover_button, trigger: "click", hint_position: "bottom", look: bubble_look,
              hint_text: "It stays until a click outside.")
    end
  end

  card("Accordion") do
    folds = Accordion(sections: [{ key: "more", text: "More settings", description: "2", opened: 1 }, "Closed at the start"],
                      on_toggle: ->(accordion) { tell("Open: #{accordion.open_keys.inspect}") })
    folds.section("more") { CheckBox(label_text: "Save it by itself", checked: true) }
    folds.section("Closed at the start") do
      Label(text: "It was made while it was closed.", font_size: 14, text_color: @colors[:soft])
    end
  end

  card("MarkdownView") do
    MarkdownView(height: 250, markdown_text: MARKDOWN_NOTE,
                 on_link_click: ->(_view, address) { tell("Link: #{address}") },
                 style: { box: { color: "transparent" }, page: { padding: [0, 0] } })
  end

  card("JsonView") do
    JsonView(height: 170, expand_level: 2,
             value: { status: "ok", count: 2, users: [{ name: "Ada", active: true }] },
             on_select: ->(_view, entry) { tell("Path: #{entry['pathText']}") },
             style: { box: { color: "transparent" } })
  end

  card("JsonEditor") do
    JsonEditor(height: 340, value: PRODUCTS, title_text: "Products", on_change: method(:count_products))
  end

  card("FilePicker") do
    FilePicker(width: "100%", zone_height: 110, multiple: true,
               on_change: ->(picker) { tell("Files: #{(picker.files || []).length}") })
  end
end

# The frame of a bubble: the bubble of the kit is white with no line, so on a white card only its text was seen.
def bubble_look
  if dark?
    return { color: "#2A2A29", textColor: "rgba(255, 255, 255, 0.86)", border: 1, borderColor: "rgba(255, 255, 255, 0.14)",
             round: 10, padding: [16, 14], shadow: "0 10px 30px rgba(0, 0, 0, 0.4)" }
  end
  { color: "#FFFFFF", textColor: "rgba(0, 0, 0, 0.85)", border: 1, borderColor: "rgba(0, 0, 0, 0.12)",
    round: 10, padding: [16, 14], shadow: "0 10px 30px rgba(0, 0, 0, 0.12)" }
end

# A bubble at the button that goes by itself.
def show_bubble(button)
  show_hint(button, "It goes by itself.", 1500)
end

# on_change of the JsonEditor: the whole value, as a list of products.
def count_products(_editor, list)
  in_stock = list.count { |item| item["in_stock"] }
  tell("Products: #{list.length}, #{in_stock} in stock")
end

def ask_delete
  if confirm("The file will be deleted.", title: "Delete it?", confirm_text: "Delete", danger: true)
    tell("Deleted.")
  else
    tell("Not deleted.")
  end
end

run(title: "OzdenUI gallery", width: 1000, height: 820) do |page|
  @colors = dark? ? DARK_COLORS : LIGHT_COLORS
  page.color = @colors[:page]
  VGroup(gap: 0, align: "left top") do
    MenuBar(menus: [
      { text: "File", items: [
        { text: "New", shortcut: "Ctrl+N", onClick: -> { tell("New was chosen.") } },
        "-",
        { text: "Recent", items: ["a.txt", "b.txt"] }
      ] },
      { text: "View", items: [{ text: "Word wrap", key: "wrap", checked: @wrap_lines, onClick: method(:toggle_wrap) }] },
      { text: "Help", items: [{ text: "About", onClick: -> { tell("About was chosen.") } }] }
    ])
    theme_text = dark? ? "Light" : "Dark" # it names the other theme
    ToolBar(on_click: method(:press_tool), items: [
      { key: "new", icon: "new", hint: "New" },
      { key: "save", icon: "save", hint: "Save" },
      "-",
      { key: "bold", icon: "bold", hint: "Bold", toggle: true },
      { key: "left", icon: "alignLeft", hint: "Align left", group: "align", checked: true },
      { key: "right", icon: "alignRight", hint: "Align right", group: "align" },
      "-",
      { key: "insert", text: "Insert", items: ["A picture", "A table"] },
      " ",
      { key: "theme", text: theme_text },
      { key: "run", icon: "play", text: "Run", shortcut: "F9" }
    ])
    ScrollArea(align: "center top", gap: 20, padding: 30) { draw_cards }
    @status = StatusBar(message_text: "Change something.", items: ["UTF-8", { key: "count", text: "53 components" }])
  end
end
