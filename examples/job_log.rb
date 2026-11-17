# Bismillah
# A job in the background and its output in the window: a thread, ui { } and the levels of a LogView.
require "ozdenui"
include OzdenUI

PAGE_LIGHT = "#FFFFFF"
PAGE_DARK = "#1E1E1E"
STEP_TIME = 0.15 # seconds
FILES = ["photo.jpg", "notes.txt", "disk.bin", "report.pdf", "song.mp3", "backup.zip"].freeze

def show_levels(box)
  levels = box.checked? ? ["warn", "error"] : []
  @output.set_levels(levels)
end

def run_job
  @run_button.enabled = false
  @bar.value = 0
  @status.set_busy(true)
  @status.set_message_text("The job is running...")
  Thread.new { job }
end

# Adds a line to the view from the thread of the job: level is "info", "success", "warn" or "error".
def write_line(level, text)
  ui { @output.call(level, text) }
end

def job
  write_line("info", "The job started")
  FILES.each_with_index do |name, index|
    sleep(STEP_TIME) # in the thread of the job: the window does not wait
    if name.end_with?(".bin")
      write_line("error", "#{name} can not be read: permission denied")
    elsif name.end_with?(".zip")
      write_line("warn", "#{name} is very large")
    else
      write_line("info", "Copied #{name}")
    end
    count = index + 1
    ui do
      @bar.value = count
      @status.set_item_text("files", "#{count} files")
    end
  end
  write_line("info", "The job ended")
  write_line("success", "Done")
  ui do
    @status.set_busy(false)
    @status.set_message_text("Ready") # the lasting message: "Done" goes back to it
    @status.set_message_text("Done", "success", 3000)
    @run_button.enabled = true
  end
end

run(title: "A job and its log", width: 680, height: 520) do |page|
  page.color = dark? ? PAGE_DARK : PAGE_LIGHT
  VGroup(gap: 0, align: "left top") do
    VGroup(width: "100%", height: "auto", gap: 10, padding: 12, align: "left top", shrink: 0) do
      HGroup(hug: true, gap: 8, align: "left center") do
        @run_button = SmartButton(label_text: "Run the job", tone: "cyan", on_click: method(:run_job))
        SmartButton(label_text: "Clear", on_click: -> { @output.clear_lines })
        CheckBox(label_text: "Only warnings and errors", on_change: method(:show_levels))
      end
      @bar = ProgressBar(title_text: "Files", max_value: FILES.length, width: "100%")
    end
    @output = LogView(fill: true, unframed: true, empty_text: "Run the job: its output comes here.")
    @status = StatusBar(message_text: "Ready", items: [{ key: "files", text: "0 files" }])
  end
end
