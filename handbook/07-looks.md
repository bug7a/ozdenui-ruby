# 7. Looks

Three levels, from the widest to the smallest: the **theme** of the window (light or dark), the **style** of the window
(the usual look or the minimal one, in your color), and the **look of one component** (its package and its colors).
A look your code gives always wins over the one of the window.

## A dark window

```ruby
run(theme: "dark") { make_the_window } # "light" (the default), "dark", or "auto": what the system asks
```

- Every component takes its dark look; the dialogs and the toasts too.
- The page, a `Label`, a `Box` and an `Input` follow: a dark ground, a light text.
- A `tone:` of a `SmartButton` becomes its dark tone (`"cyan"` → `"cyanDark"`).
- `dark?` is true in a dark window (also after `"auto"`), and `theme` is `"light"` or `"dark"`: use them for the
  colors of your own objects.

```ruby
text_soft = dark? ? "#9AA3B5" : "#5A6270"
Label(text: "Updated today", text_color: text_soft)
```

`OZDENUI_THEME=dark ruby app.rb` opens any program dark, without a change of its code: a quick way to see both.

## Changing the theme while the program runs

Sixteen components change their theme while they are on the page: `LogView`, `ImageView`, `MarkdownView`, `JsonView`,
`ChatView`, `RangeSlider`, `StepBar`, `Canvas`, `MenuBar`, `ToolBar`, `StatusBar`, `Splitter`, `CodeEditor`,
`Accordion`, `GraphBox` and `TimeLine`:

```ruby
log_view.style_name = "dark" # or log_view.set_theme("dark")
```

The others take their look when they are made, so a whole window changes its theme by making its page again.
`set_theme("dark")` does it (`"light"`, `"dark"` or `"auto"`): the page is made again and **the block of `run` runs
again**. Every object is new, a text typed in a field is gone, and the timers set before are stopped. What your
program keeps in its own variables stays, so keep the data outside the block, fill the objects from it in the block,
and set the timers there:

```ruby
require "ozdenui"
include OzdenUI

# The colors of this program in each theme: the key is the theme of the window.
PAGE_COLORS = { "light" => "#F4F5F7", "dark" => "#141413" }.freeze
CARD_COLORS = { "light" => "#FFFFFF", "dark" => "#232322" }.freeze
TEXT_SOFT = { "light" => "#5A6270", "dark" => "#9AA3B5" }.freeze

@clicks = 0 # outside the block: it stays when the page is made again

def click
  @clicks += 1
  @count.text = @clicks.to_s
end

run(title: "Theme", width: 420, height: 320) do |page|
  other = dark? ? "light" : "dark"
  page.color = PAGE_COLORS[theme]
  VGroup(gap: 16) do
    VGroup(width: 300, height: "auto", padding: 20, gap: 10, color: CARD_COLORS[theme], round: 12) do
      Label(text: "Clicks", font_size: 13, text_color: TEXT_SOFT[theme])
      @count = Label(text: @clicks.to_s, font_size: 40, bold: true)
      SmartButton(label_text: "Click", tone: "cyan", on_click: method(:click))
    end
    SmartButton(label_text: "Make it #{other}", on_click: -> { set_theme(other) })
  end
end
```

`examples/gallery.rb` has a Dark / Light button in its ToolBar for it. `examples/editor.rb` changes only its bars and
views with `set_theme`, so the text in the editor stays.

## The minimal look, in your color

```ruby
run(style: "minimal") { make_the_window }                    # small and made of lines; theme: "dark" works too
run(style: "minimal", accent: "#2A78D6") { make_the_window } # the same, in your color
```

**`style: "minimal"`** gives about 40 components their minimal look: 28 px controls, a 13 px text, no fill and no
shadow of their own, so they take the ground of the window. A tool, an editor, a panel of settings look calm in it.

**`accent:`** gives the minimal look one color (it goes only with `style: "minimal"`). It goes where the look draws its
ink: an on toggle, a checked box, the fill of a slider and of a progress bar, the selected tab, row and step, the edge
of a field while typing, and the main button. The lines, the texts and the focus ring stay as they are.

```ruby
require "ozdenui"
include OzdenUI

ACCENT = "#2A78D6" # a color that reads on white: it is the text of a selected tab too

run(title: "Minimal", width: 420, height: 380, style: "minimal", accent: ACCENT) do |page|
  page.color = dark? ? "#1A1A19" : "#FFFFFF"
  VGroup(gap: 14, padding: 30, align: "left top") do
    Label(text: "Account", font_size: 18, bold: true)
    Tabs(tabs: ["General", "Privacy", "Advanced"], panels: false, width: 300)
    CheckBox(label_text: "Remember me", checked: true)
    HGroup(hug: true, gap: 10) do
      Toggle(value: true)
      Label(text: "Sounds", font_size: 13)
    end
    ProgressBar(title_text: "Uploading", value: 62, width: 260)
    HGroup(hug: true, gap: 8) do
      SmartButton(label_text: "Cancel")
      SmartButton(label_text: "Save", tone: "accent")
      SmartButton(label_text: "Delete", style_name: "minimalDanger")
    end
  end
end
```

- **`tone: "accent"`** is the main action of any window: the accent color here, the ink of the minimal look without an
  accent, `"cyan"` in the usual look.
- **`style_name: "minimalDanger"`**: a delete in the minimal look (in a dark window its dark twin).
- **In a dark window** the color is made lighter until it reads on the dark ground. `accent_dark: "#7FB6DE"` chooses it.
- A component without a minimal look keeps its usual one. `examples/minimal_theme.rb` shows all of them.

## The look of one component

### A package: style_name

Most components have a few looks, called packages. `ozdenui doc` of the component names them
(`ozdenui doc CheckBox`):

```ruby
CheckBox(label_text: "Remember me", style_name: "modern")
ItemList(items: photos, layout: "grid", style_name: "gallery")
SmartButton(label_text: "Next", style_name: "pill", tone: "blue")
```

A package you name stays in every window; in a dark window a light package with a dark twin takes the twin
(`"gallery"` → `"galleryDark"`, `"minimalDanger"` → `"minimalDangerDark"`). A component is made with its package: a
later `obj.style_name = ...` does not change it (the terminal says so), except on the sixteen above.

### Your colors: style

`style:` changes the parts of a component. Its keys are the names of the kit; in a style they may be snake_case too:

```ruby
SmartButton(label_text: "Go", style: {
  box: { color: "#2A78D6" },
  hover: { color: "#2367BA" },
  label: { text_color: "white" }
})
Toggle(value: true, style_name: "classic", background_style: { selected_color: "#6AC966" })
```

- `style:` goes over the package: what you give wins, the rest stays.
- The names of the parts (`box`, `hover`, `label`...) are the ones of the component in basic.js; its file in
  [lib/ozdenui/web/comp](https://github.com/bug7a/ozdenui-ruby/tree/main/lib/ozdenui/web/comp) and the
  [catalog](https://bug7a.github.io/js-components/) show them.
- A param that ends in `_style` (`background_style:`, `button_style:`) is a style too.
- `unframed: true` takes the frame of a component (no border, no rounded corners on its box): a `LogView` or a
  `CodeEditor` that fills the room between two bars.

### Plain objects

A `Box`, a `Label`, a group take their colors from their values (`color:`, `text_color:`, `border_color:`): chapter 2.
Keep the colors of a program at the top of its file, as constants (or as a Hash by `theme`), so a change is one line:

```ruby
PAGE_COLOR = "#F4F5F7"
CARD_COLOR = "#FFFFFF"
TEXT_SOFT = "#5A6270"
```

## Next

[Chapter 8: Data and pictures](08-data-and-pictures.md): charts, big tables, logs, Markdown, JSON, code and pictures.
