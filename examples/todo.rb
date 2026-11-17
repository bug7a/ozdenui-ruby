# Bismillah
# A to-do list: add a task (Enter or the button), tick the done ones, delete them (with a question).
require "ozdenui"
include OzdenUI

PAGE_COLOR = "#F4F5F7"
TEXT_SOFT = "#5A6270"
LIST_WIDTH = 440
FIRST_TASKS = ["Buy bread", "Call the bank", "Water the plants"].freeze

@next_number = 0
@total = 0 # the tasks in the list: the program counts them, so it asks the page nothing

def new_item(title)
  @next_number += 1
  { key: "t#{@next_number}", text: title }
end

def add_task
  title = @field.text.strip
  return if title.empty?
  @tasks.add_item(new_item(title))
  @total += 1
  @field.value = ""
  show_count
end

def done_keys
  (@tasks.selected_keys || []).map(&:to_s)
end

def delete_done
  done = done_keys
  if done.empty?
    alert("Tick the done tasks first.", title: "Nothing to delete")
    return
  end
  question = "#{done.length} done task(s) will be deleted."
  return unless confirm(question, title: "Delete them?", confirm_text: "Delete", danger: true)
  done.each { |key| @tasks.remove_item(key) }
  @total -= done.length
  show_count
end

def show_count
  @count.text = "#{@total} tasks, #{done_keys.length} done"
end

run(title: "To do", width: 540, height: 560) do |page|
  page.color = PAGE_COLOR
  items = FIRST_TASKS.map { |title| new_item(title) }
  @total = items.length
  VGroup(gap: 14, padding: 36, align: "left top") do
    Label(text: "To do", font_size: 24, bold: true)
    HGroup(hug: true, gap: 8, align: "left bottom") do
      @field = TextField(title_text: "A new task", placeholder: "Buy milk", width: LIST_WIDTH - 108, on_enter: method(:add_task))
      SmartButton(label_text: "Add", width: 100, tone: "cyan", on_click: method(:add_task))
    end
    @tasks = ItemList(items: items, selection: "multiple", width: LIST_WIDTH, height: 300,
                      empty_text: "Nothing to do.", on_change: method(:show_count))
    HGroup(hug: true, gap: 14, align: "left center") do
      SmartButton(label_text: "Delete the done ones", tone: "orange", on_click: method(:delete_done))
      @count = Label(font_size: 14, text_color: TEXT_SOFT)
    end
  end
  show_count
end
