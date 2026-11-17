# Bismillah
# Charts with no other library: a live line, bars with a format, a doughnut, two lines with a target. The page draws them.
require "base64"
require "ozdenui"
include OzdenUI

PAGE_COLOR = "#F4F5F7"
TEXT_SOFT = "#5A6270"
CHART_WIDTH = 410
CHART_HEIGHT = 250
LIVE_POINTS = 24
TICK_MS = 1000
MONTHS = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"].freeze

@ticks = 0
@is_table = false

def live_value(tick)
  ((20 + 6 * Math.sin(tick / 3.0)) * 10).round / 10.0
end

def tick
  @ticks += 1
  number = LIVE_POINTS + @ticks
  @live.add_value(number.to_s, live_value(number))
end

def show_month(_graph, item)
  @chosen.text = "#{item['label']}: #{thousands(item['value'].to_i)} TL"
end

# Writes 1900 as "1,900".
def thousands(number)
  number.to_s.reverse.scan(/\d{1,3}/).join(",").reverse
end

def toggle_table
  @is_table = !@is_table
  @sales.set_table_view(@is_table)
end

def save_picture
  path = save_file(file_name: "sales.png", types: ["png"])
  return if path.nil?
  # get_image gives a data address: "data:image/png;base64,...."
  address = @sales.get_image("image/png", 2).to_s
  _, encoded = address.split(",", 2)
  if encoded.nil?
    toast_error("The page gave no picture.")
    return
  end
  begin
    File.binwrite(path, Base64.decode64(encoded))
  rescue SystemCallError => error
    toast_error(error.message, title: "Could not save it")
    return
  end
  toast_success("Saved.")
end

run(title: "Charts", width: 920, height: 720) do |page|
  page.color = PAGE_COLOR unless dark? # a dark window has its own ground
  labels = (0...LIVE_POINTS).map(&:to_s)
  values = (0...LIVE_POINTS).map { |number| live_value(number) }
  ScrollArea(align: "center top", gap: 16, padding: 24) do
    Label(text: "Charts", font_size: 24, bold: true)
    HGroup(width: "100%", height: "auto", align: "center top", gap: 16, wrap: true) do
      @live = GraphBox(type: "area", title_text: "Temperature", subtitle_text: "A new value every second",
                       labels: labels, values: values, curve: "smooth", show_points: false, max_count: LIVE_POINTS, min_value: 0,
                       max_labels: 6, format_value: "{:.1f}°", width: CHART_WIDTH, height: CHART_HEIGHT)
      @sales = GraphBox(type: "bar", title_text: "Sales", labels: MONTHS,
                        values: [1200, 1900, 700, 1500, 2300, 1800], format_value: "{:,.0f} TL", on_click: method(:show_month),
                        width: CHART_WIDTH, height: CHART_HEIGHT)
      GraphBox(type: "doughnut", title_text: "Where they came from",
               labels: ["Search", "A friend", "An ad"], values: [55, 30, 15], center_text: "100",
               center_sub_text: "people", format_value: "{}%", width: CHART_WIDTH, height: CHART_HEIGHT)
      GraphBox(type: "line", title_text: "Two years", labels: MONTHS,
               datasets: [
                 { label: "2025", data: [8, 11, 9, 14, 13, 17] },
                 { label: "2026", data: [10, 14, 12, 18, 21, 23], showPoints: true }
               ],
               target_lines: [{ value: 20, label: "Target" }], width: CHART_WIDTH, height: CHART_HEIGHT)
    end
    HGroup(hug: true, gap: 8) do
      SmartButton(label_text: "Line", on_click: -> { @sales.set_type("line") })
      SmartButton(label_text: "Bars", on_click: -> { @sales.set_type("bar") })
      SmartButton(label_text: "As a table", on_click: method(:toggle_table))
      SmartButton(label_text: "Save a picture", tone: "cyan", on_click: method(:save_picture))
    end
    @chosen = Label(text: "Click a bar.", font_size: 14, text_color: TEXT_SOFT)
  end
  every(TICK_MS) { tick }
end
