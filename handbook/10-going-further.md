# 10. Going further

## Finding a mistake

There is no compiler to check a program before it runs, so OzdenUI checks the names while it runs and tells you, with
the line of your program:

- **A name that is not a value of the object** (in a named value, a setter or `set`) is told once:

  ```
  ozdenui: app.rb:17: Label: font_szie is not a value of Label (did you mean font_size?)
  ozdenui: app.rb:24: TextField: warning_txt is not a value of TextField (did you mean warning_text?)
  ```

- **A method that does not exist** (`graph.set_typ("line")`) raises a `NoMethodError` with the name it was close to:
  `set_typ is not a value or a method of GraphBox (did you mean set_type?)`.
- **A value that was never given** (`label.width` of an `"auto"` label) is `nil`: `measure(:width)` asks the page.
- **An error in an event or a timer** does not close the window with your work in it: the terminal writes
  `ozdenui: a task failed: ...` and the lines of your program that led to it, and the window keeps working.
- **An object changed from a thread of your own** raises with the fix in its message: `ui { ... }`.
- **A message of the page** (a component that could not do what it was asked) comes as `ozdenui (page ...): ...`.
- `run(debug: true)` gives the window the developer tools of the web view: right click > Inspect Element.

So: run the program, and **read the terminal**.

## basic.js from Ruby

Everything of basic.js and of the kit is reachable, also what has no Ruby method yet:

```ruby
gauge.call(:set_value, 80)                          # a method of the object on the page; not waited for
text = editor.ask(:get_selected_text)               # a method, and its result
width = label.measure(:width)                       # a value as the page has it now (a size of "auto")
field.part(:input).call(:select)                    # a box inside a component

# Any JavaScript; label.js is the object.
value = evaluate("#{label.js}.elem.offsetWidth")

# Any component of the kit by its name, and a name of the kit that is not snake_case, as a text.
gauge = component("Gauge", value: 72, width: 200)
LoginPage("tab_border" => 1)
```

- `call` goes with the other commands of the task. `ask`, `measure` and `evaluate` wait for the page, so keep them
  out of loops. A method of the kit is also a method of the object (`gauge.set_value(80)`); `call` is for a name that
  Ruby already uses: `chat.call(:send, text)`.
- What comes back from the page is plain: a number is an Integer or a Float, a flag of the kit is `1` / `0`, a list is
  an Array, an object a Hash read with a text or a symbol (`row["name"]`, `row[:name]`). `on?(value)` reads a flag.
- `ozdenui doc` of a component lists its methods; what each takes is in its file of the kit:
  [lib/ozdenui/web/comp](https://github.com/bug7a/ozdenui-ruby/tree/main/lib/ozdenui/web/comp). Its params keep their
  names in camelCase there.

```ruby
require "ozdenui"
include OzdenUI

# Makes the line as wide as the title: a size of "auto" is known only by the page.
def underline
  width = @title.measure(:width).to_f
  @line.width = width
  pixels = evaluate("window.devicePixelRatio")
  @info.text = "The title is #{width.round} px wide; the pixel ratio of this screen is #{pixels}."
end

def retitle
  @title.text = @name.text
  underline
  @name.part(:input).call(:select) # the text of the field is selected, ready for the next one
end

run(title: "Measured", width: 480, height: 340) do |page|
  page.color = "#F4F5F7"
  VGroup(gap: 14, padding: 24, align: "left top") do
    @title = Label(text: "Measured by the page", font_size: 26, bold: true)
    @line = Box(width: 20, height: 4, color: "#2A78D6", round: 2)
    @name = TextField(title_text: "A new title", value: "Hello", width: 300, on_enter: method(:retitle))
    SmartButton(label_text: "Use it", tone: "cyan", on_click: method(:retitle))
    @info = Label(text: "-", font_size: 14, text_color: "#5A6270")
  end
  @line.set_motion("width 0.3s") # the page moves the width; Ruby gives only the end
  underline
end
```

## Threads, again

| | may change objects | may ask the page (`ask`, `measure`, `evaluate`) and show a dialog |
|---|---|---|
| the block of `run`, events, timers (the thread of the window) | yes | yes |
| a thread of yours | inside `ui { ... }` | inside `ui { ... }`, but the thread does not wait for it |

Any thread may call `ui`, `close`, `set_theme` and write to `log.writer(level)`.

## Speed

What makes a window slow is almost always one of two things:

- **A question to the page in a loop**: every `measure`, `ask` or `evaluate` waits for an answer. Reading what your
  program gave or what a component told (`obj.text`, `field.text`, `box.checked?`) asks nothing.
- **A slow job on the thread of the window**: the window does not answer until it ends. Put it in a thread
  (chapter 4).

All the commands of one task go to the page together when it ends, so making 500 objects in a loop is one message,
not 500. A long task that must stay on the thread of the window can show its progress with `flush`: the commands made
until then go to the page at once.

```ruby
require "ozdenui"
include OzdenUI

LIMIT = 400_000
PARTS = 20

def prime?(number)
  return false if number < 2
  divisor = 2
  while divisor * divisor <= number
    return false if (number % divisor).zero?
    divisor += 1
  end
  true
end

# Runs on the thread of the window: flush shows each part as soon as it is done.
def count_primes
  count = 0
  step = LIMIT / PARTS
  PARTS.times do |part|
    (part * step...(part + 1) * step).each { |number| count += 1 if prime?(number) }
    @bar.value = part + 1
    flush
  end
  @result.text = "Primes under #{LIMIT}: #{count}"
end

run(title: "Primes", width: 420, height: 260) do |page|
  page.color = "#F4F5F7"
  VGroup(gap: 16, padding: 24) do
    @bar = ProgressBar(title_text: "Numbers checked", value: 0, max_value: PARTS, width: 320)
    SmartButton(label_text: "Count the primes", tone: "cyan", on_click: method(:count_primes))
    @result = Label(text: "Primes under #{LIMIT}: ?", font_size: 15)
  end
end
```

The bar moves, but a click waits until the count ends. A job of seconds belongs in a thread with `ui { }`.

## A picture of the window, a check without a person

```
OZDENUI_LOOK=app.png ruby app.rb                         # runs the program, saves app.png, ends; no window
OZDENUI_THEME=dark OZDENUI_LOOK=dark.png ruby app.rb     # the dark window, without a change of the code
OZDENUI_LOOK_WAIT=3 OZDENUI_LOOK=app.png ruby app.rb     # 3 s after the first drawing (default 1.5)
OZDENUI_LOOK_SCALE=2 OZDENUI_LOOK=app.png ruby app.rb    # a picture with twice the dots
OZDENUI_WINDOW=headless ruby app.rb                      # a hidden window, until the program calls close
OZDENUI_WINDOW=browser ruby app.rb                       # the app window of Edge or Chrome, also on macOS
OZDENUI_WINDOW=tab ruby app.rb                           # a tab of the default browser
```

- A picture needs Chrome, Edge or Chromium on the computer. A program that runs without an error can still have a
  part covered, cut or squeezed: the picture shows it.
- A check of a program closes it from the code: `after(3000) { close }` as the first line of the block of `run`. It
  must not reach a dialog: a dialog waits for a person.

## With an AI assistant

OzdenUI is new, so an AI assistant (Claude Code, Codex, Cursor, Copilot...) does not know it yet and guesses from the
toolkits it knows. The `ozdenui` command of the gem writes the rules of the gem into the folder of your project, where
the assistant reads them by itself:

```
ozdenui agents              # into AGENTS.md
ozdenui agents CLAUDE.md    # into the file Claude Code reads
ozdenui agents --print      # only prints them
ozdenui doc SelectBox       # the params of a component, for you and for the assistant
```

- The rules are short: how a program is made, the layout, the events, the components, the mistakes to avoid, and
  `OZDENUI_LOOK`, so the assistant looks at the window it made.
- A file that is there keeps your lines: the rules go to its end, between two marks. Run the command again after an
  update of the gem (`gem update ozdenui`): only that part changes.

## Giving a program to someone else

A Ruby program is its `.rb` files: there is nothing to build. The other computer needs Ruby 2.6 or newer (macOS has
one) and the gem. A `Gemfile` next to the program says what it needs:

```ruby
source "https://rubygems.org"

gem "ozdenui"
gem "fiddle" if RUBY_VERSION >= "3.5" # the window of macOS: fiddle left the default gems of Ruby 3.5
```

```
bundle install
bundle exec ruby app.rb
```

- The page, basic.js and the components are inside the gem, so the program needs no other file of the kit and no
  internet. Its own files (pictures, data) go with it.
- Without Bundler, `gem install ozdenui` and `ruby app.rb` are enough.

## Limits of v0.1

- macOS is the tested system. Windows and Linux open the app window of Edge or Chrome (with none of them, a tab of the
  default browser); they are checked by the tests of the repository, not yet by hand.
- On macOS the menu bar names the program by the title of its window, but the Dock shows it as a Ruby program (it is
  not an app bundle).
- One window for a program.
- A callback that must answer at once can not be a block of the program, because the answer comes later: a validator,
  a block that builds the objects of a row (`createItemView`). Format the values of a table in Ruby; the numbers of a
  `GraphBox` or a `Stepper` take a format text (chapter 8).
- A file dropped on a `FilePicker` gives its name, not its path; a file chosen with a click has its path (chapter 6).
- A bubble of a `Tooltip` shows a text, not objects of your own.
- Sixteen components change their theme while they are on the page; the others take it when they are made (chapter 7).
- No hot reload: `ruby app.rb` again.

## Where to go next

- **The examples** of the gem, from the smallest: `counter`, `greeting`, `basics`, `notes`, `todo`, `form`,
  `settings`, `calculator`, `dialogs`, `clock`, `game`, `charts`, `csv_viewer`, `json_viewer`, `image_viewer`,
  `editor`, `markdown_editor`, `job_log`, `chat`, `gallery` (the main components), `minimal_theme`.
- **The README** of the gem: every component in one table.
- **`ozdenui doc SelectBox`**: every param of a component with its default, its looks, the values it keeps and its
  methods; `ozdenui doc`: the names of every component.
- **[basic.js](https://bug7a.github.io/basic.js/)** and **[the components](https://bug7a.github.io/js-components/)**:
  the library under it, with a live example of every component.

[Back to the start](README.md)
