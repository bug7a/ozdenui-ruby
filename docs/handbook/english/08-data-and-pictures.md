# 8. Data and pictures

The components of this chapter show what a Ruby program usually has: numbers, rows, logs, texts, code and pictures.
None of them needs another gem: the page draws them.

## Charts: GraphBox

```ruby
GraphBox(type: "bar", labels: ["Jan", "Feb", "Mar"], values: [1200, 1900, 700], format_value: "{:,.0f} TL")
```

- `type:`: `"line"`, `"area"`, `"bar"`, `"pie"`, `"doughnut"`, `"radar"`, `"scatter"`, `"bubble"`.
- `values:` is an Array of any numbers. More lines or bars:
  `datasets: [{ label: "2025", data: [8, 11, 9] }, { label: "2026", data: [10, 14, 12] }]`.
- `format_value:` is a format text, not a block, because the page needs the text of a number while it draws:
  `"{}"`, `"{:.2f}"`, `"{:,}"`, `"{:,.0f} TL"`, `"{:.1%}"`. A method that takes a format takes it through
  `number_format`: `graph.set_format_value(number_format("{:.0f} kg"))`.
- Later: `graph.set_values([...])`, `graph.set_type("line")`, `graph.add_value("Apr", 15)`.
  `on_click: ->(graph, item) { }`: `item[:label]`, `item[:value]`.

### A live chart and a log

```ruby
require "ozdenui"
include OzdenUI

POINTS = 30
FIRST_ONES = 12 # values drawn at the start, one second apart

def measure_at(time)
  value = (20 + rand * 6 - 3).round(1)
  @chart.add_value(time.strftime("%H:%M:%S"), value) # the oldest goes after POINTS values
  if value > 22
    @log.warn(format("Warm: %.1f°", value))
    return
  end
  @log.info(format("%.1f°", value))
end

run(title: "A sensor", width: 560, height: 520) do |page|
  page.color = "#F4F5F7"
  VGroup(gap: 12, padding: 20) do
    @chart = GraphBox(type: "area", title_text: "Temperature", labels: [], values: [], curve: "smooth",
                      show_points: false, max_count: POINTS, format_value: "{:.1f}°", width: "100%", height: 240)
    @log = LogView(fill: true)
  end
  FIRST_ONES.downto(1) { |back| measure_at(Time.now - back) }
  every(1000) { measure_at(Time.now) }
end
```

`examples/charts.rb` has a live chart, bars you can click, a doughnut, two lines with a target, and a chart saved as a
PNG file (`graph.get_image("image/png", 2)` gives its data address).

## Tables

A row is a Hash, or a Struct of your program: its members are the keys the columns name. `on_select:` gives the row
back as a Hash, read with a text or a symbol:

```ruby
require "ozdenui"
include OzdenUI

Person = Struct.new(:name, :city, :orders)

COLUMNS = [
  { name: "Name", dataTitle: "name", width: 180, sortable: 1 },
  { name: "City", dataTitle: "city", width: 160, sortable: 1 },
  { name: "Orders", dataTitle: "orders", dataType: "integer", width: 100, sortable: 1 }
].freeze

@people = [Person.new("Ada", "London", 12), Person.new("Alan", "Manchester", 7), Person.new("Grace", "New York", 21)]

def show_person(_table, row)
  @chosen.text = "#{row[:name]}, #{row[:city]}: #{row[:orders]} orders"
end

def add_person
  @people << Person.new("Person #{@people.length + 1}", "İzmir", 0)
  @table.item_data_list = @people # the whole list again: the table draws it
end

run(title: "People", width: 520, height: 420) do |page|
  page.color = "#F4F5F7"
  VGroup(gap: 12, padding: 20, align: "left top") do
    @table = SmartTable(title_data_list: COLUMNS, item_data_list: @people, width: "100%", height: 260,
                        on_select: method(:show_person))
    HGroup(hug: true, gap: 12, align: "left center") do
      SmartButton(label_text: "Add one", on_click: method(:add_person))
      @chosen = Label(text: "Click a row.", font_size: 15)
    end
  end
end
```

- **`SmartTable`** makes only the rows that are seen, so a very big list stays fast (`examples/csv_viewer.rb` has a
  button for 100000 rows). It has a filter box and sorting on its titles.
- A column: `name` (its title), `dataTitle` (the key of the row), `width`, `dataType` (`"string"`, `"integer"`...),
  `sortable`. The keys of a column are the names of the kit as it writes them. The values are shown as text: format
  them in Ruby (`format("%.2f", price)`).
- **`DataTable`** is for up to a few hundred rows; its columns fit their texts.
- `examples/csv_viewer.rb` opens a CSV file in a SmartTable (with the `csv` library of Ruby).

## Pictures

A picture may be a file path, the text of an SVG, bytes (a PNG or a JPEG: `File.binread`, or a picture your program
made), or a web address. `picture()` turns any of them into an address the page can show:

```ruby
Icon(width: 48, height: 48, picture: "logo.png")             # picture: takes a path, an SVG or bytes
view = ImageView(height: 400, image_file: "photo.jpg")         # a param that ends in _file: a path
view.set_image(picture(png_bytes))                           # in a method: picture()
```

- An `ImageView` zooms with the wheel or two fingers and moves by dragging. A new picture keeps the zoom and the place,
  so a program can draw its plot again and again.
- The page can not read a file of this computer by its path, so Ruby reads it and gives its content as a `data:`
  address. A param that ends in `_file` and the `picture:` of an `Icon` do it by themselves; in any other place (an
  item of a list, a style, a method) give `picture(path)`.
- The address carries the whole picture: for one you show many times, keep `picture(...)` in a variable.

```ruby
require "ozdenui"
require "zlib"
include OzdenUI

SIZE = 240

@shade = 0

# The bytes of a PNG file of rows of RGB pixels: a picture made in plain Ruby, with zlib.
def png_chunk(name, data)
  [data.bytesize].pack("N") + name + data + [Zlib.crc32(name + data)].pack("N")
end

def png_bytes(rows)
  header = [SIZE, SIZE, 8, 2, 0, 0, 0].pack("NNCCCCC")
  pixels = rows.map { |row| "\0".b + row }.join
  "\x89PNG\r\n\x1A\n".b + png_chunk("IHDR", header) + png_chunk("IDAT", Zlib::Deflate.deflate(pixels)) + png_chunk("IEND", "")
end

# Draws a picture pixel by pixel, as a program of yours would.
def gradient(shade)
  rows = (0...SIZE).map do |y|
    (0...SIZE).map { |x| [x, y, shade].pack("C3") }.join
  end
  png_bytes(rows)
end

def draw_again
  @shade = (@shade + 80) % 256
  @view.set_image(picture(gradient(@shade)))
end

run(title: "A picture of Ruby", width: 420, height: 420) do |page|
  page.color = "#F4F5F7"
  VGroup(gap: 12, padding: 20) do
    @view = ImageView(width: 300, height: 300, image_file: picture(gradient(@shade)))
    SmartButton(label_text: "Draw it again", on_click: method(:draw_again))
  end
end
```

`examples/image_viewer.rb` opens a picture file, or draws a plot again and again.

## Logs: LogView

```ruby
log = LogView(height: 300)
log.info("Reading the file")
log.success("Done")
log.error("The file is not there")
log.writer(:warn).puts("The disk is full") # an output like $stdout: also from a thread
$stdout = log.writer(:info)                # puts of the whole program goes into it
```

The levels are `:info`, `:success`, `:warn`, `:error` and `:debug`. The view follows the last line until the reader
scrolls up. A text is never read as HTML. `log.writer(level)` may be used from any thread: it goes through `ui { }`
by itself, and every line of it is a line of the view. `examples/job_log.rb`.

## Texts, JSON and code

| | |
|---|---|
| `MarkdownView(markdown_text: "# A report\n\nSome **bold** words")` | `view.append_text(piece)` adds to the end: the answer of an AI as it comes; `view.markdown_text = text` |
| `JsonView(value: data, height: 400, on_select: fn)` | any Ruby value of Hashes, Arrays, texts and numbers; a click: `->(view, entry) { }`, `entry[:pathText]` (`users[0].name`) |
| `JsonEditor(value: rows, height: 360, on_change: fn)` | a list or a Hash of JSON written in a table; `->(editor, value) { }` gets the whole value |
| `CodeEditor(value: "x = 1", language: "ruby", height: 300, on_change: fn)` | its text is asked: `editor.get_value`; Ruby, Python, JavaScript, Go, JSON, HTML, CSS, SQL, Bash |
| `ChatView(empty_text: "Ask something", on_send: fn)` | `->(chat, text) { }`; an answer: `chat.add_message(key: key, role: "assistant")`, then `chat.append_text(key, piece)`; `chat.busy = true` shows the dots and Stop |
| `WebView(html_text: page, height: 400)` | a web page (`url:`) or an HTML text with its scripts; `on_message: ->(view, data) { }` gets what its page sends with `parent.postMessage` |

- **A big or fast value is asked, not kept**: a `CodeEditor` does not send its text with every key. Ask it when you
  need it, in its `on_change` or when the user saves (`change_delay: 120` waits for the typing to rest).
- A code block of a `MarkdownView` marked `ruby` (or `rb`) takes the colors of Ruby too.
- A Markdown text is never read as HTML and no script of it runs. The page can not read a file by its path: a picture
  of this computer goes into the text as `picture(path)` (`examples/markdown_editor.rb` does it). A picture with an
  `http` address stays a link (`remote_pictures: true` for a text you trust).
- The pieces of an answer of a `ChatView` may come from a thread through `ui { }`: the window keeps working, and the
  view follows the end until the reader scrolls up (`examples/chat.rb`).
- `examples/markdown_editor.rb`, `examples/json_viewer.rb` and `examples/editor.rb` (a small editor that runs its
  Ruby program) show them.

## Drawing: Canvas

```ruby
Canvas(width: "100%", height: 300, shapes: [
  { key: "sun", type: "circle", x: 100, y: 80, radius: 30, fill: "orange", draggable: 1 },
  { key: "path", type: "line", x1: 20, y1: 200, x2: 260, y2: 200, color: "tomato", lineWidth: 4 },
  { key: "title", type: "text", x: 20, y: 12, text: "Drag the sun", fontSize: 16 }
], on_shape_move: ->(_canvas, shape) { puts "moved: #{shape[:key]}" })
```

The page moves a `draggable` shape by itself; `on_shape_move` tells Ruby where it stopped. `drawing: true` gives the
mouse a pen. Its methods (`add_shape`, `move_shape`, `remove_shape`, `get_image`...) are methods of the object. The
keys of a shape are the names of the kit (`lineWidth:`, `fontSize:`), as in every item.

## Next

[Chapter 9: Your own component](09-your-own-component.md).
