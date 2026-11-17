# OzdenUI for Ruby — The Handbook

Build a desktop window in plain Ruby: objects, groups and ready components. Only Ruby: no JavaScript, no HTML, no
CSS, no build step and no compiler. This handbook teaches it step by step, for people who know Ruby and have never
written a web page.


```ruby
require "ozdenui"
include OzdenUI

run(title: "Hello", width: 360, height: 200) do
  VGroup(gap: 12) do
    Label(text: "Hello from Ruby", font_size: 24, bold: true)
    SmartButton(label_text: "Close", on_click: -> { close })
  end
end
```

## The chapters

| | Chapter | You learn |
|---|---|---|
| 1 | [The first window](01-first-window.md) | install, `run`, its block, the options of the window, how the window and your code talk |
| 2 | [Objects](02-objects.md) | `Box`, `Label`, `Button`, `Input`, `Icon`; named values; values you set and read; removing |
| 3 | [Layout](03-layout.md) | `VGroup`, `HGroup`, `GridGroup`, `fill: true`, `ScrollArea`, a place of its own |
| 4 | [Events and time](04-events-and-time.md) | clicks and keys, the event, `every` and `after`, a thread and `ui { }` |
| 5 | [Components](05-components.md) | the ready parts: buttons, fields, choices, lists, tables, tabs, bars |
| 6 | [Dialogs, messages and files](06-dialogs-and-files.md) | `confirm`, toasts, bubbles, the file dialogs of the system |
| 7 | [Looks](07-looks.md) | dark windows, the minimal look in your color, the colors of one component |
| 8 | [Data and pictures](08-data-and-pictures.md) | charts, big tables, logs, Markdown, JSON, code, pictures |
| 9 | [Your own component](09-your-own-component.md) | a class of yours made of objects, shared as a file or a gem |
| 10 | [Going further](10-going-further.md) | basic.js from Ruby, speed, threads, limits, finding a mistake |

Read 1 to 4 in order: they are the whole idea. Then take the chapters you need.

## How to read it

- Every program that starts with `require "ozdenui"` is complete: save it as `app.rb` and run it with `ruby app.rb`
  (after `gem install ozdenui`). A check of the gem runs and draws every one of them, so they stay true.
- The examples of the gem (the `examples/` folder of its source) are longer programs: a to-do list, a calculator, a
  CSV viewer, an editor, a small game. The chapters name them where they fit. From a clone of the repository:
  `ruby -Ilib examples/todo.rb`.
- A name in `code` is a name in Ruby. The page of the window is made with [basic.js](https://bug7a.github.io/basic.js/),
  a small JavaScript library; you never need to write JavaScript, but chapter 10 shows how to reach it.
- Every param of every component is in the terminal: `ozdenui doc SelectBox`, and in
  [COMPONENTS.md](https://github.com/bug7a/ozdenui-ruby/blob/main/lib/ozdenui/COMPONENTS.md). The gem:
  [rubygems.org/gems/ozdenui](https://rubygems.org/gems/ozdenui). The site: https://bug7a.github.io/ozdenui-ruby/

## In one minute

- `run(title: ..., width: ..., height: ...) do |page| ... end` opens a window. Its block makes the objects; `page` is
  the window's ground.
- An object is made where it is written: inside the block of a box or a group, it goes into that box or group.
- A group places its objects: `VGroup` one under the other, `HGroup` side by side.
- A value is a named value when the object is made (`Label(font_size: 20)`) and a setter later
  (`label.font_size = 24`, `label.set(text: "Hi", font_size: 24)`).
- An event is a lambda, a method or a block: `on_click: method(:save)`. It may take nothing, the object, or the
  object and the event.
- Components keep their state in Ruby: `box.checked?`, `select_box.value`, `field.text`. Reading it asks nothing of
  the page.
- Your code runs on one thread: an event, a timer and the block of `run` never run at the same time.
