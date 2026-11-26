# Bismillah
# The dialogs: each one returns its answer (the code waits; the window keeps working meanwhile).
require "ozdenui"
include OzdenUI

PAGE_COLOR = "#F4F5F7"
TEXT_SOFT = "#5A6270"

# Shows a value as Ruby writes it: a text in quotes, true / false / nil as they are.
def tell(value)
  @answer.text = value.inspect
end

def show_alert
  alert("The file was saved.", title: "Saved")
  tell("closed")
end

def show_confirm
  tell(confirm("The old copy will be replaced.", title: "Replace it?", confirm_text: "Replace"))
end

def show_prompt
  name = prompt("A name for the new folder:", title: "New folder", value: "Photos", required: true)
  if name.nil?
    tell("cancelled")
    return
  end
  tell(name)
end

def show_ask
  # ask takes no title here: its message says it all.
  tell(ask("You have changes that are not saved. Save them?", "Save", "Don't save", "Cancel"))
end

run(title: "Dialogs", width: 640, height: 420) do |page|
  page.color = PAGE_COLOR unless dark? # a dark window has its own ground
  VGroup(gap: 16, padding: 36, align: "left top") do
    Label(text: "Dialogs", font_size: 24, bold: true)
    HGroup(hug: true, gap: 8) do
      SmartButton(label_text: "Alert", on_click: method(:show_alert))
      SmartButton(label_text: "Confirm", on_click: method(:show_confirm))
      SmartButton(label_text: "Prompt", on_click: method(:show_prompt))
      SmartButton(label_text: "Ask", on_click: method(:show_ask))
      SmartButton(label_text: "Toast", on_click: -> { toast_info("A short message.", title: "Info") })
    end
    Label(text: "The answer:", font_size: 13, text_color: TEXT_SOFT)
    @answer = Label(text: "-", font_size: 20)
  end
end
