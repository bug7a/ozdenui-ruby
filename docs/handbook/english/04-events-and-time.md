# 4. Events and time

## An event is a lambda, a method or a block

```ruby
Button(text: "Save", on_click: method(:save))   # when it is made
button.on_click = -> { save }                   # later: it takes the place of the one before
remove = button.on(:click) { log_click }        # one more handler; remove.call takes it away
```

The named values for events: `on_click:`, `on_input:`, `on_enter:`, `on_key_down:`, `on_mouse_enter:`,
`on_mouse_leave:`, `on_focus:`, `on_blur:`. Any other event of the page works with `on`, in snake_case or as the page
writes it: `:dblclick`, `:mouse_enter`, `:key_up`, `:context_menu`.

### The handler takes what it needs

```ruby
Button(text: "Save", on_click: -> { save })                        # nothing
Button(text: "Save", on_click: ->(button) { save(button) })        # the object
Button(text: "Save", on_click: ->(button, event) { puts event.x }) # the object and the event
Button(text: "Save", on_click: method(:save)) # a method: def save, def save(button) or def save(button, event)
```

A lambda and a method get as many values as they ask for; a block (`obj.on(:click) { |obj, event| ... }`) gets both
and takes the ones it names. A value that is not a lambda, a method or a block stops the program with the line where
it was given.

**In a loop, `each` gives every block its own variable**, so the obvious code is right:

```ruby
(1..5).each do |number|
  SmartButton(label_text: number.to_s, on_click: -> { pick(number) })
end
```

A `for` loop shares one variable between its turns: every lambda made in it would see the last number. Use `each`.

The event has what it knows:

| Reader | When |
|---|---|
| `key`, `code` | a key: `"Enter"`, `"a"`, `"ArrowLeft"`; `code` is the place on the keyboard (`"KeyA"`) |
| `shift`, `ctrl`, `alt`, `meta` | a key: `true` while held (`meta` is Cmd on a Mac) |
| `x`, `y` | the mouse, in px from the window's corner |
| `text` | an `Input`: its text |
| `name` | the name of the event: `"click"`, `"keydown"` |

```ruby
require "ozdenui"
include OzdenUI

SPOT_COLOR = "#5BBAC1"
HOVER_COLOR = "#E0A038"

def show_key(_page, event)
  held = []
  held << "Ctrl" if event.ctrl
  held << "Alt" if event.alt
  held << "Shift" if event.shift
  held << "Meta" if event.meta
  @pressed.text = (held + [event.key]).join(" + ")
end

run(title: "Events", width: 420, height: 300) do |page|
  page.color = "#F4F5F7"
  VGroup(gap: 14) do
    @pressed = Label(text: "Press a key", font_size: 28, bold: true)
    @spot = Box(width: 160, height: 60, color: SPOT_COLOR, round: 10)
    @where = Label(text: "Click the box", font_size: 14, text_color: "#5A6270")
  end
  page.on(:key_down, method(:show_key))
  @spot.on(:mouse_enter) { @spot.color = HOVER_COLOR }
  @spot.on(:mouse_leave) { @spot.color = SPOT_COLOR }
  @spot.on(:click) do |_box, event|
    @where.text = "Clicked at #{event.x.round}, #{event.y.round}"
  end
end
```

`page.on(:key_down)` hears every key of the window; a field that has the focus hears its own keys too.

## One thread: no locks

The block of `run`, every event and every timer run **one at a time, on one thread** (the thread of the window). Two
clicks never run at the same time, and a value you read is the value of now. You need no locks, also for the
variables of your program that only these blocks use.

The other side of it: while one block runs, the window waits. A block that takes 3 seconds freezes the window for 3
seconds. So **never `sleep` in an event**: wait with a timer, and give a slow job a thread (below).

## Time: every and after

```ruby
require "ozdenui"
include OzdenUI

def tick
  @clock.text = Time.now.strftime("%H:%M:%S")
end

run(title: "Clock", width: 360, height: 220) do
  VGroup(gap: 12) do
    @clock = Label(text: Time.now.strftime("%H:%M:%S"), font_size: 48, bold: true)
    SmartButton(label_text: "Stop the clock", on_click: -> { @timer.stop })
  end
  @timer = every(1000) { tick }               # again and again, every 1000 ms
  after(5000) { set_title("Clock — 5 s") }    # once
end
```

- `every(ms) { ... }` and `after(ms) { ... }` return a timer: `timer.stop` ends it (`timer.cancel` is the same).
- A timer is a task too: it runs on the thread of the window, between the clicks, so it may change any object. A tick
  that comes while the one before still runs is not piled up.
- `-> { @timer.stop }` reads `@timer` at the click, so it does not matter that the timer is made after the button.
- `examples/clock.rb` adds a stopwatch.

## A slow job: a thread and ui { }

```ruby
require "ozdenui"
include OzdenUI

STEPS = 100

def begin_job
  @button.waiting = true # a clock on the button: it takes no clicks now
  @result.text = ""
  Thread.new { work }
end

def work
  (1..STEPS).each do |step|
    sleep(0.03) # the slow part: a big file, a download, a model
    ui { @bar.value = step }
  end
  ui do
    @button.waiting = false
    @result.text = "Done."
  end
end

run(title: "A slow job", width: 420, height: 260) do |page|
  page.color = "#F4F5F7"
  VGroup(gap: 14) do
    @bar = ProgressBar(title_text: "Working", value: 0, max_value: STEPS, width: 320)
    @button = SmartButton(label_text: "Start", tone: "cyan", on_click: method(:begin_job))
    @result = Label(font_size: 16)
  end
end
```

- `Thread.new { work }`: the job runs on a thread of its own; the window keeps working.
- **Objects are changed only on the thread of the window.** A thread of yours gives its changes to it with
  `ui { ... }`: the block runs there, after the task that runs now. Any thread may call `ui`: a server, a socket, a
  watcher of files.
- An object changed from another thread raises, and the message gives the fix:
  `... works only in the block of run, an event or a timer. From another thread: ui { ... }`. Nothing breaks without
  a word.
- Give the job what it needs before it starts (a text of a field, a path), as values of its own.
- A job that waits (a download, a file, another program) is what a thread is best for. Ruby runs one thread at a
  time, so a job that only computes shares the time with the window: it keeps answering, a little slower.
- `close` works from any thread.
- `examples/job_log.rb` copies files this way and writes what it does into a `LogView`.

### A long task that shows its progress

The commands of a task go to the page when the task ends. A task that must stay on the thread of the window for a
while (many objects at once) can send what it made so far with `flush`.

## The order of events

Events reach Ruby in the order they happened, also when many come at once (fast typing), and each one runs as its own
task. A fast and continuous one (`obj.on(:mouse_move) { ... }`) sends every move to Ruby. A component that is dragged
(a `Slider`, a `Splitter`) does its moves on the page and tells you the result (`on_change:`, `on_change_end:`).

## Next

[Chapter 5: Components](05-components.md): the ready parts of a window.
