# Bismillah
# A small JSON viewer: open a file, click a row to see its path, right click to copy its value or its path (ruby json_viewer.rb some.json: that file).
require "ozdenui"
include OzdenUI

PAGE_LIGHT = "#FFFFFF"
PAGE_DARK = "#1E1E1E"
COPY_SHOWN = 60 # letters of a copied text in the status bar

FIRST_VALUE = {
  "status" => "ok",
  "count" => 2,
  "page_time" => 0.042,
  "cached" => false,
  "next_page" => nil,
  "users" => [
    { "id" => 7, "name" => "Ada Yılmaz", "email" => "ada@example.com", "active" => true, "roles" => ["admin", "editor"],
      "address" => { "city" => "İzmir", "zip" => "35000" } },
    { "id" => 12, "name" => "Can Demir", "email" => "can@example.com", "active" => false, "roles" => [],
      "address" => nil }
  ]
}.freeze

@first_file = ARGV[0]

def tool_clicked(_bar, item)
  case item["key"]
  when "open" then open_json
  when "expand" then @json_view.expand_all
  when "collapse" then @json_view.collapse_all
  end
end

def show_entry(_view, entry)
  @status.set_message_text("#{entry['pathText']}  (#{entry['kind']})")
end

def show_copied(_view, text)
  @status.set_message_text("Copied: #{text[0, COPY_SHOWN]}", "success", 3000)
end

def read_file(path)
  begin
    content = File.read(path)
  rescue SystemCallError => error
    @status.set_message_text(error.message, "error")
    return
  end
  if on?(@json_view.ask(:set_json_text, content)) # the kit answers 1 or 0
    @status.set_message_text(path)
    return
  end
  @status.set_message_text("It is not JSON: #{path}", "error")
end

def open_json
  path = open_file(types: ["json"])
  read_file(path) if path
end

run(title: "A small JSON viewer", width: 720, height: 560) do |page|
  page.color = dark? ? PAGE_DARK : PAGE_LIGHT
  VGroup(gap: 0, align: "left top") do
    ToolBar(on_click: method(:tool_clicked), items: [
      { key: "open", icon: "open", hint: "Open...", shortcut: "Ctrl+O" },
      "-",
      { key: "expand", text: "Open all" },
      { key: "collapse", text: "Close all" }
    ])
    @json_view = JsonView(fill: true, value: FIRST_VALUE, expand_level: 2,
                          on_select: method(:show_entry), on_copy: method(:show_copied))
    @status = StatusBar(message_text: "Click a row: its path comes here.")
  end
  read_file(@first_file) if @first_file
end
