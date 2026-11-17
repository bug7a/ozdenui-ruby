# Bismillah
# A clock and a stopwatch: every() runs a block again and again (the loop() of basic.js).
require "ozdenui"
include OzdenUI

PAGE_COLOR = "#1E2230"
TEXT_LIGHT = "#F4F5F7"
TEXT_SOFT = "#9AA3B5"
STOPWATCH_STEP_MS = 100

@started_at = nil # nil: the stopwatch is not running
@total = 0.0      # seconds
@stopwatch_timer = nil

def show_time
  @clock.text = Time.now.strftime("%H:%M:%S")
end

def elapsed
  return @total if @started_at.nil?
  @total + (Time.now - @started_at)
end

def show_watch
  @watch.text = format("%.1f s", elapsed)
end

def toggle
  if @started_at.nil?
    @started_at = Time.now
    @stopwatch_timer = every(STOPWATCH_STEP_MS) { show_watch }
    @start_button.text = "Stop"
    return
  end
  @total = elapsed
  @started_at = nil
  @stopwatch_timer.stop
  @start_button.text = "Start"
  show_watch
end

def reset
  @total = 0.0
  @started_at = Time.now unless @started_at.nil?
  show_watch
end

run(title: "Clock", width: 460, height: 340) do |page|
  page.color = PAGE_COLOR
  VGroup(gap: 10, padding: 30) do
    @clock = Label(text: Time.now.strftime("%H:%M:%S"), font_size: 72, bold: true, text_color: TEXT_LIGHT)
    Label(text: Time.now.strftime("%A, %d %B %Y"), font_size: 16, text_color: TEXT_SOFT)
    @watch = Label(text: "0.0 s", font_size: 28, text_color: TEXT_LIGHT)
    HGroup(hug: true, gap: 8) do
      @start_button = SmartButton(label_text: "Start", style_name: "ozdenDark", on_click: method(:toggle))
      SmartButton(label_text: "Reset", style_name: "ozdenDark", on_click: method(:reset))
    end
  end
  every(1000) { show_time }
end
