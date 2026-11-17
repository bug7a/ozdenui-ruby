# 9. Your own component

A part you need more than once (a card, a row of a form, a rating) becomes a class of yours: its `initialize` makes
its objects, keeps the ones it changes, and its methods change them. No JavaScript is needed, and nothing to
register: it is plain Ruby.

## A card

```ruby
require "ozdenui"
include OzdenUI

# A component of this program: a title, a text and a button.
class Card
  attr_reader :box # the group that holds the card

  # Makes a card in the group it is made in. The block runs when its button is clicked.
  def initialize(title, text, &on_open)
    @on_open = on_open
    @box = VGroup(width: 220, height: "auto", align: "left top", padding: 16, gap: 8, color: "white", round: 12) do
      @title = Label(text: title, font_size: 18, bold: true)
      Label(text: text, font_size: 15, text_color: "#5A6270")
      SmartButton(label_text: "Open", on_click: -> { @on_open.call(self) if @on_open })
    end
  end

  # Changes its title.
  def title=(title)
    @title.text = title
  end
end

run(title: "Cards", width: 760, height: 240) do |page|
  page.color = "#F4F5F7"
  HGroup(gap: 16, padding: 24, wrap: true) do
    ["Sales", "Stock", "Orders"].each do |name|
      Card.new(name, "Updated today.") { |card| card.title = "Opened" }
    end
  end
end
```

- **`Card.new` makes the objects where it is called**, as a component of the kit does: inside the block of a group,
  the card goes into that group. `include OzdenUI` at the top gives the class the short names too.
- **The object keeps its objects** in its instance variables (`@box`, `@title`). A reader (`attr_reader :box`) is for
  the program that uses the card; the others stay inside.
- **Methods change it** (`title=`), as the setters of the components do.
- **Its objects are ordinary objects:** `card.box.remove` removes the card and everything in it;
  `card.box.on(:mouse_enter) { ... }` and `card.box.measure(:width)` work as on any object.
- The blocks inside `initialize` see the instance variables of the card: `self` in them is the card.

A part that keeps nothing needs no class: a method that makes its objects and returns the object is enough.

```ruby
# The small title over a part of a page.
def caption(text)
  Label(text: text.upcase, font_size: 11, bold: true, text_color: "#5A6270")
end
```

## State and a callback of its own

A component of yours keeps its state in Ruby and tells the program when the user changes it:

```ruby
require "ozdenui"
include OzdenUI

STAR_ON = "#E0A038"
STAR_OFF = "#C9CDD4"

# Five stars: value (0 to 5); the block runs when the user clicks a star.
class Rating
  attr_reader :value, :box

  def initialize(value, &on_change)
    @value = value
    @on_change = on_change
    @stars = []
    @box = HGroup(hug: true, gap: 4) do
      (1..5).each do |number|
        @stars << Label(text: "★", font_size: 28, cursor: "pointer", on_click: -> { click(number) })
      end
    end
    show
  end

  # For the code: it does not call the block, as the components do.
  def value=(value)
    @value = value
    show
  end

  private

  def click(number)
    self.value = number
    @on_change.call(self) if @on_change
  end

  def show
    @stars.each_with_index do |star, index|
      star.text_color = index < @value ? STAR_ON : STAR_OFF
    end
  end
end

run(title: "Rating", width: 320, height: 200) do
  VGroup(gap: 12) do
    said = Label(text: "Rate it", font_size: 16)
    Rating.new(3) { |rating| said.text = "#{rating.value} stars" }
  end
end
```

`-> { click(number) }` gives each star its own number: every turn of `each` has its own `number`. A private method
of the class (`click`) works in a lambda of the class.

## A component that holds objects

Take the objects as a block, as `VGroup` does, and return the box that holds them, so the program can add more later
with `add`:

```ruby
# A titled part of a form. The block makes its objects; section.add { ... } puts more in later.
def section(title, &content)
  body = nil
  VGroup(width: "100%", height: "auto", gap: 8, align: "left top") do
    Label(text: title.upcase, font_size: 11, bold: true, text_color: "#5A6270")
    body = VGroup(width: "100%", height: "auto", gap: 10, align: "left top", &content)
  end
  body
end

sound = section("Sound") do
  CheckBox(label_text: "Play a sound")
  Slider(value: 7, min_value: 0, max_value: 10)
end
sound.add { Toggle(value: true) }
```

## Sharing it: a file, then a gem

A component used by more than one file goes into a file of its own:

```
myapp/
  app.rb           require "ozdenui" ... require_relative "widgets/card" ... Card.new("Sales", "Updated today.")
  widgets/
    card.rb        class Card (include OzdenUI inside the class)
```

```ruby
# widgets/card.rb
require "ozdenui"

class Card
  include OzdenUI # the short names inside this class only: the file does not change the program that requires it

  def initialize(title, text)
    @box = VGroup(width: 220, height: "auto", padding: 16, gap: 8, color: "white", round: 12) do
      Label(text: title, font_size: 18, bold: true)
      Label(text: text, font_size: 15)
    end
  end
end
```

- In a file that others require, `include OzdenUI` goes inside the class (or a module of yours), not at the top.
- For many programs, make it a gem of your own with `spec.add_dependency "ozdenui"` in its gemspec, and
  `gem "your_widgets"` in the Gemfile of each program.
- A comment over each public method tells its user what it takes, as the methods of the gem do.

## What belongs to Ruby, what to the page

**"A click, then a change" belongs to Ruby.** Your block runs, and the page shows the change when the block ends.

**"Every frame, every mouse move" belongs to the page.** A motion made of many steps sent from Ruby would stutter.
Tell the page how to move, then give the end:

```ruby
ball.set_motion("left 0.3s, opacity 0.2s") # these values now change smoothly
ball.left = 300                            # the page moves it there in 0.3 s
```

A `Canvas` does so by itself: the page draws the free lines and moves the dragged shapes, Ruby hears only their ends.

### A callback that must answer at once

Some callbacks of the components must return an answer at once (a block that draws a row of a list, a check that
stops a click). The answer of Ruby comes a little later, so such a callback can not be a block of your program: format
the values in Ruby before they go to the page instead, and use the params the components give (chapter 10 lists
them).

## Next

[Chapter 10: Going further](10-going-further.md).
