# Bismillah
# A calculator: the keys stand in a GridGroup. The keys of the keyboard work too: 12 + 7, then Enter.
require "ozdenui"
include OzdenUI

PAGE_COLOR = "#F4F5F7"
SCREEN_COLOR = "#FFFFFF"
SCREEN_COLOR_DARK = "#232322"
ERROR_TEXT = "Error"
MOST_DIGITS = 12

KEYS = ["C", "÷", "7", "8", "9", "×", "4", "5", "6", "−", "1", "2", "3", "+", "0", ".", "="].freeze
WIDE_KEYS = { "C" => 3, "0" => 2 }.freeze # how many cells a key takes
KEYBOARD_NAMES = { "*" => "×", "/" => "÷", "-" => "−", "Enter" => "=", "Escape" => "C", "c" => "C" }.freeze
OPERATIONS = {
  "+" => ->(a, b) { a + b },
  "−" => ->(a, b) { a - b },
  "×" => ->(a, b) { a * b },
  "÷" => ->(a, b) { a / b }
}.freeze

@typed = "0"
@left = 0.0
@operation = nil
@is_new = true

def press_on_keyboard(name)
  key = KEYBOARD_NAMES[name] || name
  press(key) if KEYS.include?(key)
end

def press(key)
  if key == "C"
    clear
  elsif key == "="
    calculate
  elsif OPERATIONS.key?(key)
    choose_operation(key)
  else
    write_key(key)
  end
end

def clear
  @typed = "0"
  @left = 0.0
  @operation = nil
  @is_new = true
  @screen.text = "0"
end

def write_key(key)
  text = @is_new ? "" : @typed
  return if key == "." && text.include?(".")
  text = "0" if key == "." && text.empty?
  text = (text + key).sub(/\A0+/, "")
  text = "0" if text.empty?
  text = "0" + text if text.start_with?(".")
  text = text[0, MOST_DIGITS]
  @typed = text
  @is_new = false
  @screen.text = @typed
end

def choose_operation(key)
  calculate if @operation && !@is_new
  @left = @typed.to_f
  @operation = key
  @is_new = true
end

# The number as a calculator writes it: 19, not 19.0; at most 10 digits.
def number_text(number)
  format("%.10g", number)
end

def calculate
  return if @operation.nil?
  right = @typed.to_f
  if @operation == "÷" && right.zero?
    clear
    @screen.text = ERROR_TEXT
    return
  end
  @typed = number_text(OPERATIONS[@operation].call(@left, right))
  @operation = nil
  @is_new = true
  @screen.text = @typed
end

run(title: "Calculator", width: 320, height: 410) do |page|
  page.color = PAGE_COLOR unless dark? # a dark window has its own ground
  VGroup(gap: 10, padding: 16, align: "left top") do
    @screen = Label(text: "0", width: "100%", font_size: 34, bold: true, text_align: "right", color: dark? ? SCREEN_COLOR_DARK : SCREEN_COLOR,
                    round: 10, padding: [14, 8], shrink: 0)
    GridGroup(columns: 4, gap: 8) do |grid|
      KEYS.each do |key|
        tone = key == "=" ? "cyan" : "white"
        button = SmartButton(label_text: key, width: "100%", tone: tone, on_click: -> { press(key) })
        grid.place(button, column_span: WIDE_KEYS[key]) if WIDE_KEYS.key?(key)
      end
    end
  end
  page.on(:key_down) { |_page, event| press_on_keyboard(event.key) }
end
