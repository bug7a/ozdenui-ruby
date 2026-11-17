# 3. Layout

A place of its own (`Box(20, 20, ...)`) is good for a game or a drawing. A window of a program is easier with
**groups**: they place their objects, and place them again when the window changes its size.

## VGroup and HGroup

```ruby
VGroup(gap: 10, padding: 20, align: "left top") do
  Label(text: "One")
  Label(text: "Two") # under "One", 10 px lower
  HGroup(hug: true, gap: 8) do
    SmartButton(label_text: "Yes")
    SmartButton(label_text: "No") # next to "Yes"
  end
end
```

- `VGroup` puts its objects one under the other, `HGroup` side by side.
- A group is as large as its box: `width: "100%"`, `height: "100%"`. `hug: true` makes it only as large as its objects.
- `gap:`: the space between the objects. `padding:`: the space inside its edge: `20`, or `[x, y]` (`[30, 12]`).
- `align:`: where the objects stand: `"center"` (the default), `"left top"`, `"right center"`, `"center bottom"`...
- `wrap: true`: the objects go on to the next line when there is no room (cards, tags).
- A group is a `Box`: `color:`, `round:`, `border:` work on it too.

In a group an object needs only its size: `Label(text: "One", width: 200)`. Without a size it is as large as its
content.

**A group inside a group** almost always needs one of these: `hug: true` (as large as its objects), a height
(`height: "auto"` or a number), or `fill: true` (below). Two groups of 100% in one `VGroup` squeeze each other.

**More than fits:** a group with more than its box can hold squeezes its objects, and one can cover another (a title
under a card). Give the window more room, or put the content in a `ScrollArea` (below).

## Taking the room that is left: fill

A typical window: a bar on top, a part in the middle that takes all the room, a line at the bottom.

```ruby
require "ozdenui"
include OzdenUI

FOLDERS = ["All", "Work", "Home"].freeze

run(title: "Notes", width: 640, height: 420) do |page|
  page.color = "#F4F5F7"
  VGroup(gap: 0) do
    HGroup(height: 52, padding: [16, 0], gap: 10, align: "left center", color: "white") do
      Label(text: "Notes", font_size: 18, bold: true)
      SmartButton(label_text: "New", tone: "cyan")
    end
    HGroup(gap: 0, fill: true) do
      VGroup(width: 180, height: "100%", padding: 16, gap: 8, align: "left top", color: "#E9EBEF") do
        FOLDERS.each { |folder| Label(text: folder, font_size: 15) }
      end
      ScrollArea(padding: 16, gap: 12) do
        (1..40).each { |number| Label(text: "Note #{number}", font_size: 15) }
      end
    end
    Label(text: "40 notes", font_size: 13, text_color: "#5A6270", height: 28)
  end
end
```

- `fill: true` gives an object the room the others leave: **the height** that is left in a `VGroup` (the middle row
  between the bar and the bottom line), **the width** that is left in an `HGroup`. Any object and any component
  takes it: `HGroup(fill: true)`, `LogView(fill: true)`, `Splitter(fill: true)`.
- `fill:` is given when the object is made; it can not be changed later with a setter.
- `ScrollArea` takes the room the others leave by itself (its width and height are `"100%"` of what is left) and
  scrolls what is in it. As an object of the page (not in a group) it is the whole window.
- Its objects go one under the other, as in a `VGroup`, from the top left: give it `align:`, `gap:` and `padding:`
  (the padding scrolls with them). `scroll_x: true` scrolls to the side too. It has the scroll bar of the kit, light
  or dark with the window.

## GridGroup: columns and rows

```ruby
require "ozdenui"
include OzdenUI

KEYS = "789/456*123-0.=+".chars.freeze

run(title: "Keys", width: 320, height: 300) do
  VGroup(padding: 16, align: "left top") do
    GridGroup(columns: 4, gap: 8) do |grid|
      KEYS.each { |key| SmartButton(label_text: key, width: "100%") }
      clear_key = SmartButton(label_text: "Clear", width: "100%", tone: "orange")
      grid.place(clear_key, column_span: 4)
    end
  end
end
```

- The objects go into the cells in order, left to right, row by row.
- `columns: 4`: equal columns. `columns: [120, "1fr", "auto"]`: 120 px, the rest, as wide as its content.
- An object fills its cell; `align: "left center"` on the grid puts each one in its cell instead.
- `grid.place(obj, column_span: 2)`, `grid.place(obj, column: 1, row: 0)`: a cell of its own (counted from 0).
- **The block of a group gets the group** (`|grid|`), so it can be used before the group is in a variable. `current`
  is the same: the box that takes the objects made now.
- Unlike the other groups, a grid is as high as its rows (`height: "auto"`). `padding:`, `color:` and `round:` work on
  it, as on a group. `examples/calculator.rb` is a whole calculator.

## Things that go out of a group

A group does not cut what goes out of its edge: a button's focus ring, a shadow or a button that grows under the mouse
shows whole, also in a small group:

```ruby
HGroup(hug: true, gap: 8) do
  SmartButton(label_text: "Save", tone: "cyan")
  SmartButton(label_text: "Cancel")
end
```

`clip_content: true` cuts, where cutting is the point (a picture in a frame). A group that scrolls (`scroll_y: true`)
and a `ScrollArea` cut by themselves.

Two defaults are not the ones of basic.js, so that a program says less:

- A `VGroup` / `HGroup` of basic.js cuts its content; in Ruby it does not.
- `MenuBar`, `ToolBar`, `StatusBar`, `SearchInput` and `FilePicker` do not shrink in a group (`shrink: 0`): they keep
  their height while a `ScrollArea` or a `fill: true` object takes the rest.

## A place of its own

Outside a group, in a `Box` or on the page, an object stands where you put it: left, top, width, height. It is the way
for a game, a drawing or an overlay:

```ruby
Box(width: 400, height: 300, color: "#1E2230") do
  @player = Box(180, 130, 40, 40, color: "#5BBAC1", round: 8)
end
@player.left = 200 # moves it to 200 px from the left of its box
```

`@player.left` reads back what your code gave, without a question to the page, so it is a good place to keep the
place: `@player.left += 20`. `examples/game.rb` moves a box with the arrow keys this way. A size may be a text:
`width: "100%"` fills its box.

## When the window changes its size

Groups place their objects again by themselves. For your own sums, `page.width` and `page.height` are always current,
and `page.on(:resize)` tells you:

```ruby
require "ozdenui"
include OzdenUI

def show_size(page)
  @size.text = "#{page.width.round} x #{page.height.round}"
end

run(title: "The size", width: 420, height: 240) do |page|
  page.color = "#F4F5F7"
  @size = Label(20, 60, font_size: 28, bold: true)
  Label(20, 20, text: "Change the size of the window.", font_size: 15, text_color: "#5A6270")
  show_size(page)
  page.on(:resize, method(:show_size))
end
```

`page.on(:resize, ...)` takes the same kinds of handler as every event (chapter 4): here a method that takes the page.

## Next

[Chapter 4: Events and time](04-events-and-time.md): clicks, keys, timers and long jobs.
