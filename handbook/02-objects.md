# 2. Objects

Five plain objects make every window: `Box`, `Label`, `Button`, `Input` and `Icon`. The components of chapter 5 are
made of them. All five take named values: `Label(text: "Hi", font_size: 20)`.

| Object | What it is | Its own values |
|---|---|---|
| `Box` | a rectangle; the only object that holds other objects | `color:`, `border:`, `round:`, `scroll_y:` |
| `Label` | a text | `text:`, `html:`, `font_size:`, `bold:`, `text_color:`, `text_align:` |
| `Button` | a plain button of the system (the nicer one is `SmartButton`) | `text:` |
| `Input` | a one-line text field | `text:`, `placeholder:`, `on_enter:` |
| `Icon` | a picture | `picture:` (a path, the text of an SVG, the bytes of a PNG or a JPEG, an address) |

## A place and a size

An object outside a group has a place of its own: left, top, width and height, in px. They are the four values
without a name, in this order:

```ruby
Box(20, 20, 100, 100, color: "orangered")
Box(left: 20, top: 20, width: 100, height: 100, color: "orangered") # the same box
```

A size may also be a text: `width: "100%"` (of the box it is in), `height: "auto"` (as high as its content). An object
without a place starts at the top left corner of its box.

## Values

A value is a named value when the object is made, and a setter later:

```ruby
title = Label(text: "Report", font_size: 24, bold: true, text_color: "#2B2B2B")
title.text = "Monthly report"                                   # changes it on the screen
title.set(text: "Yearly report", font_size: 28, bold: false)    # more than one at once
puts title.text                                                 # "Yearly report": read in Ruby, no question to the page
puts title.font_size                                            # 28
```

- **Names:** the names of basic.js and the kit, in snake_case: `fontSize` is `font_size:`, `textColor` is
  `text_color:`. A wrong name is not lost: the terminal says
  `ozdenui: app.rb:12: Label: font_szie is not a value of Label (did you mean font_size?)`.
- **Numbers and flags:** a size in px is a number; a flag is `true` / `false`.
- **Colors:** any CSS color: `"red"`, `"#2A78D6"`, `"rgba(0, 0, 0, 0.5)"`.
- **A value that is not written keeps the default.** `nil` is "not written"; `""` is an empty text, written.
- **Reading:** `title.font_size`, `title.get(:font_size)` and `title[:font_size]` are the value the program gave. A
  flag given with `true` / `false` is read with a `?` at its end: `label.bold?`.

The values every object has:

| Value | Example |
|---|---|
| `color:` | the background: `color: "#FFFFFF"`, `color: "transparent"` |
| `border:`, `border_color:` | `border: 1, border_color: "#DDD"` |
| `round:` | the corners: `round: 8`; `round: 100` makes a circle of a square |
| `opacity:` | `opacity: 0.5` |
| `visible:` | `visible: false` hides it; in a group the others close the gap |
| `clickable:` | an object with an event takes clicks by itself; `clickable: false` lets them pass through |
| `cursor:` | `cursor: "pointer"` |
| `css:` | anything else of CSS: `css: { letter_spacing: "1px" }` |

A Hash is what you will meet again: a style, an item of a list, a row of a table.

### A value you did not give

`title.text` answers from Ruby because your code gave it. A value the page decides, like the width of a label without
a width, is asked with `measure`:

```ruby
width = title.measure(:width) # the width on the screen now, in px
```

Reading a value that was never given is `nil`. `measure` waits for the page, so use it when you need it, not in a
loop. The page itself is different: `page.width` and `page.height` are always current.

### Text and HTML

The `text:` of a `Label` or a `Button` is shown exactly as it is written, so a text typed by a user or read from a
file goes in as it is (a `<b>` stays `<b>`). HTML goes in as `html:`:

```ruby
note.text = typed_text
title.html = "<b>3</b> new"
```

In basic.js `text` is HTML; in Ruby it is the plain text. The texts of the components are shown as they are written
too (`SmartButton(label_text: typed)`); `allow_html: true` makes them HTML.

## Objects inside a Box

The objects made in the block of a `Box` go inside it. Their place is counted from the box's corner:

```ruby
require "ozdenui"
include OzdenUI

# A white circle with a check, as the text of an SVG: no file is needed.
CHECK = "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'>" \
        "<circle cx='12' cy='12' r='11' fill='white'/><path d='M7.5 12.5l3 3 6-7' fill='none' stroke='#2B2B2B' stroke-width='2.4'/></svg>"

def change
  typed = @input.text.strip
  typed = "Hello" if typed.empty?
  @label.text = typed
end

run(title: "A card", width: 360, height: 220) do |page|
  page.color = "#F4F5F7"
  Box(20, 20, 320, 110, color: "#5BBAC1", round: 12) do
    Icon(20, 25, 60, 60, picture: CHECK)
    @label = Label(100, 36, 200, 38, text: "Hello", font_size: 26, bold: true, text_color: "white")
  end
  @input = Input(20, 150, 200, 40, placeholder: "Write a text", on_enter: method(:change))
  Button(230, 150, 110, 40, text: "Change", on_click: method(:change))
end
```

- `Box(...) do ... end`: the block runs at once, and what it makes goes into the box. The block is optional:
  `Box(color: "white")` is an empty box. Alone, with no value and no block, it needs its brackets: `Box()`.
- **Only a `Box` (and the groups, which are boxes) holds objects.** A `Label` or a `Button` takes no block. To put
  something over a button, make it next to the button in the same box, at the same place.
- `picture:` takes a path of this computer (`"photo.png"`), the text of an SVG, the bytes of a PNG or a JPEG
  (`File.binread("photo.png")`, or a picture your program made), or an address.
- `on_enter: method(:change)`: Enter in the field does what the button does.
- `examples/basics.rb` is this card, with a color that changes at every press.

## Hiding, removing, adding later

```ruby
require "ozdenui"
include OzdenUI

def toggle
  return if @note.nil?
  if @note.visible == false
    @note.show
  else
    @note.hide
  end
end

def measure_note
  return if @note.nil?
  @info.text = "The note is #{@note.measure(:width)} px wide."
end

def remove_note
  return if @note.nil?
  @note.remove
  @note = nil # a removed object is not used again
  @info.text = "The note is gone."
end

run(title: "Hide and remove", width: 420, height: 300) do |page|
  page.color = "#F4F5F7"
  VGroup(gap: 14) do
    @note = Label(text: "A note to hide", font_size: 22, color: "white", round: 8, padding: [14, 8])
    HGroup(hug: true, gap: 8) do
      SmartButton(label_text: "Hide / show", on_click: method(:toggle))
      SmartButton(label_text: "Measure", on_click: method(:measure_note))
      SmartButton(label_text: "Remove", tone: "orange", on_click: method(:remove_note))
    end
    @info = Label(text: "The width is asked of the page.", font_size: 14, text_color: "#5A6270")
  end
end
```

- `hide` and `show` change `visible`; a hidden object keeps its values, and `show` brings it back.
- `remove` removes the object and every object inside it, for good: make a new one to show it again. A removed object
  is not used again: the program above forgets it (`@note = nil`).
- `box.add { ... }` makes more objects in a box or a group later, in an event or a timer:

```ruby
list.add do
  Label(text: "One more")
end
```

## When a box has more than it can show

`scroll_y: true` makes a box scroll its content up and down (`scroll_x: true` sideways). In a group, the `ScrollArea`
of chapter 3 does the same and takes the room it is given.

## Next

[Chapter 3: Layout](03-layout.md): groups place the objects for you.
