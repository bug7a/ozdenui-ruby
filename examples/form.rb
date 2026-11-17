# Bismillah
# A form: fields of text, a date, a time, a color, a number. Send checks them and shows their values.
require "date"
require "ozdenui"
include OzdenUI

PAGE_COLOR = "#F4F5F7"
CARD_COLOR = "#FFFFFF"
CARD_COLOR_DARK = "#232322"
TEXT_SOFT = "#5A6270"
FORM_WIDTH = 520
FIRST_COLOR = "#3871E0"
DATE_FORMAT = "%Y-%m-%d" # the dates of the kit: "YYYY-MM-DD"

# Puts a small title over a field that has none of its own: titled("Date") { DatePicker(...) }
def titled(title)
  VGroup(hug: true, gap: 6, align: "left top") do
    Label(text: title, font_size: 13, text_color: TEXT_SOFT)
    yield
  end
end

def form_values
  parts = [
    "name: #{@name.text}",
    "email: #{@email.text}",
    "budget: #{@budget.text}",
    "date: #{@date.value}",
    "time: #{@clock.value}",
    "color: #{@color.value}",
    "guests: #{@guests.value}",
    "quiet: #{@noise.value}"
  ]
  parts.join(", ")
end

def show_noise(slider)
  @result.text = "How quiet: #{slider.value}"
end

def send_form
  # WHY every field and not "&&": each one shows its warning, not only the first one
  answers = [@name.valid?, @email.valid?, @password.valid?]
  unless answers.all?
    toast_error("Look at the marked fields.")
    return
  end
  @result.text = form_values
  toast_success("Sent.")
end

def clear_form
  [@name, @email, @password, @budget].each { |field| field.value = "" }
  @date.date = ""
  @result.text = ""
end

run(title: "A form", width: 620, height: 720) do |page|
  page.color = PAGE_COLOR unless dark? # a dark window has its own ground
  today = Date.today
  next_week = today + 7
  ScrollArea(align: "center top", gap: 16, padding: 30) do
    Label(text: "A reservation", font_size: 24, bold: true)
    VGroup(width: FORM_WIDTH, height: "auto", align: "left top", gap: 14, padding: 20, color: dark? ? CARD_COLOR_DARK : CARD_COLOR, round: 12) do
      @name = TextField(title_text: "Name", placeholder: "Ada", required: true, width: "100%", on_enter: method(:send_form))
      @email = EmailField(title_text: "E-mail", required: true, width: "100%", on_enter: method(:send_form))
      @password = PasswordField(title_text: "Password", required: false, min_length: 6, width: "100%")
      @budget = NumberField(title_text: "Budget", placeholder: "", value: 250, width: "100%")
      HGroup(hug: true, gap: 12, wrap: true, align: "left top") do
        titled("Date") do
          @date = DatePicker(date: next_week.strftime(DATE_FORMAT), min_date: today.strftime(DATE_FORMAT), width: 150)
        end
        titled("Time") do
          @clock = TimePicker(time: "19:30", minute_step: 15, width: 120)
        end
        titled("Table color") do
          @color = ColorPicker(selected_color: FIRST_COLOR, width: 150)
        end
      end
      titled("Guests") do
        @guests = Stepper(value: 2, min_value: 1, max_value: 12)
      end
      titled("How quiet") do
        @noise = Slider(value: 70, width: FORM_WIDTH - 40, style_name: "round", on_change_end: method(:show_noise))
      end
      HGroup(hug: true, gap: 8) do
        SmartButton(label_text: "Send", tone: "cyan", on_click: method(:send_form))
        SmartButton(label_text: "Clear", on_click: method(:clear_form))
      end
    end
    @result = Label(font_size: 13, text_color: TEXT_SOFT, width: FORM_WIDTH)
  end
end
