# Bismillah
# The basic objects: a Box, an Icon, a Label, an Input and a Button, each in a place of its own. Write a text and press the button (or Enter): the card shows the text and takes the next color.
require "ozdenui"
include OzdenUI

PAGE_COLOR = "#F4F5F7"
CARD_COLORS = ["#5BBAC1", "#E0A038", "#E8796D", "#65A293"].freeze

# A white circle with a check: a drawing as a text, so no picture file is needed.
CHECK_SVG = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><circle cx="12" cy="12" r="11" fill="white"/>' \
            '<path d="M7.5 12.5l3 3 6-7" fill="none" stroke="#2B2B2B" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"/></svg>'

@color_number = 0

def change
  typed = @input.text.strip
  typed = "Hello" if typed.empty?
  @label.text = typed
  @color_number = (@color_number + 1) % CARD_COLORS.length
  @card.color = CARD_COLORS[@color_number]
end

run(title: "The basic objects", width: 360, height: 260) do |page|
  page.color = PAGE_COLOR unless dark? # a dark window has its own ground

  # An object has a place: left, top, width, height. The objects made in the block of a Box are inside it.
  @card = Box(20, 20, 320, 110, color: CARD_COLORS[0], round: 12) do
    Icon(20, 25, 60, 60, picture: picture(CHECK_SVG))
    @label = Label(100, 36, 200, 38, text: "Hello", font_size: 26, bold: true, text_color: "white")
  end

  # An event is a block: on_click runs at a click, on_enter at Enter.
  @input = Input(20, 150, 200, 40, placeholder: "Write a text", on_enter: method(:change))
  Button(230, 150, 110, 40, text: "Change", on_click: method(:change))
end
