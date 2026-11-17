# Bismillah
# The minimal look of every component that has it, on one page (run(style: "minimal")): small, made of lines, the main action the only filled button; OZDENUI_THEME=dark: the minimalDark looks.
require "ozdenui"
include OzdenUI

COLUMN_WIDTH = 420
FIELD_WIDTH = 260
LOADING_TIME = 1500 # ms: the loading screen of this page stays this long

# The colors of this page in each theme. (The components take their look from the window.)
LIGHT_COLORS = { ground: "#FFFFFF", caption: "rgba(0, 0, 0, 0.45)", text: "rgba(0, 0, 0, 0.85)", line: "rgba(0, 0, 0, 0.2)" }.freeze
DARK_COLORS = { ground: "#1A1A19", caption: "rgba(255, 255, 255, 0.45)", text: "rgba(255, 255, 255, 0.88)", line: "rgba(255, 255, 255, 0.18)" }.freeze

PEOPLE = [
  { name: "Ada Lovelace", city: "London", orders: 12 },
  { name: "Alan Turing", city: "Manchester", orders: 7 },
  { name: "Grace Hopper", city: "New York", orders: 21 }
].freeze

# A line icon (24 x 24) as an SVG; SmartButton draws it white in a dark window.
def line_icon(paths)
  picture('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="#000000" stroke-width="2" ' \
          'stroke-linecap="round" stroke-linejoin="round">' + paths + "</svg>")
end

ICON_SAVE = '<path d="M5 4h11l3 3v13H5z"/><path d="M8 4v5h7V4M8 20v-6h8v6"/>'.freeze
ICON_MORE = '<circle cx="5" cy="12" r="1"/><circle cx="12" cy="12" r="1"/><circle cx="19" cy="12" r="1"/>'.freeze

# The small title over a part of the page.
def caption(text)
  Label(text: text, font_size: 11, bold: true, text_color: @colors[:caption])
end

def tell(text)
  @status.message_text = text
end

def draw_buttons
  caption("BUTTONS")
  HGroup(hug: true, align: "left center", gap: 8) do
    SmartButton(label_text: "Save", icon_file: line_icon(ICON_SAVE), on_click: -> { tell("Save was clicked.") })
    SmartButton(label_text: "Send", tone: "accent", on_click: -> { toast_success("Sent.") })
    SmartButton(label_text: "Delete", style_name: "minimalDanger", ask: "Click again to delete.",
                on_click: -> { tell("Deleted.") })
    SmartButton(label_text: "", icon_file: line_icon(ICON_MORE), aria_label: "More", on_click: -> { tell("More was clicked.") })
  end
  HGroup(hug: true, align: "left center", gap: 8) do
    SmartButton(label_text: "Disabled", enabled: false)
    SmartButton(label_text: "Waiting", waiting: true)
  end
end

def draw_choices
  caption("CHOICES")
  HGroup(hug: true, align: "left center", gap: 20) do
    CheckBox(label_text: "Remember me", checked: true, on_change: ->(box) { tell("Remember me: #{box.checked?}") })
    CheckBox(label_text: "Send the news", on_change: ->(box) { tell("Send the news: #{box.checked?}") })
  end
  HGroup(hug: true, align: "left center", gap: 20) do
    ["Monthly", "Yearly"].each do |plan|
      RadioButton(group: "plan", value: plan, label_text: plan, checked: plan == "Monthly",
                  on_change: -> { tell("Plan: #{plan}") })
    end
  end
  HGroup(hug: true, align: "left center", gap: 10) do
    Toggle(value: true, on_change: ->(toggle) { tell("Sounds: #{toggle.checked?}") })
    Label(text: "Sounds", font_size: 13, text_color: @colors[:text])
  end
end

def draw_fields
  caption("FIELDS")
  EmailField(title_text: "E-mail", placeholder: "name@mail.com", width: FIELD_WIDTH)
  PasswordField(title_text: "Password", value: "secret", width: FIELD_WIDTH)
  TextAreaField(title_text: "Note", placeholder: "A few words", width: FIELD_WIDTH, height: 96,
                on_change: ->(area) { tell("Note: #{area.text.length} letters") })
  SearchInput(placeholder: "Search", width: FIELD_WIDTH, on_change: ->(search) { tell("Search: #{search.text}") })
  SelectBox(options: ["Apple", "Banana", "Cherry", "Grape"], value: "Apple", width: FIELD_WIDTH,
            on_change: ->(box) { tell("Fruit: #{box.value}") })
  Stepper(value: 3, min_value: 0, max_value: 10, on_change: ->(stepper) { tell("Count: #{stepper.value}") })
end

def draw_lists
  caption("LIST, SLIDER, PROGRESS, TABS")
  ItemList(items: [{ key: "p", text: "Projects" }, { key: "d", text: "Designs" }, { key: "a", text: "Archive" }],
           selected_keys: ["d"], width: FIELD_WIDTH, height: "auto",
           on_change: ->(list) { tell("Folder: #{list.selected_keys.inspect}") })
  Slider(value: 40, min_value: 0, max_value: 100, width: FIELD_WIDTH,
         on_change_end: ->(slider) { tell("Slider: #{slider.value}") })
  ProgressBar(title_text: "Uploading files", value: 62, width: FIELD_WIDTH)
  Tabs(tabs: ["General", "Sound", "Advanced"], panels: false, width: 300,
       on_change: ->(tabs) { tell("Tab: #{tabs.value}") })
end

def draw_pickers
  caption("PICKERS, FIELDS")
  HGroup(width: "100%", height: "auto", align: "left center", gap: 8, wrap: true) do
    DatePicker(date: "2026-11-12", width: 140, on_change: ->(picker) { tell("Date: #{picker.value}") })
    TimePicker(time: "14:30", width: 100, on_change: ->(picker) { tell("Time: #{picker.value}") })
    ColorPicker(selected_color: "#3871E0", width: 130, on_change: ->(picker) { tell("Color: #{picker.value}") })
  end
  SliderField(label_text: "Size", value: 40, min_value: 0, max_value: 100, unit_text: " px", width: FIELD_WIDTH,
              on_change_end: ->(slider) { tell("Size: #{slider.value}") })
  TagInput(width: "100%", tags: ["audio", "guide"], suggestions: ["audio", "fitness", "guide", "travel"],
           on_change: ->(field) { tell("Tags: #{field.tags.inspect}") })
  FilePicker(multiple: true, width: "100%", on_change: ->(picker) { tell("Files: #{(picker.files || []).length}") })
end

def draw_steps_and_areas
  caption("STEPS, SECTIONS, AREAS")
  StepBar(steps: ["Cart", "Address", "Payment", "Done"], current_step: 2, width: "100%",
          on_step_click: ->(_bar, index) { tell("Back to step #{index + 1}") })
  settings = Accordion(width: "100%", height: "auto", sections: [
    { key: "general", text: "General", description: "3 settings", opened: 1 },
    { key: "advanced", text: "Advanced" },
    { key: "locked", text: "Locked", enabled: 0 }
  ])
  settings.section("general") do
    CheckBox(label_text: "Open with the system")
    CheckBox(label_text: "Look for updates", checked: true)
  end
  Box(width: "100%", height: 80, color: "transparent", border: 1, border_color: @colors[:line], round: 4) do
    Splitter(first_size: 160, on_change_end: -> { tell("The line was moved.") })
  end
end

def draw_conversation
  caption("CONVERSATION")
  ChatView(width: "100%", height: 300,
           messages: [
             { role: "user", text: "How do I count the lines of a file?" },
             "Read the file and count its lines:\n\n```python\nlines = open(\"notes.txt\").read().splitlines()\nprint(len(lines))\n```"
           ],
           on_send: ->(chat, text) { chat.add_message("You wrote: #{text}") })
end

def draw_tree_and_tables
  caption("TREE, TABLES, RANGE")
  TreeView(value: "app", width: FIELD_WIDTH, height: "auto",
           items: [
             { key: "src", text: "src", expanded: 1, children: [{ key: "app", text: "app.py", description: "4 KB" }, "lib"] },
             { key: "readme", text: "README.md", tag: "new" }
           ],
           on_select: ->(_tree, node) { tell("File: #{node['text']}") })
  SmartTable(item_line_count: 3, width: "100%", height: "auto", item_data_list: PEOPLE,
             title_data_list: [
               { name: "Name", dataTitle: "name", width: 150, sortable: 1 },
               { name: "City", dataTitle: "city", width: 120, sortable: 1 },
               { name: "Orders", dataTitle: "orders", width: 80, dataType: "integer", sortable: 1 }
             ],
             on_select: ->(_table, row) { tell("Row: #{row['name']}") })
  DataTable(rows: PEOPLE, width: "100%", height: 124,
            columns: [
              { key: "name", title: "Name", width: 150 },
              { key: "city", title: "City", width: 120 },
              { key: "orders", title: "Orders", width: 80, align: "right", type: "number" }
            ],
            on_select: lambda { |_table, row|
              if row.nil?
                tell("No person")
              else
                tell("Person: #{row['data']['name']}")
              end
            })
  RangeSlider(low_value: 20, high_value: 70, width: FIELD_WIDTH,
              on_change_end: ->(slider) { tell("Range: #{slider.low} - #{slider.high}") })
end

def draw_chart
  caption("CHART")
  GraphBox(type: "line", title_text: "Visits", labels: ["Jun", "Jul", "Aug", "Sep", "Oct", "Nov"], width: "100%", height: 220,
           datasets: [
             { label: "2026", data: [12, 19, 7, 15, 22, 18] },
             { label: "2025", data: [8, 11, 9, 12, 14, 13] }
           ])
end

def draw_over_the_page
  caption("OVER THE PAGE")
  side_panel = SidePanel(side: "right", panel_size: 300, title_text: "Filters")
  side_panel.body do
    CheckBox(label_text: "Only the new ones", checked: true)
    CheckBox(label_text: "With a picture")
  end
  HGroup(width: "100%", height: "auto", align: "left center", gap: 8, wrap: true) do
    hint = SmartButton(label_text: "A hint")
    Tooltip(target: hint, hint_text: "Save the file (Ctrl+S)")
    SmartButton(label_text: "A dialog", on_click: method(:ask_delete))
    SmartButton(label_text: "A toast", on_click: -> { toast_success("report.pdf is saved.", title: "Saved") })
    SmartButton(label_text: "A side panel", on_click: -> { side_panel.open })
    SmartButton(label_text: "Loading", on_click: method(:show_loading))
  end
end

def ask_delete
  return unless confirm("report.pdf goes to the trash.", title: "Delete the file?", confirm_text: "Delete", danger: true)
  tell("The file is deleted.")
end

# A loading screen over the whole window; close lets it go after LOADING_TIME.
def show_loading
  loading = LoadingScreen(title_text: "My App", message_text: "Loading the data...", min_duration: LOADING_TIME, remove_on_close: true)
  loading.close
end

run(title: "OzdenUI minimal", width: 1000, height: 820, style: "minimal") do |page|
  @colors = dark? ? DARK_COLORS : LIGHT_COLORS
  page.color = @colors[:ground]
  VGroup(gap: 0, align: "left top") do
    MenuBar(menus: [
      { text: "File", items: [{ text: "Open", shortcut: "Ctrl+O" }, { text: "Save", shortcut: "Ctrl+S" }, "-",
                              { text: "Quit", enabled: false }] },
      { text: "Edit", items: ["Undo", "Redo", "-", { text: "Transform", items: ["Upper case", "Lower case"] }] },
      { text: "View", items: [{ text: "Word wrap", checked: true }] }
    ])
    ToolBar(items: [
              { key: "new", icon: "new", hint: "New" },
              { key: "save", icon: "save", hint: "Save", shortcut: "Ctrl+S" },
              "-",
              { key: "bold", icon: "bold", hint: "Bold", toggle: true, checked: true },
              { key: "left", icon: "alignLeft", hint: "Left", group: "align", checked: true },
              { key: "right", icon: "alignRight", hint: "Right", group: "align" }
            ],
            on_click: ->(bar, item) { tell("#{item['hint']}, pressed: #{bar.checked_keys.inspect}") })
    ScrollArea do
      HGroup(width: "100%", height: "auto", align: "center top", gap: 40, padding: 30, wrap: true) do
        VGroup(width: COLUMN_WIDTH, height: "auto", align: "left top", gap: 14) do
          draw_buttons
          draw_choices
          draw_fields
          draw_lists
          draw_conversation
        end
        VGroup(width: COLUMN_WIDTH, height: "auto", align: "left top", gap: 14) do
          draw_pickers
          draw_steps_and_areas
          draw_tree_and_tables
          draw_chart
          draw_over_the_page
        end
      end
    end
    @status = StatusBar(message_text: "Change something.", items: ["UTF-8", "100%"])
  end
end
