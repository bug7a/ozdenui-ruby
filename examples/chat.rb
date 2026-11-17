# Bismillah
# A chat with an AI that is only a sample: it streams a small plan word by word (in a thread, so the window keeps working); your AI goes into write_answer.
require "ozdenui"
include OzdenUI

LIGHT_GROUND = "#FFFFFF" # the ground of the ChatView in each theme
DARK_GROUND = "#1C1C1B"
THINK_TIME = 0.6 # seconds before the first words: the dots
WORD_TIME = 0.04 # seconds between two words

ANSWER_TEXT = "Here is a small plan for **{topic}**:\n\n" \
              "1. Write down what you want to do\n2. Split it into small steps\n3. Do one step a day\n\n" \
              "| Day | Step |\n|:---|:---|\n| Monday | The list |\n| Tuesday | The first step |\n\n" \
              "```python\nsteps = [\"the list\", \"the first step\"]\nprint(len(steps), \"steps\")\n```\n\n" \
              "Ask again if something is not clear."

FIRST_MESSAGES = [{ role: "system", text: "A sample: the answers are written by this program, not by an AI" }].freeze

# One word with the spaces before it, as a stream gives the pieces.
PIECE_PATTERN = /\s*\S+|\s+\z/

@answer_number = 0 # WHY: Stop and New chat start a new number, and the pieces of an older answer are dropped

def answer(_view, text)
  @answer_number += 1
  key = "answer#{@answer_number}"
  @chat.add_message(key: key, role: "assistant")
  @chat.busy = true
  number = @answer_number
  Thread.new { write_answer(number, key, text) }
end

# In a thread of its own: the window keeps working while the answer comes. Every piece goes to the message with
# @chat.append_text(key, piece), inside ui { }.
def write_answer(number, key, topic)
  sleep(THINK_TIME)
  ANSWER_TEXT.gsub("{topic}", topic).scan(PIECE_PATTERN).each do |piece|
    ui { @chat.append_text(key, piece) if number == @answer_number }
    sleep(WORD_TIME)
  end
  ui do
    @chat.busy = false if number == @answer_number # WHY: after Stop the page set busy to 0 already
  end
end

def stop_answer
  @answer_number += 1
end

def new_chat
  @answer_number += 1
  @chat.busy = false
  @chat.messages = FIRST_MESSAGES
end

run(title: "A chat", width: 720, height: 760) do |page|
  page.color = dark? ? DARK_GROUND : LIGHT_GROUND
  VGroup(gap: 0) do
    HGroup(width: "100%", height: "auto", align: "left center", gap: 12, padding: [16, 10]) do
      Label(text: "A chat", font_size: 17, bold: true, fill: true)
      SmartButton(label_text: "New chat", on_click: method(:new_chat))
    end
    @chat = ChatView(width: "100%", fill: true, messages: FIRST_MESSAGES, empty_text: "Ask something",
                     on_send: method(:answer), on_stop: method(:stop_answer))
    @chat.focus
  end
end
