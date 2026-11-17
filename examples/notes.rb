# Bismillah
# A list of notes: a field, a button and a list that grows. The program of AGENTS.md.
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
