# Bismillah
# A small code editor: write Ruby, run it (F5) and read its output; a menu, a row of buttons, two areas, the place of the cursor, a light and a dark theme, Ctrl + S and F5.
require "open3"
require "rbconfig"
require "ozdenui"
include OzdenUI

LIGHT_GROUND = "#FFFFFF"
DARK_GROUND = "#1C1C1B"
OUTPUT_HEIGHT = 170

FIRST_TEXT = <<~'RUBY'
  # Press F5 to run this program.

  names = %w[Ada Can Deniz]

  names.each.with_index(1) do |name, number|
    puts "#{number} #{name}"
  end

  puts :Done
RUBY

@is_dark = false
@path = nil
@line_numbers = true

# WHY not set_theme: it would draw the page again, and the text and the output would be made again too.
def toggle_theme(bar)
  @is_dark = !@is_dark
  theme = @is_dark ? "dark" : "light"
  @page.color = @is_dark ? DARK_GROUND : LIGHT_GROUND
  [@menu, @tools, @split, @editor, @output, @status].each { |obj| obj.set_theme(theme) }
  bar.set_item_checked("dark", @is_dark)
end

def toggle_line_numbers(bar)
  @line_numbers = !@line_numbers
  @editor.show_line_numbers = @line_numbers
  bar.set_item_checked("numbers", @line_numbers)
end

def show_cursor(code)
  @status.set_item_text("place", "Line #{code.cursor_line}, column #{code.cursor_column}")
end

def clear_output
  @output.clear_lines
end

# The text as it is on the page now: the editor does not send it back by itself.
def program_text
  @editor.get_value.to_s
end

def open_program
  chosen = open_file(types: ["rb"])
  return if chosen.nil?
  begin
    content = File.read(chosen)
  rescue SystemCallError => error
    @status.set_message_text(error.message, "error")
    return
  end
  @editor.value = content
  @path = chosen
  @status.message_text = @path
end

def save_program
  @path ||= save_file(file_name: "program.rb", types: ["rb"])
  return if @path.nil?
  begin
    File.write(@path, program_text)
  rescue SystemCallError => error
    @status.set_message_text(error.message, "error")
    return
  end
  @status.set_message_text("Saved", "success", 3000)
end

def run_program
  code = program_text
  @output.clear_lines
  @status.busy = true
  @status.message_text = "Running..."
  Thread.new { run_in_ruby(code) } # the window keeps working while the program runs
end

# WHY the same Ruby as this window: no other program is needed. The sync is on the first line of the program, so the
# lines of its errors stay right, and every line comes to the output as soon as it is written.
def run_in_ruby(code)
  Open3.popen2e(RbConfig.ruby, "-e", "$stdout.sync = true; " + code) do |_input, lines, waiter|
    lines.each_line do |line|
      text = line.chomp
      ui { @output.add_line(text) }
    end
    status = waiter.value
    ui do
      if status.success?
        @output.success("The program ended")
        end_run(nil)
      else
        end_run("The program ended with the code #{status.exitstatus}")
      end
    end
  end
rescue SystemCallError => error
  ui { end_run(error.message) }
end

def end_run(problem)
  @output.error(problem) if problem
  @status.busy = false
  @status.message_text = "Ready"
end

run(title: "A small code editor", width: 760, height: 600) do |page|
  @page = page
  page.color = LIGHT_GROUND
  VGroup(gap: 0, align: "left top") do
    @menu = MenuBar(menus: [
      { text: "File", items: [
        { text: "Open...", key: "open", shortcut: "Ctrl+O", onClick: method(:open_program) },
        { text: "Save", key: "save", shortcut: "Ctrl+S", onClick: method(:save_program) }
      ] },
      { text: "Run", items: [
        { text: "Run the program", key: "run", shortcut: "F5", onClick: method(:run_program) },
        { text: "Clear the output", key: "clear", onClick: method(:clear_output) }
      ] },
      { text: "View", items: [
        { text: "Dark theme", key: "dark", checked: false, onClick: method(:toggle_theme) },
        { text: "Line numbers", key: "numbers", checked: true, onClick: method(:toggle_line_numbers) }
      ] }
    ])
    # WHY the same shortcuts as the menu: the hint of a button tells them; a key that is in both bars runs once.
    @tools = ToolBar(items: [
      { key: "open", icon: "open", hint: "Open...", shortcut: "Ctrl+O", onClick: method(:open_program) },
      { key: "save", icon: "save", hint: "Save", shortcut: "Ctrl+S", onClick: method(:save_program) },
      "-",
      { key: "run", icon: "play", text: "Run", shortcut: "F5", onClick: method(:run_program) },
      { key: "clear", icon: "delete", hint: "Clear the output", onClick: method(:clear_output) }
    ])
    @split = Splitter(fill: true, direction: "vertical", second_size: OUTPUT_HEIGHT, min_first: 80, min_second: 60)
    @split.first do
      @editor = CodeEditor(height: "100%", language: "ruby", value: FIRST_TEXT, unframed: true,
                           on_cursor_change: method(:show_cursor))
    end
    @split.second do
      @output = LogView(height: "100%", unframed: true, empty_text: "F5 runs the program.")
    end
    @status = StatusBar(message_text: "Ready", items: [{ key: "place", text: "Line 1, column 1" }, "Ruby"])
  end
end
