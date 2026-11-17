# 1. The first window

## Install

```
gem install ozdenui
```

It needs Ruby 2.6 or newer, and no other gem: nothing is compiled, so no C compiler and no build tools are needed.

- **macOS:** the window is the web view of the system (WKWebView), inside your program, made with `fiddle`, the
  library of Ruby that calls the system. It works with the Ruby that comes with macOS (`/usr/bin/ruby`); with that
  Ruby, `gem install --user-install ozdenui` installs the gem in your home folder (its own folder of gems needs
  `sudo`).
- **Windows, Linux:** the window is an app window of Edge or Chrome: no address bar, no tabs. On Windows, Edge is
  always there.

There is no build step: `ruby app.rb` runs the program as it is written.

## The smallest window

```ruby
require "ozdenui"
include OzdenUI

run {}
```

An empty window of 800 x 600 px, titled "OzdenUI". `ruby app.rb` opens it and returns when you close it.

## A window with a counter

```ruby
require "ozdenui"
include OzdenUI

@count = 0

def change(step)
  @count += step
  @label.text = @count.to_s
end

run(title: "Counter", width: 400, height: 320) do |page|
  page.color = "#F4F5F7"
  VGroup(gap: 16) do
    @label = Label(text: "0", font_size: 64, bold: true)
    HGroup(hug: true, gap: 12) do
      SmartButton(label_text: "−", on_click: -> { change(-1) })
      SmartButton(label_text: "+", tone: "cyan", on_click: -> { change(1) })
    end
  end
end
```

Read it from the top:

- **`require "ozdenui"`** loads the gem; **`include OzdenUI`** gives its short names (`run`, `Label`, `toast`).
  Without it every name is a method of the module: `OzdenUI.run`, `OzdenUI.Label(...)`.
- **`run(...) do |page| ... end`** is the window. It opens it, runs the block when the page is ready, and returns when
  the window is closed. Call it once, at the end of the program.
- **The block of `run`** makes the objects. `page` is the ground of the window: it has a color, a width and a height,
  and every object without a box of its own is on it. Objects are made in this block or later (in an event, a
  timer), never before `run`.
- **`VGroup(gap: 16) do ... end`** is a group: the objects made inside its block go into it, one under the other,
  16 px apart. The `HGroup` inside it puts the two buttons side by side; `hug: true` makes it only as large as its
  buttons.
- **`Label(text: "0", font_size: 64, bold: true)`** is a text. Its values are named values, the names of basic.js in
  snake_case.
- **`on_click: -> { change(-1) }`** is the event: a click runs the lambda.
- **`@label.text = ...`** changes the label. `@label.text` reads it back, without asking the window.

Keep the objects you change later in variables (here `@label`); the others need none. An instance variable at the top
of the file is seen by the block of `run` and by the methods of the file.

`examples/counter.rb` of the gem is a program like this one.

## How it works

The window shows a page that is inside the gem. The page holds basic.js and the components of the kit; the gem
carries them, so no internet is needed. It is served only to this computer.

```
your Ruby code ──commands──▶ the page (basic.js objects) ──▶ what you see
        ▲                                     │
        └──────────── events (a click) ◀──────┘
```

- An object in Ruby is a small proxy: it keeps an id and the values it was given, and sends commands to the page,
  where the real object lives. All the commands of one task (the block of `run`, an event, a timer) go to the page
  together, when the task ends.
- A click on the page calls your block on the thread of the window (chapter 4).
- Your code is plain Ruby, with every gem you like: files, databases, `net/http`, an AI client.

## The options of the window

```ruby
run(
  title: "Notes",    # the title of the window ("OzdenUI" when not given)
  width: 800,        # the size of the page in px (800 x 600 when not given)
  height: 600,
  theme: "light",    # "light", "dark" or "auto" (what the system asks): chapter 7
  style: nil,        # nil or "minimal": chapter 7
  language: "en",    # the language of its texts: "tr" writes the capital letters of Turkish ("İ")
  debug: false       # true: the developer tools of the web view (right click > Inspect Element)
) do |page|
  # ...
end
```

A name that `run` does not know stops the program at once, with the list of the names it takes. The other methods of
the window work in the block of `run`, an event or a timer (`close` also from any thread):

```ruby
set_title("Notes — saved")
close             # closes the window; run returns
theme             # "light" or "dark"
dark?             # true in a dark window
set_theme("dark") # the window again in another theme: chapter 7
```

## A program in more than one method

Most programs keep the objects they change later. Instance variables at the top of the file are the simplest place,
and a method of the file can be given as an event with `method(:name)`:

```ruby
require "ozdenui"
include OzdenUI

def greet
  typed = @name.text.strip
  if typed.empty?
    @answer.text = "Write your name first."
    return
  end
  @answer.text = "Hello, #{typed}!"
end

run(title: "Greeting", width: 420, height: 320) do |page|
  page.color = "#F4F5F7"
  VGroup(gap: 14, padding: 40) do
    @name = TextField(title_text: "What is your name?", placeholder: "Ada", width: 300, on_enter: method(:greet))
    SmartButton(label_text: "Greet", tone: "cyan", on_click: method(:greet))
    @answer = Label(font_size: 18)
  end
end
```

`@name.text` is always the text in the field: the page sends it with every key. A `Label` shows a typed text as it
is (a `<b>` stays `<b>`).

A class of your own works just as well (`@name = TextField(...)` in its methods, then
`run { NotesApp.new.start }`): chapter 9 makes a component of yours that way. Do not name your own top-level methods
like the ones of OzdenUI (`run`, `close`, `ask`, `page`, `after`) or of Ruby (`send`, `format`, `open`).
`examples/greeting.rb` is a program like the one above.

## Looking at a window without opening it

```
OZDENUI_LOOK=app.png ruby app.rb
```

runs the program as it is, saves a picture of its window as `app.png` and ends; no window opens. It needs Chrome,
Edge or Chromium on the computer. `OZDENUI_THEME=dark` shows the dark window, and `OZDENUI_LOOK_WAIT=3` waits three
seconds before the picture. A program that runs without an error can still have a part covered or cut: a look at the
picture tells it.

## When the page is loaded again

With `debug: true`, a reload of the page (right click > Reload) makes the objects again: the block of `run` runs
again, the timers stop, and the terminal says `ozdenui: the page was loaded again: the block of run runs again`. A
program that keeps its data in Ruby (an Array, a file) shows it again; nothing else is needed.

## Next

[Chapter 2: Objects](02-objects.md): the five plain objects and their values.
