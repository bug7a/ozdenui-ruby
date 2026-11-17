# 6. Dialogs, messages and files

## Dialogs return their answer

A dialog in OzdenUI is a method call that returns the answer, as `gets` does in a terminal:

```ruby
if confirm("The file will be deleted.", title: "Delete it?", confirm_text: "Delete", danger: true)
  delete_the_file
end

name = prompt("A name for the folder:", value: "Photos", required: true) # nil: cancelled
choice = ask("Save the changes?", "Save", "Don't save", "Cancel")        # the text of the button
choice = ask("Save them?", "Save", "Don't save", title: "Unsaved changes")
alert("The copy is done.", title: "Done")
```

- **The window keeps working while your code waits**: other events and timers run, a clock keeps ticking. Only the
  method that asked waits for the answer.
- The texts are named values: `title:`, `confirm_text:`, `cancel_text:`; for `prompt` also `value:`, `placeholder:`,
  `field_text:` and `required:` (an empty answer is not taken). What you do not write keeps the text of the kit.
- `danger: true` draws the confirm button as a delete. `ask` makes its first button the main one.
- Escape or a click outside is "no": `false` for `confirm`, `nil` for `prompt` and for `ask`.
- A dialog is asked from an event or a timer, as here. A thread of your own reaches the window only through `ui { }`
  (chapter 4).

`examples/dialogs.rb` has a button for each of them and shows the answer as Ruby writes it (`inspect`).

## Short messages: toasts

```ruby
toast("Saved.")                                         # type: :success (the default)
toast_error("Could not save the file.", title: "Error") # a title may come with the message
toast_warning("The disk is almost full.")
toast_info("3 new messages")
toast("Saved.", type: :info)                            # the same as toast_info
```

A toast comes in a corner and goes by itself. It never waits: the code goes on at once.

## Bubbles: show_hint and Tooltip

```ruby
save = SmartButton(label_text: "Save")
Tooltip(target: save, hint_text: "Saves the file (Ctrl+S)") # under the mouse, by itself

show_hint(save, "Saved.", 2000)                    # at the button now, for 2 s ("top" is its side)
hint = show_hint(save, "Working", 0, side: "bottom") # 0: it stays until hint.remove
```

- A `Tooltip` with `trigger: "click"` is a popover: a click on its target opens it, and it stays until a click
  outside. `hint_position:` is its side: `"top"`, `"bottom"`, `"left"`, `"right"`.
- In v0.1 a bubble shows a text. A bubble that holds objects of your own is not there yet.

## The file dialogs of the system

```ruby
path = open_file(types: ["png", "jpg"])                    # a path, or nil (cancelled)
paths = open_files                                         # an Array, empty when cancelled
target = save_file(file_name: "report.csv", types: ["csv"])
folder = choose_folder(title: "Where are the photos?")
```

- They are the dialogs of the computer (on Linux: `zenity`), so the paths are real: read and write them with `File`.
- Their named values: `title:`, `directory:` (the folder it opens in), `file_name:` (the name `save_file` offers),
  `types:` (the endings it shows).
- `save_file` only gives the path: your program writes the file.

### A small editor

```ruby
require "ozdenui"
include OzdenUI

PAGE_COLOR = "#F4F5F7"
FILE_TYPES = ["txt", "md"].freeze

@path = nil # the file of the note; nil until it is opened or saved

def open_note
  chosen = open_file(types: FILE_TYPES)
  return if chosen.nil?
  begin
    content = File.read(chosen, encoding: "UTF-8")
  rescue SystemCallError => error
    toast_error(error.message, title: "Could not open it")
    return
  end
  @path = chosen
  @note.value = content
  @note.title_text = File.basename(@path)
end

def save_note
  @path ||= save_file(file_name: "note.txt", types: FILE_TYPES)
  return if @path.nil?
  begin
    File.write(@path, @note.text)
  rescue SystemCallError => error
    toast_error(error.message, title: "Could not save it")
    return
  end
  @note.title_text = File.basename(@path)
  toast_success("Saved.", title: File.basename(@path))
end

def clear_note
  return unless confirm("The text in the window goes away.", title: "Clear the note?", confirm_text: "Clear", danger: true)
  @note.value = ""
end

run(title: "Note", width: 560, height: 420) do |page|
  page.color = PAGE_COLOR
  VGroup(gap: 12, padding: 20, align: "left top") do
    HGroup(hug: true, gap: 8) do
      SmartButton(label_text: "Open", on_click: method(:open_note))
      SmartButton(label_text: "Save", tone: "cyan", on_click: method(:save_note))
      SmartButton(label_text: "Clear", tone: "orange", on_click: method(:clear_note))
    end
    @note = TextAreaField(title_text: "Note", width: "100%", height: 260)
  end
end
```

`@note.text` asks nothing of the page: the field tells the program its text while the user types.
`examples/csv_viewer.rb`, `examples/image_viewer.rb` and `examples/markdown_editor.rb` open their files the same way.

## A wait over the window: LoadingScreen

```ruby
loading = LoadingScreen(title_text: "Copying", message_text: "Starting...", progress: 0)
Thread.new do
  (1..4).each do |step|
    copy_one_file(step) # the slow work, in the thread
    ui do
      loading.set_progress(step / 4.0) # 0 .. 1
      loading.set_message_text("File #{step} of 4")
    end
  end
  ui { loading.close }
end
```

It covers the whole window, wherever it is made. `progress: -1` (its default) shows no bar; `min_duration:` (ms)
keeps it a moment, so a fast job does not blink; `remove_on_close: true` removes it after `close`, for a screen used
once.

## A place to drop files: FilePicker

`FilePicker` is a place to drop files on, or to click for a file. `picker.files` is its list, an Array of Hashes:
`name`, `path`, `size`, `sizeText`, `type`, `extension`, `lastModified`.

A click opens the file dialog of the system, so the chosen files come with their real paths; `picker.paths` lists
them. A file dropped on it comes from the page, and the page never knows where a file is: its `path` is only its name,
and it is not in `picker.paths`.

```ruby
require "ozdenui"
include OzdenUI

@rows = []

def show_files(picker)
  @rows.each(&:remove)
  @rows = []
  @list.add do
    picker.files.each do |file|
      @rows << Label(text: "#{file[:path]} (#{file[:sizeText]})", font_size: 14)
    end
  end
end

run(title: "Files", width: 520, height: 460) do |page|
  page.color = "#F4F5F7"
  VGroup(gap: 14, padding: 24, align: "left top") do
    FilePicker(width: "100%", zone_height: 140, multiple: true, show_list: false,
               title_text: "Drop files here", on_change: method(:show_files))
    @list = VGroup(width: "100%", height: "auto", gap: 6, align: "left top") do
      @rows << Label(text: "No files yet.", font_size: 14, text_color: "#5A6270")
    end
  end
end
```

- `accept: ".csv,.txt"` or `"image/*"`; `max_size:` (bytes) and `max_files:`: what does not pass goes to `on_error:`.
  `multiple: true` adds to the list; without it a new file takes the place of the old one.
- `picker.clear` empties it; `title_text:`, `description_text:`: its texts; `icon_file:`: a picture of yours.
- `picker.add_files("report.pdf", "notes.txt")` adds files of this computer from the code.
  `on_open_dialog: ->(picker) { ... }` puts a dialog of your own in the place of the one of the system.
- The bytes of a dropped file do not reach Ruby. For the content of a file, read it from its path (`File.read`): a
  click gives one, a drop does not.

## Next

[Chapter 7: Looks](07-looks.md): dark windows, the minimal look and your colors.
