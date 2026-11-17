# Bismillah
# Catch the dots: move the square with the arrow keys and touch the dot before the time is over (objects at a place of their own, the keys of the page and a timer).
require "ozdenui"
include OzdenUI

PAGE_COLOR = "#14213D"
FIELD_COLOR = "#1F2E52"
PLAYER_COLOR = "#FCA311"
DOT_COLOR = "#2EC4B6"
TEXT_LIGHT = "#E5E5E5"
FIELD_WIDTH = 560
FIELD_HEIGHT = 360
PLAYER_SIZE = 34
DOT_SIZE = 18
STEP = 22
GAME_SECONDS = 30

MOVES = {
  "ArrowLeft" => [-STEP, 0],
  "ArrowRight" => [STEP, 0],
  "ArrowUp" => [0, -STEP],
  "ArrowDown" => [0, STEP]
}.freeze

@score = 0
@secs_left = GAME_SECONDS
@running = false
@timer = nil

# The places are kept in the program: no question to the page at every key.
@player_left = 0
@player_top = 0
@dot_left = 0
@dot_top = 0

def place_player(left, top)
  @player_left = left
  @player_top = top
  @player.set(left: left, top: top)
end

def place_player_in_middle
  place_player((FIELD_WIDTH - PLAYER_SIZE) / 2, (FIELD_HEIGHT - PLAYER_SIZE) / 2)
end

def place_dot
  @dot_left = rand(FIELD_WIDTH - DOT_SIZE + 1)
  @dot_top = rand(FIELD_HEIGHT - DOT_SIZE + 1)
  @dot.set(left: @dot_left, top: @dot_top)
end

def play
  return if @running
  @score = 0
  @secs_left = GAME_SECONDS
  @running = true
  @score_label.text = "Score: 0"
  @time_label.text = "Time: #{GAME_SECONDS}"
  @play_button.enabled = false
  place_player_in_middle
  place_dot
  @timer = every(1000) { tick }
end

def tick
  @secs_left -= 1
  @time_label.text = "Time: #{@secs_left}"
  return if @secs_left > 0
  @running = false
  @timer.stop
  @time_label.text = "Time is over"
  @play_button.enabled = true
end

def move(key)
  change = MOVES[key]
  return if !@running || change.nil?
  left = (@player_left + change[0]).clamp(0, FIELD_WIDTH - PLAYER_SIZE)
  top = (@player_top + change[1]).clamp(0, FIELD_HEIGHT - PLAYER_SIZE)
  place_player(left, top)
  return unless touches?
  @score += 1
  @score_label.text = "Score: #{@score}"
  place_dot
end

# true when the player and the dot overlap.
def touches?
  @player_left < @dot_left + DOT_SIZE && @dot_left < @player_left + PLAYER_SIZE &&
    @player_top < @dot_top + DOT_SIZE && @dot_top < @player_top + PLAYER_SIZE
end

run(title: "Catch the dots", width: 620, height: 520) do |page|
  page.color = PAGE_COLOR
  VGroup(gap: 14, padding: 24) do
    HGroup(hug: true, gap: 40) do
      @score_label = Label(text: "Score: 0", font_size: 20, bold: true, text_color: TEXT_LIGHT)
      @time_label = Label(text: "Time: #{GAME_SECONDS}", font_size: 20, bold: true, text_color: TEXT_LIGHT)
    end
    Box(width: FIELD_WIDTH, height: FIELD_HEIGHT, color: FIELD_COLOR, round: 10) do
      @dot = Box(0, 0, DOT_SIZE, DOT_SIZE, color: DOT_COLOR, round: DOT_SIZE / 2)
      @player = Box(0, 0, PLAYER_SIZE, PLAYER_SIZE, color: PLAYER_COLOR, round: 6)
    end
    @play_button = SmartButton(label_text: "Play", style_name: "ozdenDark", on_click: method(:play))
  end
  @player.set_motion("left 0.08s, top 0.08s")
  page.on(:key_down) { |_page, event| move(event.key) }
  place_player_in_middle
  place_dot
end
