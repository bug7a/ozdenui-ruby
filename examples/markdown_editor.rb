# Bismillah
# A small Markdown editor: write on the left, read on the right; open a file with its pictures, save it, a dark theme; a click on a link is told at the bottom, not opened.
require "ozdenui"
include OzdenUI

LIGHT_GROUND = "#FFFFFF"
DARK_GROUND = "#1C1C1B"
TYPING_REST_MS = 120 # the text is drawn again when the typing rests

FIRST_TEXT = "# A small report\n\n" \
             "The **sales** went up this month. Read the [notes](https://example.com/notes).\n\n" \
             "## The numbers\n\n" \
             "| Product | Count | Total |\n|:---|:--:|---:|\n| Olive oil | 120 | 7,200 TL |\n| Honey | 45 | 3,150 TL |\n\n" \
             "## Next steps\n\n- [x] Write the report\n- [ ] Send it\n\n" \
             "> The numbers of the last week are not final.\n\n" \
             "```python\ntotal = sum(row[\"total\"] for row in rows)\nprint(f\"Total: {total:,} TL\")\n```\n"

# ![alt](address): a picture of the text.
PICTURE_PATTERN = /(!\[[^\]]*\]\()([^)\s]+)/

@path = nil
@picture_folder = nil # the folder of the opened file: its pictures are next to it

def words_of(text)
  "#{text.split.length} words"
end

# The text with the pictures of this computer as addresses: the page can not read a file by its path.
def with_pictures(text)
  return text if @picture_folder.nil?
  text.gsub(PICTURE_PATTERN) do |found|
    start = Regexp.last_match(1)
    address = Regexp.last_match(2)
    next found if address.include?(":") # an address of the web or a data: address
    start + picture(File.join(@picture_folder, address))
  end
end

def show_text(code)
  text = code.get_value.to_s # WHY get_value: the editor does not send its text back by itself
  @preview.markdown_text = with_pictures(text)
  @status.set_item_text("words", words_of(text))
end

def show_link(_view, address)
  @status.set_message_text("Link: #{address}", "info", 4000)
end

# WHY not set_theme: it would draw the page again, and the text would be made again too.
def toggle_theme(bar)
  is_dark = (bar.checked_keys || []).include?("dark")
  theme = is_dark ? "dark" : "light"
  @page.color = is_dark ? DARK_GROUND : LIGHT_GROUND
  [@tools, @split, @editor, @preview, @status].each { |obj| obj.set_theme(theme) }
end

def open_document
  chosen = open_file(types: ["md"])
  return if chosen.nil?
  begin
    text = File.read(chosen)
  rescue SystemCallError => error
    @status.set_message_text(error.message, "error")
    return
  end
  @path = chosen
  @picture_folder = File.dirname(chosen)
  @editor.value = text
  @preview.markdown_text = with_pictures(text)
  @preview.scroll_to_top
  @status.message_text = @path
  @status.set_item_text("words", words_of(text))
end

def save_document
  @path ||= save_file(file_name: "report.md", types: ["md"])
  return if @path.nil?
  begin
    File.write(@path, @editor.get_value.to_s)
  rescue SystemCallError => error
    @status.set_message_text(error.message, "error")
    return
  end
  @status.set_message_text("Saved", "success", 3000)
end

run(title: "A small Markdown editor", width: 960, height: 640) do |page|
  @page = page
  page.color = LIGHT_GROUND
  VGroup(gap: 0, align: "left top") do
    @tools = ToolBar(items: [
      { key: "open", icon: "open", hint: "Open...", shortcut: "Ctrl+O", onClick: method(:open_document) },
      { key: "save", icon: "save", hint: "Save", shortcut: "Ctrl+S", onClick: method(:save_document) },
      " ",
      { key: "dark", text: "Dark theme", toggle: true, onClick: method(:toggle_theme) }
    ])
    @split = Splitter(fill: true, first_size: "45%", min_first: 160, min_second: 160)
    @split.first do
      @editor = CodeEditor(height: "100%", value: FIRST_TEXT, show_line_numbers: false, change_delay: TYPING_REST_MS,
                           unframed: true, on_change: method(:show_text))
    end
    @split.second do
      @preview = MarkdownView(markdown_text: FIRST_TEXT, on_link_click: method(:show_link))
    end
    @status = StatusBar(message_text: "Ready", items: [{ key: "words", text: words_of(FIRST_TEXT) }])
  end
end
