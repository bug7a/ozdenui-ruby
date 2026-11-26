# Bismillah
# A TextField read in Ruby: @name.text is always the text on the page. Enter or the button greets.
require "ozdenui"
include OzdenUI

PAGE_COLOR = "#F4F5F7"

def greet
  typed = @name.text.strip
  if typed.empty?
    @answer.text = "Write your name first."
    return
  end
  @answer.text = "Hello, #{typed}!"
end

run(title: "Greeting", width: 420, height: 320) do |page|
  page.color = PAGE_COLOR unless dark? # a dark window has its own ground
  VGroup(gap: 14, padding: 40) do
    @name = TextField(title_text: "What is your name?", placeholder: "Ada", width: 300, on_enter: method(:greet))
    SmartButton(label_text: "Greet", tone: "cyan", on_click: method(:greet))
    @answer = Label(font_size: 18)
  end
end
