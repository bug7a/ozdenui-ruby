# Bismillah
# A counter: a label and two buttons.
require "ozdenui"
include OzdenUI

PAGE_COLOR = "#F4F5F7"

@count = 0

def add(step)
  @count += step
  @label.text = @count.to_s
end

run(title: "Counter", width: 360, height: 260) do |page|
  page.color = PAGE_COLOR
  VGroup(gap: 16) do
    @label = Label(text: "0", font_size: 48)
    HGroup(hug: true, gap: 10) do
      SmartButton(label_text: "Minus", on_click: -> { add(-1) })
      SmartButton(label_text: "Plus", tone: "cyan", on_click: -> { add(1) })
    end
  end
end
