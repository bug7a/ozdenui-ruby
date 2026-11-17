# The components of OzdenUI for Ruby

Made by `tools/gen.rb` from the kit (basic.js v26.11.10); do not edit. Every component is a method of `OzdenUI`
(`SelectBox(options: [...])`); its params are the params of the kit in snake_case, each with the default of the kit
and the comment of the kit (written for JavaScript: a `1 / 0` flag also takes `true / false`, `function (self) {}`
is a block or a lambda that gets the object). Every component also takes `left:`, `top:`, `width:`, `height:`,
`style_name:`, `style:`, `visible:`, `opacity:`, `fill:` and `unframed:`. In a terminal: `ozdenui doc SelectBox`.

## Accordion

`Accordion(...)` makes the Accordion of the kit (comp/accordion.js).

`style_name:` `"dark"`, `"light"`, `"minimal"`, `"minimalDark"`.

A dark window gives it its dark look.

Read without a question to the page: `obj.open_keys`.

Objects go into it with `accordion.section(key) { ... }`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `add_section`, `close`, `close_all`, `end_section`, `focus`, `get_content`, `get_open_keys`, `get_section`, `is_open`, `open`, `open_all`, `remove_section`, `set_animated`, `set_enabled`, `set_section_description`, `set_section_enabled`, `set_section_text`, `set_sections`, `set_theme`, `start_section`, `toggle`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` | Your name for this object: read it in a callback (self.key) |
| `left:` | `0` |  |
| `top:` | `0` |  |
| `width:` | `"100%"` |  |
| `height:` | `"auto"` | "auto": it grows with its open sections. A number or "100%": the sections scroll inside it. |
| `sections:` | `[]` | [SECTION] (See A SECTION above) |
| `multiple:` | `1` | 1: more than one section can be open. 0: a section that opens closes the others. |
| `arrow_side:` | `"right"` | "right", "left": where the arrow of a row is |
| `enabled:` | `1` |  |
| `animated:` | `0` | 1: the arrow turns, the objects of a section fade in. setAnimated() |
| `use_scroll_bar:` | `1` | basic/scroll-bar.js (when it is loaded), with a height that is not "auto". 0: the scrollbar of the browser. |
| `on_toggle:` | `a block` | section.key, section.opened. (Not at create time, not with silent: 1) |
| `style_name:` | `"light"` | "light", "dark", "minimal", "minimalDark" or a name added to Accordion.styles |
| `style:` | `{...}` | Light style package (default) |

## ActionButton

`ActionButton(...)` makes the ActionButton of the kit (comp/action-button.js).

`style_name:` `"classic"`, `"ozden"`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `close_menu`, `open_menu`, `press`, `set_animated`, `set_button_color`, `set_items`, `toggle_menu`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` | Your name for this object: read it in a callback (self.key) |
| `left:` | `0` |  |
| `top:` | `0` |  |
| `width:` | `"100%"` |  |
| `height:` | `"100%"` |  |
| `items:` | `[]` | [{ key, text }] or ["text"] |
| `icon_file:` | `"data:image/svg+xml;utf8," + encodeURIComponent('<svg xml...` | a plus (a page can give its own picture) |
| `open_icon_file:` | `""` | "": iconFile. The icon while the menu is open. |
| `icon_size:` | `30` |  |
| `icon_rotate:` | `0` | deg |
| `open_icon_rotate:` | `45` | deg: the + turns into × |
| `right_space:` | `40` | The button from the right side of the container |
| `bottom_space:` | `40` | The button from the bottom of the container |
| `menu_width:` | `280` |  |
| `menu_gap:` | `20` | Between the menu and the button |
| `animated:` | `0` | 1: small hover / press / open motions (context/basic-js-animated-rules.md). (box.setAnimated(0/1)) |
| `on_action:` | `a block` | An action was chosen (no items: key is "", one item: its key) |
| `on_menu_toggle:` | `a block` | The menu opened / closed: self.menuOpened |
| `style_name:` | `"classic"` | "classic", "ozden" or a name added to ActionButton.styles |
| `style:` | `{...}` | Classic style package (default) |

## ActionTabBar

`ActionTabBar(...)` makes the ActionTabBar of the kit (comp/action-tab-bar.js).

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `get_index`, `set_value`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` | Your name for this object: read it in a callback (self.key) |
| `width:` | `600` |  |
| `height:` | `150` |  |
| `items:` | `[]` | [{ key, text, iconFile }] (Only at create time) |
| `value:` | `null` | The key of the selected tab. null: the first tab |
| `aria_label:` | `"Tabs"` | The name of the tab list for a screen reader |
| `action_aria_label:` | `"Add"` | The name of the "+" button for a screen reader |
| `on_change:` | `a block` | self.value, self.previousValue, self.getIndex() |
| `on_action:` | `a block` | The "+" button |
| `style:` | `{...}` |  |

## AppBar

`AppBar(...)` makes the AppBar of the kit (comp/app-bar.js).

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `set_back_visible`, `set_line`, `set_menu_visible`, `set_title_align`, `set_title_text`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` | Your name for this object: read it in a callback (self.key) |
| `left:` | `0` | The bar stands at the top of its container (a page) |
| `top:` | `0` |  |
| `width:` | `"100%"` |  |
| `height:` | `105` |  |
| `color:` | `"white"` | The background of the bar |
| `title_text:` | `""` |  |
| `title_align:` | `"center"` | "center" or "left" (set later with setTitleAlign) |
| `line:` | `0` | 1: a soft line at the bottom (setLine) |
| `show_back:` | `0` | 1: the back button at the left (setBackVisible) |
| `show_menu:` | `1` | 1: the menu button at the right (setMenuVisible) |
| `back_icon_file:` | `""` | "": a back arrow drawn in SVG (Ex: "assets/icons/back.svg") |
| `menu_icon_file:` | `""` | "": three dots drawn in SVG |
| `icon_color:` | `Black(0.8)` | The color of the drawn icons (a file keeps its own colors) |
| `back_aria_label:` | `"Back"` | What a screen reader says for the buttons |
| `menu_aria_label:` | `"Menu"` |  |
| `on_back:` | `a block` |  |
| `on_menu:` | `a block` |  |
| `style:` | `{...}` |  |

## Badge

`Badge(...)` makes the Badge of the kit (comp/badge.js).

`style_name:` `"dark"`, `"light"`, `"ozden"`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `get_state`, `get_value`, `hide`, `is_visible`, `set_state`, `set_value`, `show`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` |  |
| `value:` | `0` |  |
| `max_value:` | `99` |  |
| `show_plus:` | `1` | 1: over maxValue -> "99+" |
| `show_zero:` | `0` | 1: 0 is shown as "0" (0: hidden) |
| `dot_for_one:` | `1` | 1: a dot for 1, 0: the number "1" |
| `dot_size:` | `10` |  |
| `badge_style:` | `{...}` | The dot and the number (Ex: a white ring: border: 3, borderColor: "white") |
| `dot_style:` | `{}` | Only the dot, over badgeStyle: top, right... |
| `number_style:` | `{}` | Only the number, over badgeStyle: fontSize, bold, padding, round, top, right... |
| `style_name:` | `"ozden"` | "ozden", "light", "dark" or a name added to Badge.styles |
| `style:` | `{}` | WHY: the look is in the params above; the packages are packages of params (see Badge.styles). |

## BottomBar

`BottomBar(...)` makes the BottomBar of the kit (comp/bottom-bar.js).

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `select_by_index`, `select_none`, `set_badge`, `set_label_mode`.

| Param | Default | The kit says |
|---|---|---|
| `selected_index:` | `0` |  |
| `left:` | `0` |  |
| `width:` | `"100%"` |  |
| `height:` | `100` |  |
| `items:` | `[]` | [{ iconFile: "home.png", selectedIconFile: "homes.png", text: "Home", color: "#5ABB9F" }] (selectedIconFile, color: optional) |
| `on_item_click:` | `a block` |  |
| `hover_effect:` | `true` | For desktop usage |
| `label_mode:` | `"inline"` | "inline": the name next to the selected icon, "float": over it for a moment, "none": no names |
| `allow_html:` | `0` | 1: the names of the items are HTML (only for your own texts) |
| `float_label_time:` | `600` | ms: from the moment the name shows over the selected item to its fade out ("float") |
| `badge:` | `{...}` | The params of the Badge of every item (comp/badge.js) |
| `style:` | `{...}` |  |

## Breadcrumbs

`Breadcrumbs(...)` makes the Breadcrumbs of the kit (comp/breadcrumbs.js).

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `add_item`, `back`, `click_item`, `collapse`, `expand`, `get_current_item`, `get_items`, `go_to`, `set_enabled`, `set_items`, `set_max_items`, `set_separator`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` |  |
| `width:` | `"auto"` | "auto": Wraps the items. A number or "100%": Fixed width. |
| `height:` | `"auto"` |  |
| `items:` | `[]` | [{ text, key, url, iconFile, data }] or ["Home", "Products"] |
| `separator:` | `"chevron"` | "chevron" or a text. (Ex: "/", "›", "•") |
| `max_items:` | `0` | 0: No collapse. Ex: 4 -> Home / … / Laptops / Lenovo |
| `items_before_collapse:` | `1` |  |
| `items_after_collapse:` | `2` |  |
| `max_item_width:` | `180` | Long texts are cut with "...". 0: No limit. |
| `wrap:` | `0` | 1: Items move to the next line when there is no space. |
| `trim_on_click:` | `0` | 1: Clicking an item removes the items after it. (In-app navigation) |
| `current_clickable:` | `0` | 1: The last item can be clicked too. |
| `enabled:` | `1` |  |
| `aria_label:` | `"Breadcrumb"` |  |
| `on_click:` | `a block` | return false: Do not go to item.url |
| `on_change:` | `a block` | When items change with code or trimOnClick. |
| `style:` | `{...}` |  |

## Canvas

`Canvas(...)` makes the Canvas of the kit (comp/canvas.js).

`style_name:` `"dark"`, `"light"`.

A dark window gives it its dark look.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `add_circle`, `add_ellipse`, `add_image`, `add_line`, `add_polygon`, `add_polyline`, `add_rect`, `add_shape`, `add_text`, `bring_to_front`, `clear`, `get_image`, `get_shape`, `get_shapes`, `move_shape`, `remove_shape`, `set_drawing`, `set_pen`, `set_shapes`, `set_theme`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` | Your name for this object: read it in a callback (self.key) |
| `left:` | `0` |  |
| `top:` | `0` |  |
| `width:` | `400` |  |
| `height:` | `300` |  |
| `shapes:` | `[]` | [SHAPE]: the first shapes. Later: addShape(), setShapes() |
| `drawing:` | `0` | 1: the mouse draws free lines with the pen |
| `pen_color:` | `""` | "": the pen color of the style |
| `pen_width:` | `3` |  |
| `aria_label:` | `"A drawing"` |  |
| `on_click:` | `a block` | shape: the shape at that place (the top one), or null |
| `on_shape_move:` | `a block` | A draggable shape was put down at its new place. |
| `on_draw_end:` | `a block` | A free line is finished: it is in the list (shape.key). |
| `style_name:` | `"light"` | "light", "dark" or a name added to Canvas.styles |
| `style:` | `{...}` | Light style package (default) |

## ChatView

`ChatView(...)` makes the ChatView of the kit (comp/chat-view.js).

`style_name:` `"dark"`, `"light"`, `"minimal"`, `"minimalDark"`.

A dark window gives it its dark look.

Read without a question to the page: `obj.busy`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `add_message`, `append_text`, `clear`, `focus`, `get_input_text`, `get_message_text`, `get_messages`, `remove_message`, `scroll_to_end`, `scroll_to_top`, `send`, `set_busy`, `set_empty_text`, `set_input_text`, `set_message_text`, `set_messages`, `set_placeholder`, `set_show_input`, `set_theme`, `stop`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` | Your name for this object: read it in a callback (self.key) |
| `width:` | `480` |  |
| `height:` | `560` | A number or "100%". (Not "auto": the messages scroll above the field.) |
| `messages:` | `[]` | [{ key, role: "user" \| "assistant" \| "system", text }]: the messages at the start (a text: an answer) |
| `placeholder:` | `"Write a message"` |  |
| `empty_text:` | `""` | Shown while there is no message (Ex: "Ask something") |
| `send_text:` | `"Send"` | The name of the button: a screen reader says it, the mouse shows it |
| `stop_text:` | `"Stop"` |  |
| `show_input:` | `1` | 0: only the messages (the page has a field of its own) |
| `send_on_enter:` | `1` | 1: Enter sends, Shift+Enter makes a new line. 0: Enter makes a new line, Ctrl / Cmd + Enter sends. |
| `max_input_lines:` | `6` | The field grows up to this many lines, then it scrolls |
| `busy:` | `0` | 1: an answer is coming: the dots, and Stop in the place of Send. setBusy() |
| `auto_scroll:` | `1` | 1: the view follows a new message and an answer that comes, until the reader scrolls up |
| `remote_pictures:` | `0` | 1: a picture of an answer with an http address is drawn (See the note of MarkdownView) |
| `aria_label:` | `"Conversation"` |  |
| `copy_text:` | `"Copy"` | The button of a code in an answer |
| `copied_text:` | `"Copied"` |  |
| `on_send:` | `a block` | The user sent a text: its message (key) is on the view, the field is empty again |
| `on_stop:` | `a block` | Stop was pressed (busy is 0 already) |
| `on_link_click:` | `a block` | function (self, address) {}: a link of an answer comes to you. null: it opens in a new tab. |
| `style_name:` | `"light"` | "light", "dark", "minimal", "minimalDark" or a name added to ChatView.styles |
| `style:` | `{...}` | Light style package (default) |

## CheckBox

`CheckBox(...)` makes the CheckBox of the kit (comp/check-box.js).

`style_name:` `"classic"`, `"dark"`, `"light"`, `"minimal"`, `"minimalDark"`, `"modern"`.

A dark window gives it its dark look.

Read without a question to the page: `obj.checked`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `set_animated`, `set_checked`, `set_enabled`, `set_label_text`, `toggle`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` |  |
| `width:` | `"auto"` |  |
| `height:` | `"auto"` |  |
| `checked:` | `0` | 0, 1 |
| `enabled:` | `1` | 0, 1 |
| `label_text:` | `""` |  |
| `allow_html:` | `0` | 1: labelText is HTML (only for your own texts) |
| `label_position:` | `"right"` | "right", "left" |
| `wrap_label:` | `0` | 1: a long label wraps (the check box needs a width); 0: one line |
| `animated:` | `0` | 1: the square grows a little under the mouse, the tick draws in (box.setAnimated(0/1)) |
| `on_change:` | `a block` | self.checked |
| `style_name:` | `"light"` | "light" ("classic": its old name), "modern", "dark", "minimal", "minimalDark" or a name added to CheckBox.styles |
| `style:` | `{...}` | Light style package (default) |

## CodeEditor

`CodeEditor(...)` makes the CodeEditor of the kit (comp/code-editor.js).

`style_name:` `"dark"`, `"light"`.

A dark window gives it its dark look.

Read without a question to the page: `obj.cursor_column`, `obj.cursor_line`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `focus_editor`, `get_selected_text`, `get_value`, `go_to_line`, `insert_text`, `set_language`, `set_read_only`, `set_show_line_numbers`, `set_tab_size`, `set_theme`, `set_value`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` | Your name for this object: read it in a callback (self.key) |
| `left:` | `0` |  |
| `top:` | `0` |  |
| `width:` | `"100%"` |  |
| `height:` | `320` |  |
| `value:` | `""` | The text |
| `language:` | `"text"` | A name of CodeEditor.languages |
| `tab_size:` | `4` | The spaces of one level |
| `read_only:` | `0` |  |
| `show_line_numbers:` | `1` |  |
| `placeholder:` | `""` |  |
| `change_delay:` | `0` | ms: onChange waits for the typing to rest |
| `aria_label:` | `"Code"` |  |
| `on_change:` | `a block` | self.value changed. (Not at create time, not with silent: 1) |
| `on_cursor_change:` | `a block` | self.cursorLine, self.cursorColumn (from 1) |
| `style_name:` | `"light"` | "light", "dark" or a name added to CodeEditor.styles |
| `style:` | `{...}` | Light style package (default) |

## ColorPicker

`ColorPicker(...)` makes the ColorPicker of the kit (comp/color-picker.js).

`style_name:` `"classic"`, `"dark"`, `"light"`, `"minimal"`, `"minimalDark"`.

A dark window gives it its dark look.

Read without a question to the page: `obj.value`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `close`, `get_color`, `is_open`, `open`, `set_color`, `set_colors`, `set_enabled`, `toggle`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` |  |
| `width:` | `170` | Field width (not used if inline: 1) |
| `height:` | `44` | Field height (not used if inline: 1) |
| `selected_color:` | `""` | "#3871E0" or "" (nothing is selected). WHY: not "color", Box.color is the background. |
| `colors:` | `[...]` | The palette. Any CSS color text is accepted. ("red", "rgb(0, 0, 0)"...) |
| `columns:` | `5` |  |
| `show_text:` | `1` | 1: The color text is written in the field. |
| `placeholder:` | `"Select color"` |  |
| `inline:` | `0` | 1: The palette is always visible, no field. |
| `enabled:` | `1` |  |
| `close_on_select:` | `1` |  |
| `on_change:` | `a block` | self.value ("#3871E0" or "") |
| `on_open:` | `a block` |  |
| `on_close:` | `a block` |  |
| `style_name:` | `"light"` | "light" ("classic": its old name), "dark", "minimal", "minimalDark" or a name added to ColorPicker.styles |
| `style:` | `{...}` | Light style package (default) |

## ContextMenu

`ContextMenu(...)` makes the ContextMenu of the kit (comp/context-menu.js).

`style_name:` `"classic"`, `"dark"`, `"light"`, `"minimal"`, `"minimalDark"`.

A dark window gives it its dark look.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `activate_first`, `attach_to`, `click_item`, `close`, `close_submenu`, `detach`, `get_item_by_key`, `get_items`, `has_active`, `is_open`, `open_at`, `open_below`, `open_beside`, `open_with_event`, `remove`, `set_enabled`, `set_item_checked`, `set_item_enabled`, `set_items`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` |  |
| `items:` | `[]` | [{ text, key, iconFile, enabled, data, onClick }, "-", "Text"] |
| `target:` | `null` | An object (or a list of objects). The menu opens on it with the trigger. One object: the menu is removed with it. |
| `trigger:` | `"contextmenu"` | "contextmenu": Right click, "click": Left click |
| `min_width:` | `180` |  |
| `max_width:` | `320` | Long texts are cut with "...". 0: No limit. |
| `enabled:` | `1` |  |
| `aria_label:` | `"Menu"` |  |
| `on_click:` | `a block` | self.source: The object that opened the menu. |
| `on_open:` | `a block` |  |
| `on_close:` | `a block` |  |
| `on_side_key:` | `a block` | ArrowRight (1) / ArrowLeft (-1) that no submenu takes (MenuBar: the next menu) |
| `parent_menu:` | `null` | (inside) The menu of a submenu: it handles the keys and the clicks outside for it. |
| `style_name:` | `"light"` | "light" ("classic": its old name), "dark", "minimal", "minimalDark" or a name added to ContextMenu.styles |
| `style:` | `{...}` | Light style package (default) |

## CurrencyField

`CurrencyField(...)` makes the CurrencyField of the kit (comp/currency-field.js).

A dark window gives it its dark look.

Read without a question to the page: `obj.text`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `blur_func`, `check_if_input_is_required_and_empty`, `check_input_value`, `focus_func`, `get_value`, `get_value_as_number`, `input_func`, `is_valid`, `set_background_color`, `set_description_text`, `set_focus_background_color`, `set_focus_line_color`, `set_line_color`, `set_max_length`, `set_placeholder`, `set_required`, `set_required_icon`, `set_required_text`, `set_title_text`, `set_unit_text`, `set_value`, `set_warning_color`, `set_warning_icon`, `set_warning_text`, `show_warning_if_not_valid`.

| Param | Default | The kit says |
|---|---|---|
| `required:` | `0 (the kit alone: 0)` |  |
| `title_text:` | `"" (the kit alone: "CURRENCY")` |  |
| `placeholder:` | `"" (the kit alone: "(auto)")` |  |
| `max_length:` | `35` |  |
| `allow_negative:` | `1` |  |
| `allow_decimal:` | `1` |  |
| `decimal_separator:` | `"."` | or "," |
| `max_decimal_digits:` | `2` |  |
| `group_separator:` | `","` | for thousands grouping |
| `unit_text:` | `"TL"` |  |
| `key:` | `"0"` |  |
| `style_name:` | `"light" (the kit alone: "light")` | "light", "dark", "modern" ("classic": its old name), "modernDark", "ozden", "ozdenDark", "minimal", "minimalDark" or a name added to TextField.styles |
| `type:` | `"text"` |  |
| `width:` | `350` |  |
| `height:` | `"auto"` |  |
| `left_padding:` | `20` |  |
| `right_padding:` | `60` |  |
| `title_font_size:` | `16` |  |
| `input_font_size:` | `20` |  |
| `input_height:` | `40` | px: the row of the text |
| `field_padding:` | `14` | px: over and under the title and the text (titlePosition "inside") |
| `description_font_size:` | `14` |  |
| `title_position:` | `"inside"` | "inside": the title in the field, over the text. "above": the title over the field (the field is only the row of the text). (Only at create time) |
| `title_gap:` | `4` | px between the title and the field (titlePosition "above") |
| `value:` | `""` |  |
| `show_description:` | `0` |  |
| `description_text:` | `""` |  |
| `allow_html:` | `0` | 1: titleText, descriptionText and unitText are HTML (only for your own texts) |
| `background_color:` | `"#F6F6F6"` |  |
| `focus_background_color:` | `"#F3F4E0"` |  |
| `hover_background_color:` | `""` | the field under the mouse (not while it is selected). "": no change |
| `line_color:` | `"#373836"` |  |
| `focus_line_color:` | `"#65A293"` |  |
| `back_border_color:` | `Black(0)` |  |
| `focus_back_border_color:` | `Black(0)` |  |
| `hover_back_border_color:` | `""` | the edge under the mouse (not while it is selected). "": no change |
| `back_border_top_round:` | `2` |  |
| `back_border_bottom_round:` | `0` |  |
| `title_text_color:` | `"#555555"` |  |
| `title_bold:` | `0` | 1: the title in bold (opensans-bold) |
| `title_letter_spacing:` | `""` | "": normal. Ex: "0.06em" |
| `input_text_color:` | `"#373836"` |  |
| `input_color_scheme:` | `""` | "": the page's. "dark": the autofill colors of the browser stay dark (on a dark field) |
| `placeholder_color:` | `""` | "": the color of the browser |
| `description_text_color:` | `"#999999"` |  |
| `warning_ball_border_color:` | `"#373836"` |  |
| `required_text:` | `"Required"` |  |
| `required_color:` | `"white"` |  |
| `warning_text:` | `"Invalid value format"` |  |
| `warning_color:` | `"#E5885E"` |  |
| `animated_warning_ball:` | `1` |  |
| `warning_ball_type:` | `"color"` | "color": colored ball, "icon": icon image |
| `warning_ball_size:` | `16` | px: the colored ball (warningBallType "color") |
| `warning_ball_border:` | `2` | px: the edge of the colored ball (warningBallBorderColor) |
| `warning_border_color:` | `""` | the edge of the field while it shows a warning (not while typing). "": no change |
| `warning_icon_size:` | `20` |  |
| `required_icon_file:` | `""` | image path or data URI. "": built-in icon |
| `warning_icon_file:` | `""` | image path or data URI. "": built-in icon |
| `required_icon_color:` | `"#373836"` | built-in required icon color (built-in warning icon uses warningColor) |
| `tooltip_style:` | `{...}` |  |
| `select_style:` | `{...}` |  |
| `show_left_box:` | `0` |  |
| `show_right_box:` | `0` |  |
| `show_unit:` | `0` |  |
| `create_input:` | `1` |  |
| `unit_style:` | `{...}` |  |
| `on_focus:` | `a block` |  |
| `on_blur:` | `a block` |  |
| `on_change:` | `a block` | the user changed the text (not at create time, not by setValue()) |
| `on_enter:` | | the Enter key: a block or a lambda that gets the field |

## DataTable

`DataTable(...)` makes the DataTable of the kit (comp/data-table.js).

When to use it: the better looking table (style packages, sorting, search, selection, your own cells), but the data it can hold has a limit: every row is a basic.js object (about 9 DOM nodes), all made at once.

`style_name:` `"classic"`, `"dark"`, `"light"`, `"minimal"`, `"minimalDark"`, `"plain"`.

A dark window gives it its dark look.

Read without a question to the page: `obj.selected_row`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `add_row`, `clear_rows`, `clear_selection`, `clear_sort`, `get_biggest_id`, `get_row`, `get_rows`, `get_selected_data`, `get_selected_id`, `remove_row`, `search`, `select`, `set_rows`, `set_title_text`, `sort_by`.

| Param | Default | The kit says |
|---|---|---|
| `width:` | `600` |  |
| `height:` | `400` |  |
| `columns:` | `[]` | See "A COLUMN" above. |
| `rows:` | `[]` | [[1, "John", "Paris"], ...] or [{ id: 1, name: "John", city: "Paris" }, ...] |
| `id_index:` | `0` | The id of a row array: row[idIndex] |
| `id_key:` | `"id"` | The id of a row object: row[idKey] |
| `sort_key:` | `""` | "": the order of the data |
| `sort_direction:` | `"asc"` | "asc" or "desc" |
| `can_select:` | `1` | 0: a click runs onRowClick, no row is selected |
| `row_height:` | `"auto"` | "auto": as high as its text (more lines); a number: one line, cut with "..." |
| `title_text:` | `""` | "": no title in the header |
| `show_search:` | `0` | 1: a search box in the header (comp/search-input.js SearchInput must be loaded) |
| `search_params:` | `{}` | More params of the SearchInput. Ex: { placeholder: "Ara" } |
| `empty_text:` | `"There are no records."` |  |
| `no_result_text:` | `"No records found."` |  |
| `sort_icon_file:` | `"data:image/svg+xml;utf8," + encodeURIComponent('<?xml ve...` |  |
| `use_scroll_bar:` | `1` | basic/scroll-bar.js ScrollBar |
| `on_row_click:` | `a block` | A click on a row, or Enter on the selected row |
| `on_select:` | `a block` | The selected row changed (row: null when nothing is selected). Not with silent: 1 |
| `on_sort:` | `a block` | self.sortKey, self.sortDirection |
| `style_name:` | `"light"` | "light" ("classic": its old name), "plain", "dark", "minimal", "minimalDark" or a name added to DataTable.styles |
| `style:` | `{...}` | Light style package (default) |

## DatePicker

`DatePicker(...)` makes the DatePicker of the kit (comp/date-picker.js).

`style_name:` `"classic"`, `"dark"`, `"light"`, `"minimal"`, `"minimalDark"`.

A dark window gives it its dark look.

Read without a question to the page: `obj.value`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `close`, `get_date`, `is_open`, `open`, `set_date`, `set_enabled`, `set_max_date`, `set_min_date`, `toggle`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` |  |
| `width:` | `220` | Field width (not used if inline: 1) |
| `height:` | `44` | Field height (not used if inline: 1) |
| `date:` | `null` | Date, "YYYY-MM-DD" or null |
| `min_date:` | `null` | Date, "YYYY-MM-DD" or null |
| `max_date:` | `null` | Date, "YYYY-MM-DD" or null |
| `format:` | `"DD.MM.YYYY"` | Tokens: YYYY, MMMM, MMM, MM, M, DD, D, dddd, ddd |
| `language:` | `"en"` | "en", "tr" |
| `first_day_of_week:` | `1` | 0: Sunday, 1: Monday |
| `placeholder:` | `""` | Empty: uses the language text |
| `inline:` | `0` | 1: Calendar is always visible, no field. |
| `scale:` | `null` | Multiplies every size. null: basic.uiScale (1, or 1 / page.zoom on a fitted page). (Only at create time) |
| `enabled:` | `1` |  |
| `close_on_select:` | `1` |  |
| `show_today_button:` | `1` |  |
| `show_clear_button:` | `1` |  |
| `on_change:` | `a block` | self.date (Date or null), self.value ("YYYY-MM-DD"), self.dateText |
| `on_open:` | `a block` |  |
| `on_close:` | `a block` |  |
| `style_name:` | `"light"` | "light" ("classic": its old name), "dark", "minimal", "minimalDark" or a name added to DatePicker.styles |
| `style:` | `{...}` | Light style package (default) |

## Dialog

`Dialog(...)` makes the Dialog of the kit (comp/dialog.js).

`style_name:` `"minimal"`, `"minimalDark"`, `"ozden"`, `"ozdenDark"`.

A dark window gives it its dark look.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `close`, `get_button`, `get_values`, `is_busy`, `is_open`, `open`, `remove`, `set_busy`, `set_message_text`, `set_status`, `set_title_text`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` |  |
| `width:` | `460` | the card (a number); a small screen: as wide as the screen |
| `title_text:` | `""` |  |
| `message_text:` | `""` |  |
| `allow_html:` | `0` | 1: the title and the message are HTML (only for your own texts) |
| `fields:` | `[]` | [{ key, titleText, placeholder, value, required, validate }] |
| `content:` | `null` | function (dialog) {}: objects in the body |
| `buttons:` | `[]` | [{ text, type, key, iconFile, align, ask, ariaLabel, onClick }] |
| `close_on_cover:` | `1` | a click on the cover closes it |
| `close_on_escape:` | `1` |  |
| `auto_open:` | `1` |  |
| `remove_on_close:` | `1` | 0: close() only hides it; open() shows it again |
| `aria_label:` | `""` | when there is no title |
| `variant:` | `""` | "": the buttons in a row at the bottom; "centered": the texts in the middle, the buttons one under the other |
| `top_icon_file:` | `""` | "centered": the icon at the top (a file, or an "<svg" text drawn with currentColor or LIGHT / STRONG) |
| `top_icon_tone:` | `""` | "centered": "cyan", "orange", "yellow", "green", "blue": the circle and the icon in its tones; "": gray |
| `scale:` | `null` | every size multiplied (Ex: 1.5). null: basic.uiScale (1 / page.zoom on a page fitted with page.fit()) |
| `on_open:` | `a block` |  |
| `on_close:` | `a block` | reason: "button", "escape", "cover", "api" |
| `style_name:` | `"ozden"` | "ozden", "ozdenDark", "minimal", "minimalDark" or a name added to Dialog.styles |
| `style:` | `{...}` | The ozden style package (default): the first dialog of smart-button-3-ozden.htm |

## EmailField

`EmailField(...)` makes the EmailField of the kit (comp/email-field.js).

A dark window gives it its dark look.

Read without a question to the page: `obj.text`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `blur_func`, `check_if_input_is_required_and_empty`, `check_input_value`, `focus_func`, `get_value`, `input_func`, `is_valid`, `set_background_color`, `set_description_text`, `set_focus_background_color`, `set_focus_line_color`, `set_line_color`, `set_max_length`, `set_placeholder`, `set_required`, `set_required_icon`, `set_required_text`, `set_title_text`, `set_unit_text`, `set_value`, `set_warning_color`, `set_warning_icon`, `set_warning_text`, `show_warning_if_not_valid`.

| Param | Default | The kit says |
|---|---|---|
| `required:` | `0 (the kit alone: 1)` |  |
| `type:` | `"email"` |  |
| `title_text:` | `"" (the kit alone: "EMAIL")` |  |
| `placeholder:` | `"example@site.com"` |  |
| `warning_text:` | `"Invalid email format"` |  |
| `warning_color:` | `"#E5885E"` |  |
| `max_length:` | `254 (the kit alone: 40)` |  |
| `key:` | `"0"` |  |
| `style_name:` | `"light" (the kit alone: "light")` | "light", "dark", "modern" ("classic": its old name), "modernDark", "ozden", "ozdenDark", "minimal", "minimalDark" or a name added to TextField.styles |
| `width:` | `350` |  |
| `height:` | `"auto"` |  |
| `left_padding:` | `20` |  |
| `right_padding:` | `60` |  |
| `title_font_size:` | `16` |  |
| `input_font_size:` | `20` |  |
| `input_height:` | `40` | px: the row of the text |
| `field_padding:` | `14` | px: over and under the title and the text (titlePosition "inside") |
| `description_font_size:` | `14` |  |
| `title_position:` | `"inside"` | "inside": the title in the field, over the text. "above": the title over the field (the field is only the row of the text). (Only at create time) |
| `title_gap:` | `4` | px between the title and the field (titlePosition "above") |
| `value:` | `""` |  |
| `show_description:` | `0` |  |
| `description_text:` | `""` |  |
| `allow_html:` | `0` | 1: titleText, descriptionText and unitText are HTML (only for your own texts) |
| `background_color:` | `"#F6F6F6"` |  |
| `focus_background_color:` | `"#F3F4E0"` |  |
| `hover_background_color:` | `""` | the field under the mouse (not while it is selected). "": no change |
| `line_color:` | `"#373836"` |  |
| `focus_line_color:` | `"#65A293"` |  |
| `back_border_color:` | `Black(0)` |  |
| `focus_back_border_color:` | `Black(0)` |  |
| `hover_back_border_color:` | `""` | the edge under the mouse (not while it is selected). "": no change |
| `back_border_top_round:` | `2` |  |
| `back_border_bottom_round:` | `0` |  |
| `title_text_color:` | `"#555555"` |  |
| `title_bold:` | `0` | 1: the title in bold (opensans-bold) |
| `title_letter_spacing:` | `""` | "": normal. Ex: "0.06em" |
| `input_text_color:` | `"#373836"` |  |
| `input_color_scheme:` | `""` | "": the page's. "dark": the autofill colors of the browser stay dark (on a dark field) |
| `placeholder_color:` | `""` | "": the color of the browser |
| `description_text_color:` | `"#999999"` |  |
| `warning_ball_border_color:` | `"#373836"` |  |
| `required_text:` | `"Required"` |  |
| `required_color:` | `"white"` |  |
| `animated_warning_ball:` | `1` |  |
| `warning_ball_type:` | `"color"` | "color": colored ball, "icon": icon image |
| `warning_ball_size:` | `16` | px: the colored ball (warningBallType "color") |
| `warning_ball_border:` | `2` | px: the edge of the colored ball (warningBallBorderColor) |
| `warning_border_color:` | `""` | the edge of the field while it shows a warning (not while typing). "": no change |
| `warning_icon_size:` | `20` |  |
| `required_icon_file:` | `""` | image path or data URI. "": built-in icon |
| `warning_icon_file:` | `""` | image path or data URI. "": built-in icon |
| `required_icon_color:` | `"#373836"` | built-in required icon color (built-in warning icon uses warningColor) |
| `tooltip_style:` | `{...}` |  |
| `select_style:` | `{...}` |  |
| `show_left_box:` | `0` |  |
| `show_right_box:` | `0` |  |
| `show_unit:` | `0` |  |
| `create_input:` | `1` |  |
| `unit_text:` | `""` |  |
| `unit_style:` | `{...}` |  |
| `on_focus:` | `a block` |  |
| `on_blur:` | `a block` |  |
| `on_change:` | `a block` | the user changed the text (not at create time, not by setValue()) |
| `on_enter:` | | the Enter key: a block or a lambda that gets the field |

## FilePicker

`FilePicker(...)` makes the FilePicker of the kit (comp/file-picker.js).

`style_name:` `"classic"`, `"dark"`, `"light"`, `"minimal"`, `"minimalDark"`.

A dark window gives it its dark look.

Read without a question to the page: `obj.files`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `add_files`, `clear`, `get_file_details`, `get_files`, `open`, `remove`, `remove_file`, `set_animated`, `set_description_text`, `set_enabled`, `set_icon`, `set_icon_svg`, `set_title_text`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` |  |
| `width:` | `360` |  |
| `height:` | `"auto"` |  |
| `zone_height:` | `170` |  |
| `multiple:` | `0` | 1: Select more than one file. New files are added to the list. |
| `directory:` | `0` | 1: Select a folder (all files in it). Click only, not drag. |
| `accept:` | `""` | Ex: "image/*", ".pdf,.docx", "image/png,image/jpeg" |
| `max_size:` | `0` | Bytes. 0: No limit. Ex: 5 * 1024 * 1024 (5 MB) |
| `max_files:` | `0` | 0: No limit (only for multiple: 1) |
| `enabled:` | `1` |  |
| `show_icon:` | `1` | 0: Hide the upload icon. (A zone too low for it hides it by itself.) |
| `icon_svg:` | `""` | An "<svg" text of your own, drawn with currentColor. Empty: the icon of the style (box.setIconSvg()) |
| `icon_file:` | `""` | A picture of your own (a path or a data: address) in the place of the icon, with its own colors (box.setIcon()) |
| `animated:` | `0` | 1: the icon lifts under the mouse, and more while a file is dragged over. (box.setAnimated(0/1)) |
| `show_list:` | `1` |  |
| `show_preview:` | `1` | Image thumbnails in the list. |
| `prevent_page_drop:` | `1` | 1: A file dropped outside the zone does not open in the browser tab. |
| `title_text:` | `"Drag and drop a file here"` |  |
| `description_text:` | `"or click to select"` |  |
| `hint_text:` | `""` | Empty: created from accept and maxSize |
| `drop_text:` | `"Drop to add"` |  |
| `allow_html:` | `0` | 1: titleText, descriptionText and dropText are HTML (only for your own texts) |
| `on_change:` | `a block` | self.files: [{ file, name, displayName, path, size, sizeText, type, extension, lastModified }] |
| `on_error:` | `a block` | errors: [{ type: "accept" \| "maxSize" \| "maxFiles", name, message }] |
| `on_open_dialog:` | `a block` | function (self): the dialog of a program, in the place of the dialog of the page (see above) |
| `style_name:` | `"light"` | "light" ("classic": its old name), "dark", "minimal", "minimalDark" or a name added to FilePicker.styles |
| `style:` | `{...}` |  |

## Filters

`Filters(...)` makes the Filters of the kit (comp/filters.js).

`style_name:` `"light"`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `clear_all`, `close_panel`, `get_selected`, `get_selected_count`, `open_panel`, `search`, `set_animated`, `set_button_text`, `set_panel_opened`, `set_section_opened`, `set_sections`, `set_selected`, `toggle_panel`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` | Your name for this object: read it in a callback (self.key) |
| `width:` | `380` | The width of the panel (the button stands at its right) |
| `height:` | `"auto"` | The button and the panel |
| `panel_height:` | `620` |  |
| `panel_opened:` | `1` | 0: only the button; a click opens the panel |
| `panel_mode:` | `"inline"` |  |
| `button_text:` | `"Filters"` |  |
| `search_placeholder:` | `"Search"` |  |
| `selected_text:` | `"Selected"` |  |
| `clear_text:` | `"Clear all"` |  |
| `no_result_text:` | `"No results"` |  |
| `sections:` | `[]` |  |
| `animated:` | `0` | 1: the panel and an opened section come in, the arrows turn (box.setAnimated(0/1)) |
| `search_input_params:` | `{ styleName: "ozden", width: "100%", height: 50, fontSize...` |  |
| `check_box_params:` | `{ styleName: "light", style: {} }` |  |
| `on_change:` | `a block` | The selection changed: self.getSelected(). (Not at create time, not with silent: 1) |
| `on_panel_toggle:` | `a block` | The panel opened / closed: self.panelOpened |
| `style_name:` | `"light"` | "light" or a name added to Filters.styles |
| `style:` | `{...}` | Light style package (default) |

## Form

`Form(...)` makes the Form of the kit (comp/form.js).

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `add_double_input`, `add_input`, `add_title`, `remove`, `set_passive_button_hint_text`, `show_message`.

| Param | Default | The kit says |
|---|---|---|
| `min_width:` | `500` |  |
| `max_width:` | `700` |  |
| `button_color:` | `"#65A293"` |  |
| `button_text:` | `"SEND"` |  |
| `allow_html:` | `0` | 1: buttonText and the texts of showMessage() are HTML (only for your own texts) |
| `show_detail_warning:` | `1` |  |
| `missing_entry_text:` | `"{{count}} missing entry"` |  |
| `missing_entries_text:` | `"{{count}} missing entries"` |  |
| `warning_text:` | `"<b>{{name}}</b> can't be empty"` | HTML of the page; {{name}}: the title of the field, as it is written |
| `error_text:` | `"<b>{{name}}</b> is not valid"` | HTML of the page, as warningText |
| `minimal_button:` | `0` |  |
| `double_input_always_horizontal:` | `0` |  |
| `show_passive_button_hint:` | `1` | 1: A hint is shown when the mouse is over the passive send button. |
| `passive_button_hint_text:` | `"Please fill in the missing fields to send the form."` |  |
| `hint_round:` | `4` |  |
| `on_change:` | `a block` | the user changed an input of the form |
| `on_send_click:` | `a block` |  |

## FullScreenSelect

`FullScreenSelect(...)` makes the FullScreenSelect of the kit (comp/full-screen-select.js).

`style_name:` `"classic"`, `"dark"`, `"light"`.

A dark window gives it its dark look.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `close`, `get_selected_index`, `get_selected_item`, `open`, `remove`, `set_items`, `set_selected_index`, `set_selected_key`.

| Param | Default | The kit says |
|---|---|---|
| `width:` | `200` |  |
| `height:` | `50` |  |
| `items:` | `[]` | [{ key, text }] or ["Text"] (the text is its key) |
| `selected_key:` | `null` | null: the first item |
| `placeholder:` | `"Search"` |  |
| `empty_text:` | `"No results"` |  |
| `auto_width:` | `0` | 1: the field is as wide as the text of the selected item |
| `show_search:` | `1` | 0: no search box (a short list) |
| `arrow_icon_file:` | `"data:image/svg+xml;utf8," + encodeURIComponent('<?xml ve...` |  |
| `close_icon_file:` | `"data:image/svg+xml;utf8," + encodeURIComponent('<?xml ve...` |  |
| `search_icon_file:` | `""` | The icons of the search box. "": the files of SearchInput (or of its style package) |
| `clear_icon_file:` | `""` |  |
| `aria_label:` | `""` | "": the text of the selected item is read |
| `on_change:` | `a block` | self.selectedKey changed (not at create time, not with silent: 1) |
| `on_open:` | `a block` |  |
| `on_close:` | `a block` |  |
| `style_name:` | `"light"` | "light" ("classic": its old name), "dark" or a name added to FullScreenSelect.styles |
| `style:` | `{...}` | Light style package (default) |

## Gauge

`Gauge(...)` makes the Gauge of the kit (comp/gauge.js).

`style_name:` `"classic"`, `"dark"`, `"light"`, `"modern"`.

A dark window gives it its dark look.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `set_bar_color`, `set_marker_value`, `set_range`, `set_sub_text`, `set_title_text`, `set_value`, `set_value_suffix`, `set_value_text`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` |  |
| `width:` | `180` |  |
| `height:` | `180` |  |
| `value:` | `0` |  |
| `min_value:` | `0` |  |
| `max_value:` | `100` |  |
| `start_angle:` | `0` | 0: the top (12 o'clock). They grow clockwise. |
| `sweep_angle:` | `360` | 360: a full ring. 180: a half arc. |
| `radius:` | `74` |  |
| `marker_value:` | `null` | null: no marker line. (A target, a reserve, a limit...) |
| `value_text:` | `""` | "": the value itself, with decimals and valueSuffix. |
| `value_suffix:` | `"%"` |  |
| `decimals:` | `0` |  |
| `sub_text:` | `""` | The small line under the value. |
| `title_text:` | `""` | Under the whole gauge. |
| `duration:` | `600` | Length of the animation, in milliseconds. |
| `aria_label:` | `"Gauge"` |  |
| `on_change:` | `a block` |  |
| `style_name:` | `"light"` | "light" ("classic": its old name), "dark", "modern" or a name added to Gauge.styles |
| `style:` | `{...}` | Light style package (default) |

## GraphBox

`GraphBox(...)` makes the GraphBox of the kit (comp/graph-box.js).

A dark window gives it its dark look.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `add_dataset`, `add_point`, `add_value`, `download`, `get_canvas`, `get_image`, `get_table_data`, `remove_dataset`, `set_animated`, `set_axis_texts`, `set_center_text`, `set_curve`, `set_data`, `set_dataset_visible`, `set_datasets`, `set_format_value`, `set_format_x`, `set_horizontal`, `set_labels`, `set_legend`, `set_max_slices`, `set_show_values`, `set_slice_visible`, `set_soft_limits`, `set_stacked`, `set_style`, `set_subtitle_text`, `set_table_view`, `set_target_lines`, `set_theme`, `set_title_text`, `set_type`, `set_value_limits`, `set_value_step`, `set_values`, `set_xLimits`, `when_ready`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` |  |
| `width:` | `500` |  |
| `height:` | `300` |  |
| `type:` | `"line"` | "line", "area", "bar", "pie", "doughnut", "radar", "scatter", "bubble" |
| `theme:` | `"light"` | "light", "dark", "auto" (follows the system setting), "minimal", "minimalDark" |
| `title_text:` | `""` |  |
| `subtitle_text:` | `""` |  |
| `labels:` | `null` | ["Jan", "Feb", "Mar"] |
| `values:` | `null` | [12, 19, 7] Shortcut: creates one dataset. |
| `datasets:` | `null` | [{ label: "2026", data: [12, 19, 7], ...see A DATASET above }] |
| `data:` | `null` | { labels, datasets } (Used instead of labels, values and datasets.) |
| `legend:` | `"auto"` |  |
| `stacked:` | `0` | 1: Bars one on the other, lines and areas over each other. The tooltip adds totalText. |
| `horizontal:` | `0` | 1: The values grow to the right. (Long names read better so.) |
| `total_text:` | `"Total"` | The last row of the tooltip of a stacked chart. "": No total |
| `target_lines:` | `null` | [{ value: 90000, label: "Target", color: "" }] No label: its value. label: "": No text. |
| `max_slices:` | `8` | A pie, a doughnut: at most this many slices; the smallest ones become "Other". 0: No limit. |
| `other_text:` | `"Other"` | The name of that slice |
| `center_text:` | `""` | The big text in the middle of a doughnut. Ex: "1,284" |
| `center_sub_text:` | `""` | The small text under it. Ex: "Users" |
| `begin_at_zero:` | `1` | 1: The value axis holds 0. (A bar chart always holds it: the length of a bar is its value.) |
| `min_value:` | `null` | null: From the values. |
| `max_value:` | `null` | null: From the values. Ex: 100 |
| `soft_min_value:` | `null` | The axis goes at least this low. Unlike minValue, a smaller value still widens it. |
| `soft_max_value:` | `null` | The axis goes at least this high. Ex: 260 |
| `value_step:` | `0` | 0: The axis finds its own step. Ex: 1: a line and a text for every whole number. |
| `min_x:` | `null` | scatter, bubble: the limits of the x axis. null: From the values. (They do not hold 0 by themselves.) |
| `max_x:` | `null` |  |
| `size_text:` | `"Size"` | bubble: the name of its size in the tooltip |
| `x_axis_text:` | `""` | A small title under the chart. Ex: "Height (cm)" |
| `y_axis_text:` | `""` | A small title at the left of the chart, turned. Ex: "Weight (kg)" |
| `show_values:` | `0` | 1: The values on the chart, only where they fit. |
| `table_view:` | `0` | 1: A table of the values in place of the chart. setTableView() |
| `table_head_text:` | `""` | The title of the first column of the table |
| `max_labels:` | `0` | At most this many labels on the index axis. 0: As many as fit. |
| `curve:` | `"linear"` | "linear", "smooth" (never goes over a value) |
| `show_points:` | `"auto"` | "auto": When there is room for them. 1, 0 |
| `format_value:` | `null` | a format text, made by the page at once: "{:,.2f} TL", "{:.0f} kg", "{:.1%}" (not a block) |
| `format_x:` | `null` | a format text, made by the page at once: "{:,.2f} TL", "{:.0f} kg", "{:.1%}" (not a block) |
| `locale:` | `""` | "": The language of the browser. Ex: "tr-TR" |
| `max_count:` | `0` | addValue(): 0: No limit. Ex: 20 (the first value is removed, for live data) |
| `empty_text:` | `"No data"` | In the middle of a chart with no values. "": Nothing |
| `animated:` | `0` | 1: Small motions when the data changes. setAnimated() |
| `on_click:` | `a block` | item: { datasetIndex, index, label, value, datasetLabel, dataset } |
| `style:` | `{...}` |  |

## GridGroup

`GridGroup(...)` makes the GridGroup of the kit (comp/grid-group.js).

Objects go into it with its block: `GridGroup(...) { ... }`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `place`, `set_align`, `set_columns`, `set_gap`, `set_rows`.

| Param | Default | The kit says |
|---|---|---|
| `width:` | `"100%"` |  |
| `height:` | `"auto"` | "auto": as high as its rows. |
| `columns:` | `2` | A number, a list ([120, "1fr", "auto"]) or a text (CSS) |
| `rows:` | `null` | null: as many as the objects need. A number, a list or a text, as columns. |
| `gap:` | `0` | px, or [column gap, row gap] |
| `align:` | `""` | "": the objects fill their cells. "left center", "center"...: where each one stands in its cell. |
| `clip_content:` | `0` |  |
| `padding:` | | a value of its box |
| `color:` | | a value of its box |
| `round:` | | a value of its box |

## HoldToConfirmButton

`HoldToConfirmButton(...)` makes the HoldToConfirmButton of the kit (comp/hold-to-confirm-button.js).

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `cancel_hold`, `start_hold`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` |  |
| `width:` | `"auto"` |  |
| `height:` | `50` |  |
| `label_text:` | `"Hold to Delete"` | Hold to Vanish, Hold to Delete |
| `completed_text:` | `"DELETED"` | Poof! And it's gone.  // DELETED // REMOVED |
| `allow_html:` | `0` | 1: labelText and completedText are HTML (only for your own texts) |
| `icon_file:` | `"data:image/svg+xml;utf8," + encodeURIComponent('<svg xml...` | a bin (a page can give its own picture) |
| `holding_icon_file:` | `"data:image/svg+xml;utf8," + encodeURIComponent('<svg xml...` | the bin in red while it is held |
| `on_confirm:` | `a block` |  |
| `on_reset:` | `a block` |  |
| `hold_duration:` | `3000` | ms |
| `reset_delay:` | `3000` | ms: the completed text stays this long |
| `style:` | `{...}` |  |

## ImageView

`ImageView(...)` makes the ImageView of the kit (comp/image-view.js).

`style_name:` `"dark"`, `"light"`.

A dark window gives it its dark look.

Read without a question to the page: `obj.natural_height`, `obj.natural_width`, `obj.zoom_level`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `clear_image`, `set_image`, `set_show_toolbar`, `set_theme`, `set_zoom_level`, `zoom_in`, `zoom_out`, `zoom_to_actual_size`, `zoom_to_fit`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` | Your name for this object: read it in a callback (self.key) |
| `width:` | `"100%"` |  |
| `height:` | `360` |  |
| `image_file:` | `""` | A file, an address or a data: address. "": empty |
| `alt_text:` | `""` | What the picture shows, for a screen reader |
| `min_zoom:` | `0.1` | 1 is 100%. (A big picture can always go down to its fitted size.) |
| `max_zoom:` | `8` |  |
| `zoom_step:` | `1.25` | A button or a key: multiplies the zoom |
| `enlarge_to_fit:` | `0` | 1: a picture smaller than the box also grows to fit (a vector drawing). 0: it stays at 100% |
| `wheel_zoom:` | `1` | 0: the wheel is left to the page around it (a viewer in a long page) |
| `pixelated_zoom:` | `3` | From this zoom the pixels stay sharp. 0: never |
| `show_toolbar:` | `1` |  |
| `empty_text:` | `"No image"` |  |
| `error_text:` | `"This image can not be opened."` |  |
| `aria_label:` | `"Image viewer"` |  |
| `button_texts:` | `{ zoomOut: "Zoom out", actualSize: "Actual size", zoomIn:...` | For a screen reader |
| `on_load:` | `a block` | self.naturalWidth, self.naturalHeight |
| `on_error:` | `a block` |  |
| `on_zoom_change:` | `a block` | self.zoomLevel |
| `style_name:` | `"light"` | "light", "dark" or a name added to ImageView.styles |
| `style:` | `{...}` | Light style package (default) |

## ItemList

`ItemList(...)` makes the ItemList of the kit (comp/item-list.js).

`style_name:` `"classic"`, `"dark"`, `"gallery"`, `"galleryDark"`, `"light"`, `"minimal"`, `"minimalDark"`, `"ozden"`, `"ozdenDark"`.

A dark window gives it its dark look.

Read without a question to the page: `obj.selected`, `obj.selected_keys`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `add_item`, `clear_selection`, `focus_item`, `for_each`, `get_item`, `get_items`, `get_row`, `get_selected`, `get_selected_keys`, `remove_item`, `scroll_to_item`, `search`, `select`, `set_active_key`, `set_animated`, `set_enabled`, `set_items`, `set_layout`, `set_selected`, `set_selection`, `unselect`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` | Your name for this object: read it in a callback (self.key) |
| `width:` | `600` |  |
| `height:` | `400` | "auto": grows with the rows (no scrolling) |
| `items:` | `[]` | Strings or { key, text, description, iconFile, searchText, enabled }. A title row: { type: "section", text: "VIEWS" } |
| `layout:` | `"vertical"` | "vertical", "horizontal", "grid" |
| `selection:` | `"single"` | "single", "multiple", "none" |
| `selected_keys:` | `[]` | The keys selected at create time |
| `scroll_to_selected:` | `1` | 1: the list scrolls to the selected item at create time and after setSelected() / select() |
| `animated:` | `0` | 1: addItem / removeItem move the rows (a new row fades in, a removed one fades out). setAnimated(0/1) |
| `show_search:` | `0` | 1: a search box over the list (comp/search-input.js SearchInput must be loaded) |
| `search_params:` | `{}` | More params of the SearchInput. Ex: { placeholder: "Ara", searchIconFile: "comp/search-input/search.svg" } |
| `empty_text:` | `"No items"` |  |
| `no_result_text:` | `"No results"` |  |
| `enabled:` | `1` |  |
| `use_scroll_bar:` | `1` | basic/scroll-bar.js. 0: the scrollbar of the browser. |
| `aria_label:` | `"List"` |  |
| `on_item_click:` | `a block` |  |
| `on_change:` | `a block` | Not at create time, not by setItems(), not with silent: 1 |
| `style_name:` | `"ozden"` | "ozden", "ozdenDark", "light", "dark", "gallery", "galleryDark", "minimal", "minimalDark" or a name added to ItemList.styles |
| `style:` | `{...}` | The ozden style package (default) |

## JsonEditor

`JsonEditor(...)` makes the JsonEditor of the kit (comp/json-editor.js).

`style_name:` `"dark"`, `"light"`, `"minimal"`, `"minimalDark"`.

A dark window gives it its dark look.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `focus`, `get_json_text`, `get_value`, `get_view`, `has_changes`, `redo`, `set_json_text`, `set_title_text`, `set_value`, `set_view`, `undo`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` | Your name for this object: read it in a callback (self.key) |
| `left:` | `0` |  |
| `top:` | `0` |  |
| `width:` | `"100%"` |  |
| `height:` | `400` |  |
| `value:` | `[]` | A list or an object (or its JSON text). The editor reads it into its rows: the value of the page does not change. |
| `title_text:` | `""` | The name of the value at the start of the path. "": texts.list or texts.object |
| `note_text:` | `""` | A soft line under the title (Ex: what a row holds) |
| `columns:` | `[]` | [A COLUMN] (See A COLUMN above): the columns of an empty list; the kind and the choices of a column |
| `show_title_bar:` | `"auto"` | "auto": when there is a title, a note or a table opened in a cell. 1: always |
| `show_hint:` | `1` | The keys of the cells at the bottom |
| `picture_base:` | `""` | The address the relative pictures of the cells are read from. "": the page |
| `aria_label:` | `""` | "": the titleText |
| `texts:` | `{...}` |  |
| `on_change:` | `a block` | The value changed in the table: a list or an object. (Not at create time, not with setValue()) |
| `on_pick_color:` | `a block` | function (self, cell) { }: your own color picker for a color cell (See A CELL above). null: the one of the browser |
| `on_pick_picture:` | `a block` | function (self, cell) { }: a list of pictures for a picture cell (a click on its picture). null: the address is written |
| `color_of:` | `null` | function (value, self) { return a color }: the color a swatch paints, when only the page can read it (Ex: a token of another document). null: the value |
| `options_of:` | `null` | function (key, value, self) { return [choices] or null }: the choices of a text of this name (a column, a row of an object), besides columns |
| `style_name:` | `"light"` | "light", "dark", "minimal", "minimalDark" or a name added to JsonEditor.styles |
| `style:` | `{...}` | Light style package (default) |

## JsonView

`JsonView(...)` makes the JsonView of the kit (comp/json-view.js).

`style_name:` `"dark"`, `"light"`.

A dark window gives it its dark look.

Read without a question to the page: `obj.selected_path`, `obj.selected_path_text`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `collapse_all`, `expand_all`, `get_selected_path`, `get_selected_path_text`, `get_selected_value`, `get_value`, `remove`, `select_path`, `set_json_text`, `set_theme`, `set_value`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` | Your name for this object: read it in a callback (self.key) |
| `left:` | `0` |  |
| `top:` | `0` |  |
| `width:` | `"100%"` |  |
| `height:` | `"100%"` | A number or "100%": its rows scroll inside it. "auto": it grows with its rows. |
| `value:` | `null` | A value of JSON. null: emptyText |
| `expand_level:` | `1` | How many levels are open at the start. 0: only the first rows, closed. |
| `page_size:` | `100` | A list or an object with more items than this comes in pages. |
| `empty_text:` | `"No value"` |  |
| `copy_value_text:` | `"Copy value"` |  |
| `copy_path_text:` | `"Copy path"` |  |
| `use_scroll_bar:` | `1` | basic/scroll-bar.js (when it is loaded), with a height that is not "auto". 0: the scrollbar of the browser |
| `aria_label:` | `"JSON"` |  |
| `on_select:` | `a block` | A row was chosen (See AN ENTRY above). (Not at create time, not with selectPath()) |
| `on_copy:` | `a block` | A value or a path is on the clipboard. |
| `style_name:` | `"light"` | "light", "dark" or a name added to JsonView.styles |
| `style:` | `{...}` | Light style package (default) |

## LabelEditor

`LabelEditor(...)` makes the LabelEditor of the kit (comp/label-editor.js).

`style_name:` `"classic"`, `"dark"`, `"light"`.

A dark window gives it its dark look.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `add_label`, `duplicate_label`, `get_labels`, `get_saved_styles`, `get_selected_index`, `move_label`, `remove_label`, `remove_style`, `save_style`, `select_label`, `set_labels`, `set_saved_styles`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` |  |
| `width:` | `860` |  |
| `height:` | `540` |  |
| `labels:` | `[]` | Start labels: [{ text, fontSize, ... , styleName }] |
| `saved_styles:` | `[]` | Start styles: [{ name, props: { fontSize, textColor, ... } }] (storageKey wins when it has data) |
| `storage_key:` | `""` | "": the saved styles are not kept. Ex: "label-editor-styles" |
| `new_label:` | `{...}` | Properties of a new label |
| `color_palette:` | `[...]` | The colors of the color pickers in the panel |
| `panel_width:` | `340` |  |
| `use_scroll_bar:` | `1` |  |
| `texts:` | `{...}` |  |
| `on_change:` | `a block` | The labels changed. self.getLabels() |
| `on_select:` | `a block` | index: -1 when nothing is selected |
| `on_styles_change:` | `a block` | The saved styles changed. self.getSavedStyles() |
| `style_name:` | `"light"` | "light" ("classic": its old name), "dark" or a name added to LabelEditor.styles |
| `style:` | `{...}` | Light style package (default) |

## LeftMenu

`LeftMenu(...)` makes the LeftMenu of the kit (comp/left-menu.js).

`style_name:` `"dark"`, `"light"`.

A dark window gives it its dark look.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `add_item_to_bottom`, `add_item_to_top`, `clear_selection`, `collapse`, `expand`, `get_selected_item`, `is_tap_mode`, `remove`, `remove_item`, `set_open_on_click`, `set_selected_item`, `toggle`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` |  |
| `expanded_width:` | `250` | Expanded width on hover |
| `item_height:` | `40` | The height of a button item |
| `top_bar_height:` | `40` | Height of top bar to account for |
| `background_color:` | `"#141414"` | Menu background color |
| `hover_color:` | `"rgba(255, 255, 255, 0.05)"` | Hover color for buttons |
| `selected_color:` | `"#583432"` | Selected button color |
| `title_color:` | `"#8E342F"` |  |
| `text_color:` | `"rgba(255, 255, 255, 0.6)"` | Text color |
| `selected_text_color:` | `"rgba(255, 255, 255, 0.95)"` |  |
| `allow_html:` | `0` | 1: the texts of the items are HTML (only for your own texts) |
| `invert_icon_color:` | `1` |  |
| `line_color:` | `""` | A line at the right side of the menu ("": none) |
| `expanded_shadow:` | `""` | The shadow of the open menu over the page ("": none). Ex: "6px 0 18px rgba(0, 0, 0, 0.08)" |
| `scroll_bar_color:` | `"#FFFFFF"` | The bar of the scroll of the items (a dark one on a light menu) |
| `open_on_click:` | `"auto"` | "auto": Tap on a touch device, hover with a mouse. 1: Always tap, 0: Always hover. |
| `items:` | `[]` | [{ key, type: "button", text, iconFile }, { key, type: "header", text }] |
| `on_item_click:` | `a block` | Callback when item is clicked |
| `on_menu_toggle:` | `a block` | Callback when menu expands/collapses |
| `style_name:` | `"dark"` | "dark", "light" or a name added to LeftMenu.styles |
| `style:` | `{}` | WHY: the look is in the flat params above; the packages are packages of params (LeftMenu.styles) |

## LineProgressBar

`LineProgressBar(...)` makes the LineProgressBar of the kit (comp/line-progress-bar.js).

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `set_animated`, `set_primary_color`, `set_progress`, `set_secondary_color`.

| Param | Default | The kit says |
|---|---|---|
| `width:` | `300` |  |
| `height:` | `50` |  |
| `progress:` | `0` | 0 to 100 |
| `primary_color:` | `"indianred"` | the full lines |
| `secondary_color:` | `"lightgray"` | the empty lines |
| `line_width:` | `1` | px |
| `line_gap:` | `3` | px between two lines |
| `line_round:` | `3` | px, or "full": the top and the bottom of a line are half circles |
| `head_grow:` | `1` | 1: the line at the progress and its two neighbors are wider and longer; 0: every line the same |
| `show_value_label:` | `false` | the value in a small label for a moment when it changes |
| `value_bubble:` | `0` | 1: the value all the time in a bubble with an arrow over the last full line (comp/tooltip.js) |
| `value_bubble_look:` | `{}` | the keys of Tooltip.BUBBLE_LOOK (its color: primaryColor) |
| `animated:` | `0` | 1: the bubble of the value slides to a new value (box.setAnimated(0/1)) |
| `background_color:` | `"transparent"` |  |

## LoadingScreen

`LoadingScreen(...)` makes the LoadingScreen of the kit (comp/loading-screen.js).

`style_name:` `"dark"`, `"light"`, `"minimal"`, `"minimalDark"`, `"ozden"`, `"ozdenDark"`.

A dark window gives it its dark look.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `close`, `open`, `set_message_text`, `set_progress`, `set_title_text`.

| Param | Default | The kit says |
|---|---|---|
| `left:` | `0` |  |
| `top:` | `0` |  |
| `width:` | `"100%"` |  |
| `height:` | `"100%"` |  |
| `style_name:` | `"light"` | "light", "dark", "ozden", "ozdenDark", "minimal", "minimalDark" or a name added to LoadingScreen.styles |
| `icon_file:` | `""` | An image file (Ex: the app icon) |
| `icon_svg:` | `""` | Or an SVG text (works with no file, also offline) |
| `title_text:` | `""` |  |
| `allow_html:` | `0` | 1: titleText and messageText are HTML, only for your own texts (Ex: "Please wait.<br>It takes a few seconds.") |
| `message_text:` | `""` |  |
| `spinner_type:` | `"clock"` | "clock" (the default wait, the user), "ring", "dots", "none" |
| `progress:` | `-1` | 0 - 1: a progress bar is shown. -1: no progress bar |
| `opened:` | `1` | 0: created closed, open() shows it |
| `min_duration:` | `600` | ms. A close() before this time waits. (No short flash on a fast load) |
| `fade_duration:` | `0.35` | seconds |
| `remove_on_close:` | `0` | 1: The object is removed after it is closed (a splash screen that is used once) |
| `on_close:` | `a block` | After the fade out |
| `style:` | `{...}` |  |

## LogView

`LogView(...)` makes the LogView of the kit (comp/log-view.js).

`style_name:` `"dark"`, `"light"`.

A dark window gives it its dark look.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `add_line`, `clear_lines`, `debug`, `error`, `get_text`, `info`, `scroll_to_end`, `set_auto_scroll`, `set_levels`, `set_max_lines`, `set_show_level`, `set_show_time`, `set_theme`, `set_wrap_lines`, `success`, `warn`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` | Your name for this object: read it in a callback (self.key) |
| `width:` | `"100%"` |  |
| `height:` | `260` |  |
| `lines:` | `[]` | The first lines: "Text" or { text, level, time } |
| `max_lines:` | `1000` | The oldest lines go. 0: no limit |
| `auto_scroll:` | `1` | 1: follows the last line |
| `show_time:` | `1` |  |
| `show_level:` | `1` |  |
| `wrap_lines:` | `1` |  |
| `empty_text:` | `"No output yet."` |  |
| `new_lines_text:` | `"{count} new"` | The button that goes back to the end |
| `level_texts:` | `{ info: "INFO", success: "OK", warn: "WARN", error: "ERRO...` |  |
| `aria_label:` | `"Output"` |  |
| `style_name:` | `"light"` | "light", "dark" or a name added to LogView.styles |
| `style:` | `{...}` | Light style package (default) |

## LoginPage

`LoginPage(...)` makes the LoginPage of the kit (comp/login-page.js).

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `remove`, `set_active_tab`, `show_alert`.

| Param | Default | The kit says |
|---|---|---|
| `panel_width:` | `420` |  |
| `primary_color:` | `"#2C5A38"` |  |
| `"tab_backgroundColorBottom" =>` | `"#242424"` | "#242424", "whitesmoke" |
| `"tab_backgroundColorTop" =>` | `"#242424"` |  |
| `"tab_borderColor" =>` | `White(0.1)` | White(0.1), Black(0), |
| `"tab_border" =>` | `1` | 1, 0 |
| `"tab_textColor" =>` | `White(0.75)` | White(0.75), "#373836", |
| `"tab_selectedColor" =>` | `"#000000"` | "#000000", "white", |
| `tab_width:` | `"auto"` | the LOGIN / SIGN UP bar: "auto" (as wide as its tabs) or a width the tabs share (Ex: the panelWidth) |
| `tab_style:` | `{}` | more keys of the style of its Tabs (pillBar, tab, pillActive, pillIndicator...), over the tab_ look |
| `input_style_name:` | `""` | "": the fields take the input_ colors below. A TextField package ("ozden", "ozdenDark"...): the fields take its look. |
| `button_style_name:` | `""` | "": LOGIN / SIGN UP are flat buttons in primaryColor. A SmartButton template ("ozden3"...): SmartButtons |
| `button_tone:` | `""` | The tone of those SmartButtons (Ex: "blue"; "": the gray of the template) |
| `"input_backgroundColor" =>` | `"#141414"` |  |
| `"input_lineColor" =>` | `"transparent"` |  |
| `"input_selectedBackgroundColor" =>` | `"#202020"` |  |
| `"input_textColor" =>` | `White(0.85)` | Black(0.85), White(0.85) |
| `"input_border" =>` | `1` | 1, 0 |
| `"input_borderColor" =>` | `White(0.1)` | White(0.1), Black(0.1) |
| `or_text_color:` | `White(0.75)` | White(0.75), Black(0.75) |
| `or_line_color:` | `White(0.1)` | White(0.1), Black(0.1) |
| `panel_name:` | `"MY PANEL v25.08.11"` |  |
| `allow_html:` | `0` | 1: panelName, the alerts and the texts of the buttons are HTML (only for your own texts) |
| `on_login_click:` | `a block` |  |
| `on_signup_click:` | `a block` |  |
| `show_password_icon_invert:` | `1` |  |
| `show_password_icon_file:` | `""` | "": the eye of PasswordField |
| `hide_password_icon_file:` | `""` | "": the crossed eye of PasswordField |
| `waiting_cover_color:` | `"rgba(0, 0, 0, 0.6)"` | The cover of box.waiting (LoadingScreen) |
| `waiting_clock:` | `"ozden"` | The clock of box.waiting: "ozden" (a white face) or "ozdenDark" (LoadingScreen.clocks) |
| `signup_password_params:` | `{...}` |  |
| `style:` | `{...}` |  |

## MarkdownView

`MarkdownView(...)` makes the MarkdownView of the kit (comp/markdown-view.js).

`style_name:` `"dark"`, `"light"`.

A dark window gives it its dark look.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `append_text`, `clear`, `get_headings`, `get_markdown_text`, `scroll_to_end`, `scroll_to_heading`, `scroll_to_top`, `set_auto_scroll`, `set_empty_text`, `set_markdown_text`, `set_theme`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` | Your name for this object: read it in a callback (self.key) |
| `left:` | `0` |  |
| `top:` | `0` |  |
| `width:` | `"100%"` |  |
| `height:` | `"100%"` | A number or "100%": the text scrolls inside it. "auto": it grows with its text. |
| `markdown_text:` | `""` | The text. setMarkdownText(), appendText() |
| `empty_text:` | `""` | Shown when there is no text |
| `auto_scroll:` | `1` | 1: with appendText() the view follows the end, until the reader scrolls up |
| `remote_pictures:` | `0` | 1: a picture with an http address is drawn, not a link (See the note at the top) |
| `use_scroll_bar:` | `1` | basic/scroll-bar.js (when it is loaded), with a height that is not "auto". 0: the scrollbar of the browser |
| `aria_label:` | `"Document"` |  |
| `copy_text:` | `"Copy"` | The button of a code |
| `copied_text:` | `"Copied"` |  |
| `on_link_click:` | `a block` | function (self, address) {}: a link comes to you, not to the browser. null: it opens in a new tab. |
| `style_name:` | `"light"` | "light", "dark" or a name added to MarkdownView.styles |
| `style:` | `{...}` | Light style package (default) |

## MenuBar

`MenuBar(...)` makes the MenuBar of the kit (comp/menu-bar.js).

`style_name:` `"dark"`, `"light"`, `"minimal"`, `"minimalDark"`.

A dark window gives it its dark look.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `close_menu`, `remove`, `set_enabled`, `set_item_checked`, `set_item_enabled`, `set_menus`, `set_theme`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` | Your name for this object: read it in a callback (self.key) |
| `left:` | `0` |  |
| `top:` | `0` |  |
| `width:` | `"100%"` |  |
| `height:` | `34` |  |
| `menus:` | `[]` | [{ text, key, enabled, items, onClick }] |
| `enabled:` | `1` |  |
| `aria_label:` | `"Menu bar"` |  |
| `on_click:` | `a block` | An item (with a click, the keyboard or its shortcut) |
| `on_menu_open:` | `a block` |  |
| `on_menu_close:` | `a block` |  |
| `style_name:` | `"light"` | "light", "dark", "minimal", "minimalDark" or a name added to MenuBar.styles |
| `style:` | `{...}` | Light style package (default) |

## MiniGraphBox

`MiniGraphBox(...)` makes the MiniGraphBox of the kit (comp/mini-graph-box.js).

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `add_value`, `clear`, `get_last_value`, `get_values`, `set_bar_color`, `set_icon`, `set_max_value`, `set_title_text`, `set_value_text`, `set_values`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` |  |
| `width:` | `200` |  |
| `height:` | `80` |  |
| `title_text:` | `"Sold Items"` |  |
| `value_text:` | `"1.3K"` |  |
| `allow_html:` | `0` | 1: titleText and valueText are HTML (only for your own texts) |
| `icon_file:` | `""` | "": No icon |
| `bar_color:` | `"tomato"` |  |
| `values:` | `[]` | [10, 20, { value: 15, color: "orange" }] |
| `max_value:` | `0` | 0: Auto (the biggest visible value is the top of the graph) |
| `animated:` | `1` | 1: Bar heights change with a short motion. |
| `show_tooltip:` | `1` | 1: the value of the bar under the mouse, in a small box (at once) |
| `value_format:` | `a block` | The text of the tooltip |
| `on_click:` | `a block` |  |
| `style:` | `{...}` |  |

## Notice

`Notice(...)` makes the Notice of the kit (comp/notice.js).

`style_name:` `"classic"`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `close`, `remove`.

| Param | Default | The kit says |
|---|---|---|
| `left:` | `0` |  |
| `top:` | `0` |  |
| `width:` | `"100%"` |  |
| `height:` | `"100%"` |  |
| `message_text:` | `"No message"` |  |
| `description_text:` | `""` | "": no second line |
| `type:` | `"info"` | "info", "warning", "error", "note", "success" |
| `icon_file:` | `""` | "": no icon |
| `allow_html:` | `0` | 1: the texts are HTML (only for your own texts) |
| `display_time:` | `2000` | ms; 0: it stays until a click or Escape |
| `close_on_click:` | `1` |  |
| `on_close:` | `a block` |  |
| `style_name:` | `"classic"` | "classic" or a name added to Notice.styles |
| `style:` | `{...}` | Classic style package |

## NumberField

`NumberField(...)` makes the NumberField of the kit (comp/number-field.js).

A dark window gives it its dark look.

Read without a question to the page: `obj.text`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `blur_func`, `check_if_input_is_required_and_empty`, `check_input_value`, `focus_func`, `get_value`, `input_func`, `is_valid`, `set_background_color`, `set_description_text`, `set_focus_background_color`, `set_focus_line_color`, `set_line_color`, `set_max_length`, `set_placeholder`, `set_required`, `set_required_icon`, `set_required_text`, `set_title_text`, `set_unit_text`, `set_value`, `set_warning_color`, `set_warning_icon`, `set_warning_text`, `show_warning_if_not_valid`.

| Param | Default | The kit says |
|---|---|---|
| `required:` | `0 (the kit alone: 0)` |  |
| `type:` | `"number"` |  |
| `title_text:` | `"" (the kit alone: "NUMERIC")` |  |
| `max_length:` | `35` |  |
| `placeholder:` | `"" (the kit alone: "(auto)")` |  |
| `allow_negative:` | `0` |  |
| `allow_decimal:` | `1` |  |
| `decimal_separator:` | `"."` | "," |
| `max_decimal_digits:` | `2` |  |
| `key:` | `"0"` |  |
| `style_name:` | `"light" (the kit alone: "light")` | "light", "dark", "modern" ("classic": its old name), "modernDark", "ozden", "ozdenDark", "minimal", "minimalDark" or a name added to TextField.styles |
| `width:` | `350` |  |
| `height:` | `"auto"` |  |
| `left_padding:` | `20` |  |
| `right_padding:` | `60` |  |
| `title_font_size:` | `16` |  |
| `input_font_size:` | `20` |  |
| `input_height:` | `40` | px: the row of the text |
| `field_padding:` | `14` | px: over and under the title and the text (titlePosition "inside") |
| `description_font_size:` | `14` |  |
| `title_position:` | `"inside"` | "inside": the title in the field, over the text. "above": the title over the field (the field is only the row of the text). (Only at create time) |
| `title_gap:` | `4` | px between the title and the field (titlePosition "above") |
| `value:` | `""` |  |
| `show_description:` | `0` |  |
| `description_text:` | `""` |  |
| `allow_html:` | `0` | 1: titleText, descriptionText and unitText are HTML (only for your own texts) |
| `background_color:` | `"#F6F6F6"` |  |
| `focus_background_color:` | `"#F3F4E0"` |  |
| `hover_background_color:` | `""` | the field under the mouse (not while it is selected). "": no change |
| `line_color:` | `"#373836"` |  |
| `focus_line_color:` | `"#65A293"` |  |
| `back_border_color:` | `Black(0)` |  |
| `focus_back_border_color:` | `Black(0)` |  |
| `hover_back_border_color:` | `""` | the edge under the mouse (not while it is selected). "": no change |
| `back_border_top_round:` | `2` |  |
| `back_border_bottom_round:` | `0` |  |
| `title_text_color:` | `"#555555"` |  |
| `title_bold:` | `0` | 1: the title in bold (opensans-bold) |
| `title_letter_spacing:` | `""` | "": normal. Ex: "0.06em" |
| `input_text_color:` | `"#373836"` |  |
| `input_color_scheme:` | `""` | "": the page's. "dark": the autofill colors of the browser stay dark (on a dark field) |
| `placeholder_color:` | `""` | "": the color of the browser |
| `description_text_color:` | `"#999999"` |  |
| `warning_ball_border_color:` | `"#373836"` |  |
| `required_text:` | `"Required"` |  |
| `required_color:` | `"white"` |  |
| `warning_text:` | `"Invalid value format"` |  |
| `warning_color:` | `"#E5885E"` |  |
| `animated_warning_ball:` | `1` |  |
| `warning_ball_type:` | `"color"` | "color": colored ball, "icon": icon image |
| `warning_ball_size:` | `16` | px: the colored ball (warningBallType "color") |
| `warning_ball_border:` | `2` | px: the edge of the colored ball (warningBallBorderColor) |
| `warning_border_color:` | `""` | the edge of the field while it shows a warning (not while typing). "": no change |
| `warning_icon_size:` | `20` |  |
| `required_icon_file:` | `""` | image path or data URI. "": built-in icon |
| `warning_icon_file:` | `""` | image path or data URI. "": built-in icon |
| `required_icon_color:` | `"#373836"` | built-in required icon color (built-in warning icon uses warningColor) |
| `tooltip_style:` | `{...}` |  |
| `select_style:` | `{...}` |  |
| `show_left_box:` | `0` |  |
| `show_right_box:` | `0` |  |
| `show_unit:` | `0` |  |
| `create_input:` | `1` |  |
| `unit_text:` | `""` |  |
| `unit_style:` | `{...}` |  |
| `on_focus:` | `a block` |  |
| `on_blur:` | `a block` |  |
| `on_change:` | `a block` | the user changed the text (not at create time, not by setValue()) |
| `on_enter:` | | the Enter key: a block or a lambda that gets the field |

## NumericKeyboard

`NumericKeyboard(...)` makes the NumericKeyboard of the kit (comp/numeric-keyboard.js).

`style_name:` `"classic"`, `"dark"`, `"light"`.

A dark window gives it its dark look.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `clear`, `get_value`, `set_title_text`, `set_value`.

| Param | Default | The kit says |
|---|---|---|
| `width:` | `"auto"` | As wide as the keys |
| `height:` | `"auto"` |  |
| `key_layout:` | `"wide"` | "wide": two rows; "phone": a 3 x 4 grid with an enter key |
| `title_text:` | `"PIN"` | "": no title |
| `value:` | `""` |  |
| `max_length:` | `4` |  |
| `mask:` | `0` | 1: a • for each digit (a PIN) |
| `show_value:` | `1` | 0: only the keys (the value is shown somewhere else) |
| `on_change:` | `a block` |  |
| `on_enter:` | `a block` |  |
| `style_name:` | `"light"` | "light" ("classic": its old name), "dark" or a name added to NumericKeyboard.styles |
| `style:` | `{...}` | Classic style package |

## PageControl

`PageControl(...)` makes the PageControl of the kit (comp/page-control.js).

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `add_page`, `clear`, `end_page`, `focus`, `get_count`, `get_index`, `get_keys`, `get_page`, `is_first`, `is_last`, `next`, `open`, `open_index`, `previous`, `remove_page`, `set_auto_play`, `set_enabled`, `set_loop`, `start_page`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` |  |
| `width:` | `600` |  |
| `height:` | `400` |  |
| `pages:` | `[]` | Keys of the pages to create at start. Ex: ["welcome", "details"] |
| `value:` | `null` | Key of the open page. null: the first page |
| `transition:` | `"slide"` | "slide", "slide-vertical", "fade", "none" (Only at create time) |
| `motion:` | `0.3` | Seconds. 0: No animation |
| `easing:` | `"cubic-bezier(0.2, 0, 0, 1)"` |  |
| `loop:` | `0` | 1: next() after the last page opens the first page. |
| `swipe:` | `1` | 1: Drag with a finger or the mouse to change the page. (slide transitions) |
| `swipe_threshold:` | `0.2` | Part of the box size (0.2: 20%) to change the page. A fast flick also changes it. |
| `keyboard:` | `1` | 1: Arrow keys (when the box has the focus), Home / End |
| `dots:` | `0` | 1: Page dots at the bottom |
| `arrows:` | `0` | 1: Previous / next buttons at the sides |
| `auto_play:` | `0` | Seconds. 0: Off. Ex: 4 -> next page every 4 seconds (loop is used) |
| `page_scroll:` | `0` | 1: Every page scrolls its own content (scrollY) |
| `enabled:` | `1` |  |
| `aria_label:` | `"Pages"` |  |
| `on_before_change:` | `a block` | Return false to stop the change. |
| `on_change:` | `a block` | self.value, self.previousValue |
| `on_close:` | `a block` | The old page is out of the view (after the motion) |
| `style:` | `{...}` |  |

## PageHeader

`PageHeader(...)` makes the PageHeader of the kit (comp/page-header.js).

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `set_back_text`, `set_back_visible`, `set_title_text`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` | Your name for this object: read it in a callback (self.key) |
| `left:` | `0` | The header stands at the top of its container (a page) |
| `top:` | `0` |  |
| `width:` | `"100%"` |  |
| `height:` | `105` |  |
| `color:` | `"white"` | The background of the header |
| `title_text:` | `""` |  |
| `back_text:` | `"Back"` | The text of the back link (Ex: the name of the page it goes back to) |
| `show_back:` | `1` | 1: the back link over the title (setBackVisible) |
| `back_color:` | `"#689BD2"` | The drawn chevron and the text of the back link |
| `back_icon_file:` | `""` | "": a chevron drawn in SVG in backColor |
| `on_back:` | `a block` | The back link is clicked (or pressed with Enter / Space) |
| `style:` | `{...}` |  |

## PasswordField

`PasswordField(...)` makes the PasswordField of the kit (comp/password-field.js).

A dark window gives it its dark look.

Read without a question to the page: `obj.text`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `blur_func`, `check_if_input_is_required_and_empty`, `check_input_value`, `focus_func`, `get_value`, `input_func`, `is_valid`, `set_background_color`, `set_description_text`, `set_focus_background_color`, `set_focus_line_color`, `set_line_color`, `set_max_length`, `set_placeholder`, `set_required`, `set_required_icon`, `set_required_text`, `set_show_password`, `set_title_text`, `set_unit_text`, `set_value`, `set_warning_color`, `set_warning_icon`, `set_warning_text`, `show_warning_if_not_valid`.

| Param | Default | The kit says |
|---|---|---|
| `required:` | `0 (the kit alone: 1)` |  |
| `required_text:` | `"Password must be entered"` |  |
| `type:` | `"password"` |  |
| `title_text:` | `"" (the kit alone: "PASSWORD")` |  |
| `placeholder:` | `"Enter your password"` |  |
| `warning_text:` | `""` |  |
| `warning_color:` | `"#E5885E"` |  |
| `max_length:` | `1000 (the kit alone: 25)` |  |
| `show_password:` | `0` |  |
| `show_show_password_button:` | `1` | enable show/hide icon by default |
| `show_password_icon_file:` | `"data:image/svg+xml;utf8," + encodeURIComponent('<svg xml...` | an eye (a page can give its own picture) |
| `hide_password_icon_file:` | `"data:image/svg+xml;utf8," + encodeURIComponent('<svg xml...` | a crossed eye |
| `eye_icon_size:` | `""` | px: the size of the eye (both icons). "": by the height of the field (32; a small field less) |
| `show_password_hint_text:` | `"Show Password"` |  |
| `hide_password_hint_text:` | `"Hide Password"` |  |
| `min_length:` | `6` |  |
| `min_length_warning_text:` | `"Password must be at least 6 characters"` |  |
| `must_use_number:` | `1` |  |
| `must_use_number_warning_text:` | `"Password must contain at least one number"` |  |
| `must_use_letter:` | `1` |  |
| `must_use_letter_warning_text:` | `"Password must contain at least one letter"` |  |
| `must_use_uppercase:` | `0` |  |
| `must_use_uppercase_warning_text:` | `"Password must contain at least one uppercase letter"` |  |
| `must_use_lowercase:` | `0` |  |
| `must_use_lowercase_warning_text:` | `"Password must contain at least one lowercase letter"` |  |
| `must_use_special_char:` | `0` |  |
| `must_use_special_char_warning_text:` | `"Password must contain at least one special character"` |  |
| `invert_icon_color:` | `0` |  |
| `key:` | `"0"` |  |
| `style_name:` | `"light" (the kit alone: "light")` | "light", "dark", "modern" ("classic": its old name), "modernDark", "ozden", "ozdenDark", "minimal", "minimalDark" or a name added to TextField.styles |
| `width:` | `350` |  |
| `height:` | `"auto"` |  |
| `left_padding:` | `20` |  |
| `right_padding:` | `60` |  |
| `title_font_size:` | `16` |  |
| `input_font_size:` | `20` |  |
| `input_height:` | `40` | px: the row of the text |
| `field_padding:` | `14` | px: over and under the title and the text (titlePosition "inside") |
| `description_font_size:` | `14` |  |
| `title_position:` | `"inside"` | "inside": the title in the field, over the text. "above": the title over the field (the field is only the row of the text). (Only at create time) |
| `title_gap:` | `4` | px between the title and the field (titlePosition "above") |
| `value:` | `""` |  |
| `show_description:` | `0` |  |
| `description_text:` | `""` |  |
| `allow_html:` | `0` | 1: titleText, descriptionText and unitText are HTML (only for your own texts) |
| `background_color:` | `"#F6F6F6"` |  |
| `focus_background_color:` | `"#F3F4E0"` |  |
| `hover_background_color:` | `""` | the field under the mouse (not while it is selected). "": no change |
| `line_color:` | `"#373836"` |  |
| `focus_line_color:` | `"#65A293"` |  |
| `back_border_color:` | `Black(0)` |  |
| `focus_back_border_color:` | `Black(0)` |  |
| `hover_back_border_color:` | `""` | the edge under the mouse (not while it is selected). "": no change |
| `back_border_top_round:` | `2` |  |
| `back_border_bottom_round:` | `0` |  |
| `title_text_color:` | `"#555555"` |  |
| `title_bold:` | `0` | 1: the title in bold (opensans-bold) |
| `title_letter_spacing:` | `""` | "": normal. Ex: "0.06em" |
| `input_text_color:` | `"#373836"` |  |
| `input_color_scheme:` | `""` | "": the page's. "dark": the autofill colors of the browser stay dark (on a dark field) |
| `placeholder_color:` | `""` | "": the color of the browser |
| `description_text_color:` | `"#999999"` |  |
| `warning_ball_border_color:` | `"#373836"` |  |
| `required_color:` | `"white"` |  |
| `animated_warning_ball:` | `1` |  |
| `warning_ball_type:` | `"color"` | "color": colored ball, "icon": icon image |
| `warning_ball_size:` | `16` | px: the colored ball (warningBallType "color") |
| `warning_ball_border:` | `2` | px: the edge of the colored ball (warningBallBorderColor) |
| `warning_border_color:` | `""` | the edge of the field while it shows a warning (not while typing). "": no change |
| `warning_icon_size:` | `20` |  |
| `required_icon_file:` | `""` | image path or data URI. "": built-in icon |
| `warning_icon_file:` | `""` | image path or data URI. "": built-in icon |
| `required_icon_color:` | `"#373836"` | built-in required icon color (built-in warning icon uses warningColor) |
| `tooltip_style:` | `{...}` |  |
| `select_style:` | `{...}` |  |
| `show_left_box:` | `0` |  |
| `show_right_box:` | `0` |  |
| `show_unit:` | `0` |  |
| `create_input:` | `1` |  |
| `unit_text:` | `""` |  |
| `unit_style:` | `{...}` |  |
| `on_focus:` | `a block` |  |
| `on_blur:` | `a block` |  |
| `on_change:` | `a block` | the user changed the text (not at create time, not by setValue()) |
| `on_enter:` | | the Enter key: a block or a lambda that gets the field |

## PeriodBar

`PeriodBar(...)` makes the PeriodBar of the kit (comp/period-bar.js).

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `focus`, `get_selected_date`, `select_next`, `select_previous`, `set_value`, `set_visible`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` | Your name for this object: read it in a callback (self.key) |
| `width:` | `600` |  |
| `height:` | `160` |  |
| `month_count:` | `12` | This month and the months before it. (Only at create time) |
| `language:` | `"en"` | "en", "tr" or a key added to PeriodBar.TEXTS (Only at create time) |
| `value:` | `null` | The index of the selected month: 0 the oldest, monthCount - 1 this month. null: this month |
| `aria_label:` | `""` | "": the name of the bar in the language ("Month") |
| `on_change:` | `a block` | self.value, self.previousValue, self.getSelectedDate() |
| `style:` | `{...}` |  |

## PhoneField

`PhoneField(...)` makes the PhoneField of the kit (comp/phone-field.js).

A dark window gives it its dark look.

Read without a question to the page: `obj.text`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `blur_func`, `check_if_input_is_required_and_empty`, `check_input_value`, `fill_auto_placeholder`, `focus_func`, `get_value`, `input_func`, `is_valid`, `set_background_color`, `set_country_code`, `set_description_text`, `set_focus_background_color`, `set_focus_line_color`, `set_line_color`, `set_max_length`, `set_phone_mask`, `set_placeholder`, `set_required`, `set_required_icon`, `set_required_text`, `set_title_text`, `set_unit_text`, `set_value`, `set_warning_color`, `set_warning_icon`, `set_warning_text`, `show_warning_if_not_valid`.

| Param | Default | The kit says |
|---|---|---|
| `required:` | `0 (the kit alone: 1)` |  |
| `title_text:` | `"" (the kit alone: "PHONE NUMBER")` |  |
| `placeholder:` | `"(auto)"` |  |
| `warning_text:` | `"Invalid phone number format"` |  |
| `warning_color:` | `"#E5885E"` |  |
| `country_code:` | `"+90"` |  |
| `phone_mask:` | `" (___) ___-____"` |  |
| `unit_text:` | `"TR"` |  |
| `key:` | `"0"` |  |
| `style_name:` | `"light" (the kit alone: "light")` | "light", "dark", "modern" ("classic": its old name), "modernDark", "ozden", "ozdenDark", "minimal", "minimalDark" or a name added to TextField.styles |
| `type:` | `"text"` |  |
| `width:` | `350` |  |
| `height:` | `"auto"` |  |
| `left_padding:` | `20` |  |
| `right_padding:` | `60` |  |
| `title_font_size:` | `16` |  |
| `input_font_size:` | `20` |  |
| `input_height:` | `40` | px: the row of the text |
| `field_padding:` | `14` | px: over and under the title and the text (titlePosition "inside") |
| `description_font_size:` | `14` |  |
| `title_position:` | `"inside"` | "inside": the title in the field, over the text. "above": the title over the field (the field is only the row of the text). (Only at create time) |
| `title_gap:` | `4` | px between the title and the field (titlePosition "above") |
| `value:` | `""` |  |
| `max_length:` | `30` |  |
| `show_description:` | `0` |  |
| `description_text:` | `""` |  |
| `allow_html:` | `0` | 1: titleText, descriptionText and unitText are HTML (only for your own texts) |
| `background_color:` | `"#F6F6F6"` |  |
| `focus_background_color:` | `"#F3F4E0"` |  |
| `hover_background_color:` | `""` | the field under the mouse (not while it is selected). "": no change |
| `line_color:` | `"#373836"` |  |
| `focus_line_color:` | `"#65A293"` |  |
| `back_border_color:` | `Black(0)` |  |
| `focus_back_border_color:` | `Black(0)` |  |
| `hover_back_border_color:` | `""` | the edge under the mouse (not while it is selected). "": no change |
| `back_border_top_round:` | `2` |  |
| `back_border_bottom_round:` | `0` |  |
| `title_text_color:` | `"#555555"` |  |
| `title_bold:` | `0` | 1: the title in bold (opensans-bold) |
| `title_letter_spacing:` | `""` | "": normal. Ex: "0.06em" |
| `input_text_color:` | `"#373836"` |  |
| `input_color_scheme:` | `""` | "": the page's. "dark": the autofill colors of the browser stay dark (on a dark field) |
| `placeholder_color:` | `""` | "": the color of the browser |
| `description_text_color:` | `"#999999"` |  |
| `warning_ball_border_color:` | `"#373836"` |  |
| `required_text:` | `"Required"` |  |
| `required_color:` | `"white"` |  |
| `animated_warning_ball:` | `1` |  |
| `warning_ball_type:` | `"color"` | "color": colored ball, "icon": icon image |
| `warning_ball_size:` | `16` | px: the colored ball (warningBallType "color") |
| `warning_ball_border:` | `2` | px: the edge of the colored ball (warningBallBorderColor) |
| `warning_border_color:` | `""` | the edge of the field while it shows a warning (not while typing). "": no change |
| `warning_icon_size:` | `20` |  |
| `required_icon_file:` | `""` | image path or data URI. "": built-in icon |
| `warning_icon_file:` | `""` | image path or data URI. "": built-in icon |
| `required_icon_color:` | `"#373836"` | built-in required icon color (built-in warning icon uses warningColor) |
| `tooltip_style:` | `{...}` |  |
| `select_style:` | `{...}` |  |
| `show_left_box:` | `0` |  |
| `show_right_box:` | `0` |  |
| `show_unit:` | `0` |  |
| `create_input:` | `1` |  |
| `unit_style:` | `{...}` |  |
| `on_focus:` | `a block` |  |
| `on_blur:` | `a block` |  |
| `on_change:` | `a block` | the user changed the text (not at create time, not by setValue()) |
| `on_enter:` | | the Enter key: a block or a lambda that gets the field |

## ProgressBar

`ProgressBar(...)` makes the ProgressBar of the kit (comp/progress-bar.js).

`style_name:` `"classic"`, `"dark"`, `"light"`, `"minimal"`, `"minimalDark"`, `"modern"`, `"ozden"`, `"ozdenDark"`.

A dark window gives it its dark look.

Read without a question to the page: `obj.value`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `add_value`, `get_percent`, `reset`, `set_dark_track`, `set_indeterminate`, `set_limits`, `set_max_value`, `set_second_stripes`, `set_second_value`, `set_status`, `set_stripes`, `set_title_text`, `set_value`, `set_values`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` |  |
| `width:` | `320` |  |
| `height:` | `"auto"` |  |
| `value:` | `0` | 0 - maxValue |
| `second_value:` | `0` | A second part after the value (value + secondValue <= maxValue). 0: none |
| `max_value:` | `100` |  |
| `stripes:` | `0` | 1: moving stripes on the value part |
| `second_stripes:` | `0` | 1: moving stripes on the second part |
| `limits:` | `[]` | Lines at these values: [80] or [{ value: 80, color: "indianred" }] |
| `dark_track:` | `0` | 1: the track in the colors of style.darkTrack (the bars keep theirs) |
| `indeterminate:` | `0` | 1: Progress is not known, show a moving bar. |
| `status:` | `"normal"` | "normal", "success", "error" |
| `title_text:` | `""` |  |
| `allow_html:` | `0` | 1: titleText and the text of valueFormat are HTML (only for your own texts) |
| `value_position:` | `"top"` | "top", "right", "none" (Only at create time) |
| `value_format:` | `a block` | Returns the value text. |
| `on_change:` | `a block` | self.value |
| `on_complete:` | `a block` | Called once when the value reaches maxValue. |
| `style_name:` | `"light"` | "light" ("classic": its old name), "dark", "modern", "ozden", "ozdenDark", "minimal", "minimalDark" or a name added to ProgressBar.styles |
| `style:` | `{...}` | The base of every package (a thin dark bar on a light gray track): a package changes only some keys |

## PropertyPanel

`PropertyPanel(...)` makes the PropertyPanel of the kit (comp/property-panel.js).

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `close`, `close_color_picker`, `get_data`, `get_item`, `get_value`, `get_values`, `is_color_picker_open`, `is_popup_element`, `listen`, `open`, `open_color_picker_for`, `remove`, `set_active_tab`, `set_data`, `set_enabled`, `set_item_visible`, `set_title`, `set_value`, `set_values`, `toggle`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` |  |
| `width:` | `240` |  |
| `data:` | `{}` | tabs, activeTab, headerTitle, headerItem, title, titleActions, sections, footer, empty (See the USAGE above) |
| `opened:` | `1` | 1: Open at create time. |
| `on_change:` | `a block` | Every change: { kind, key, value, oldValue, item, sectionKey } |
| `palettes:` | `null` | The color groups of the color picker: [{ key, name, colors, canAdd, emptyText }] or function (panel) -> that |
| `recent_colors_key:` | `""` | The recent colors of the color picker are kept in basic.storage with this key. "": only until the page closes. |
| `pick_color:` | `null` | function (panel, done): the eyedropper where the browser has none (VS Code, Safari, Firefox): the page |
| `style:` | `{...}` |  |

## RadioButton

`RadioButton(...)` makes the RadioButton of the kit (comp/radio-button.js).

`style_name:` `"classic"`, `"dark"`, `"light"`, `"minimal"`, `"minimalDark"`, `"modern"`.

A dark window gives it its dark look.

Read without a question to the page: `obj.checked`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `remove`, `select`, `set_checked`, `set_enabled`, `set_label_text`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` |  |
| `width:` | `"auto"` |  |
| `height:` | `"auto"` |  |
| `group:` | `"default"` | Radio buttons with the same group name work together. |
| `value:` | `""` | Returned by RadioButton.getValue(group) |
| `checked:` | `0` | 0, 1 |
| `enabled:` | `1` | 0, 1 |
| `label_text:` | `""` |  |
| `allow_html:` | `0` | 1: labelText is HTML (only for your own texts) |
| `label_position:` | `"right"` | "right", "left" |
| `on_change:` | `a block` | Called when this radio button is selected. |
| `style_name:` | `"light"` | "light" ("classic": its old name), "modern", "dark", "minimal", "minimalDark" or a name added to RadioButton.styles |
| `style:` | `{...}` | Light style package (default) |

## RangeSlider

`RangeSlider(...)` makes the RangeSlider of the kit (comp/range-slider.js).

`style_name:` `"minimal"`, `"minimalDark"`, `"round"`, `"roundDark"`.

A dark window gives it its dark look.

Read without a question to the page: `obj.high`, `obj.low`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `get_values`, `set_enabled`, `set_max_value`, `set_min_gap`, `set_min_value`, `set_step`, `set_theme`, `set_values`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` | Your name for this object: read it in a callback (self.key) |
| `left:` | `0` |  |
| `top:` | `0` |  |
| `width:` | `250` |  |
| `height:` | `44` | WHY: The place a finger can take; the bar stands in its middle. |
| `min_value:` | `0` | The value at the left end |
| `max_value:` | `100` | The value at the right end |
| `step:` | `1` | The values are min + n * step (Ex: 0.5) |
| `low_value:` | `null` | The left knob. null: minValue |
| `high_value:` | `null` | The right knob. null: maxValue |
| `min_gap:` | `0` | The smallest distance between the two values |
| `show_value_on_move:` | `1` | 1: the bubble of the value over a knob that moves |
| `format_value:` | `null` | a format text, made by the page at once: "{:,.2f} TL", "{:.0f} kg", "{:.1%}" (not a block) |
| `enabled:` | `1` |  |
| `low_aria_label:` | `"Minimum"` | The names a screen reader says |
| `high_aria_label:` | `"Maximum"` |  |
| `on_change:` | `a block` | It moves: self.lowValue, self.highValue |
| `on_change_end:` | `a block` | It was let go |
| `style_name:` | `"round"` | "round", "roundDark", "minimal", "minimalDark" or a name added to RangeSlider.styles |
| `style:` | `{...}` | The round style package (default) |

## RichTextEditor

`RichTextEditor(...)` makes the RichTextEditor of the kit (comp/rich-text-editor.js).

`style_name:` `"classic"`, `"dark"`, `"light"`, `"modern"`.

A dark window gives it its dark look.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `clear`, `focus`, `focus_end`, `get_html_text`, `get_length`, `get_text`, `insert_html`, `insert_text`, `is_empty`, `run_tool`, `set_enabled`, `set_html_text`, `set_max_length`, `set_placeholder`, `set_read_only`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` |  |
| `width:` | `560` |  |
| `height:` | `300` |  |
| `html_text:` | `""` | Start content (HTML, it is cleaned) |
| `placeholder:` | `"Write something..."` |  |
| `tools:` | `["bold", "italic", "underline", "strike", "\|", "h2", "h3"...` |  |
| `paste_as:` | `"clean"` | "clean": keeps the allowed formats, "text": plain text |
| `max_length:` | `0` | Characters of the text. 0: no limit |
| `show_counter:` | `0` | 1: "120 / 500" (or "120 characters") at the bottom right |
| `read_only:` | `0` |  |
| `enabled:` | `1` |  |
| `spell_check:` | `1` |  |
| `use_scroll_bar:` | `1` | basic/scroll-bar.js for the writing area. 0: the scrollbar of the browser. |
| `aria_label:` | `"Text editor"` |  |
| `texts:` | `{...}` |  |
| `on_change:` | `a block` | self.getHtmlText(), self.getText() |
| `on_focus:` | `a block` |  |
| `on_blur:` | `a block` |  |
| `style_name:` | `"light"` | "light" ("classic": its old name), "modern", "dark" or a name added to RichTextEditor.styles |
| `style:` | `{...}` | Light style package (default) |

## ScrollArea

`ScrollArea(...)` makes the ScrollArea of the kit (comp/scroll-area.js).

`style_name:` `"dark"`, `"light"`, `"minimal"`, `"minimalDark"`.

A dark window gives it its dark look.

Objects go into it with its block: `ScrollArea(...) { ... }`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `get_scroll_top`, `scroll_to_end`, `scroll_to_object`, `scroll_to_top`, `set_align`, `set_gap`, `set_padding`, `set_scroll_top`, `set_scroll_x`, `set_scroll_y`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` | Your name for this object: read it in a callback (self.key) |
| `left:` | `0` | The place on a box (the page). In a group, the group places it. |
| `top:` | `0` |  |
| `width:` | `"100%"` | "100%" in an HGroup: the width the other objects leave. |
| `height:` | `"100%"` | "100%" in a VGroup: the height the other objects leave. |
| `align:` | `"left top"` | The content, as in a VGroup: "center top", "center center" (in the middle while it fits)... |
| `gap:` | `0` | px between the objects of the content |
| `padding:` | `0` | Around the content, it scrolls with it: 40, [x, y] or [left, top, right, bottom] |
| `scroll_y:` | `1` | 1: it scrolls down. |
| `scroll_x:` | `0` | 1: it scrolls to the side too. |
| `use_scroll_bar:` | `1` | 1: the ScrollBar of the kit, when basic/scroll-bar.js is loaded. (Only at create time) |
| `on_scroll:` | `a block` | The content moved. (self.getScrollTop()) |
| `style_name:` | `"light"` | "light", "dark", "minimal", "minimalDark" or a name added to ScrollArea.styles |
| `style:` | `{...}` | Light style package (default) |

## ScrollingText

`ScrollingText(...)` makes the ScrollingText of the kit (comp/scrolling-text.js).

`style_name:` `"classic"`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `remove`, `set_label_text`.

| Param | Default | The kit says |
|---|---|---|
| `width:` | `200` |  |
| `height:` | `"auto"` | As high as the text (with the padding) |
| `label_text:` | `""` |  |
| `allow_html:` | `0` | 1: the text is HTML (only for your own texts) |
| `mode:` | `"always"` | "always": it slides again and again; "hover": only while the mouse is over it |
| `speed:` | `40` | px in a second |
| `wait_time:` | `1.2` | s: at the start and at the end (the longest wait: a short slide waits less) |
| `min_wait_time:` | `0.5` | s: the wait of a very short slide (a few hidden letters are read quickly, but not in a blink) |
| `full_wait_distance:` | `120` | px: a slide this long (or longer) waits the whole waitTime; a shorter one waits less |
| `style_name:` | `"classic"` | "classic" or a name added to ScrollingText.styles |
| `style:` | `{...}` |  |

## SearchInput

`SearchInput(...)` makes the SearchInput of the kit (comp/search-input.js).

`style_name:` `"classic"`, `"dark"`, `"light"`, `"minimal"`, `"minimalDark"`, `"original"`, `"ozden"`, `"ozdenDark"`.

A dark window gives it its dark look.

Read without a question to the page: `obj.text`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `focus`, `get_search_text`, `get_value`, `public_func`, `set_animated`, `set_clear_icon_right`, `set_placeholder`, `set_value`.

| Param | Default | The kit says |
|---|---|---|
| `left:` | `0` |  |
| `top:` | `0` |  |
| `width:` | `300` |  |
| `height:` | `50` |  |
| `search_icon_file:` | `"data:image/svg+xml;utf8," + encodeURIComponent('<svg xml...` |  |
| `clear_icon_file:` | `"data:image/svg+xml;utf8," + encodeURIComponent('<svg xml...` |  |
| `search_icon_size:` | `24` |  |
| `search_icon_left:` | `16` | px: the search icon from the left side of the box |
| `search_icon_gap:` | `8` | px: between the search icon and the text |
| `clear_icon_right:` | `16` | px: the clear icon from the right side of the box (more: the right end is for an object of the page) |
| `text_end_space:` | `null` | px between the end of the text and the clear icon. null: 20 - searchIconSize (where it always was) |
| `show_clear_icon:` | `1` |  |
| `clear_icon_min_text_width:` | `0` | px: the clear icon is not shown when the text beside it would be narrower (0: always shown) |
| `text_fade_width:` | `24` | px: a text longer than the box fades out over this width where it is cut (0: cut sharply) |
| `clear_on_escape:` | `0` | 1: Escape clears the text (as the clear icon); in an empty field it goes on to the page |
| `value:` | `""` | The text in the box: typing changes it. setValue(), getValue() |
| `placeholder:` | `"Search"` |  |
| `color:` | `"whitesmoke"` |  |
| `text_color:` | `"rgba(0, 0, 0, 0.8)"` |  |
| `placeholder_color:` | `""` | "": the color of the browser. On a dark ground give a color like White(0.35). |
| `search_icon_opacity:` | `1` |  |
| `clear_icon_opacity:` | `0.6` | The clear icon while it is shown |
| `border:` | `0` |  |
| `border_color:` | `"rgba(0, 0, 0, 0.1)"` |  |
| `border_bottom_style:` | `"2px solid rgba(0, 0, 0, 0.06)"` |  |
| `focus_border_color:` | `""` | the edge while typing: 2 px of this color ("": it does not change) |
| `focus_border_width:` | `2` | px of the edge while typing: 2 the edge and a 1 px line inside it, 1 only the edge |
| `round:` | `6` |  |
| `font_size:` | `20` |  |
| `text_offset_y:` | `0` | px: the text up (-) or down (+) from the middle of the box (the ozden packages: -2) |
| `clear_icon_offset_y:` | `0` | px: the clear icon up (-) or down (+) from the middle of the box (the ozden packages: -1) |
| `search_icon_offset_y:` | `0` | px: the search icon up (-) or down (+) from the middle of the box (light and dark: 1) |
| `invert_icon_color:` | `0` | 1: both icons are inverted (white icons for a dark field) |
| `invert_search_icon_color:` | `null` | null: invertIconColor. 0 / 1: only the search icon |
| `invert_clear_icon_color:` | `null` | null: invertIconColor. 0 / 1: only the clear icon |
| `animated:` | `0` | 1: small hover / focus / clear motions. (box.setAnimated(0/1)) |
| `hover_ring_color:` | `"rgba(0, 0, 0, 0.08)"` | animated: the thin line inside the border under the mouse |
| `focus_ring_color:` | `"rgba(0, 0, 0, 0.16)"` | animated: the line while typing |
| `on_change:` | `a block` | The text changed (typed, pasted, cleared, setValue()): self.value, self.getSearchText() (lower case). Not at create time, not with setValue(value, 1) |
| `on_enter:` | `a block` | Enter, and the clear icon: self.getSearchText() |
| `style_name:` | `"ozden" (the kit alone: "ozden")` | "ozden", "ozdenDark", "original" (the look of these defaults), "light" ("classic": its old name), "dark", "minimal", "minimalDark" or a name added to SearchInput.styles |
| `style:` | `{}` | WHY: the look is in the flat params above; the packages are packages of params (see SearchInput.styles). |

## SearchResults

`SearchResults(...)` makes the SearchResults of the kit (comp/search-results.js).

`style_name:` `"classic"`, `"dark"`, `"light"`, `"modern"`.

A dark window gives it its dark look.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `attach_to`, `close`, `detach`, `get_active_index`, `get_items`, `move_active`, `open`, `remove`, `select_active`, `select_index`, `set_active_index`, `set_items`, `set_match_anchor_width`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` |  |
| `anchor:` | `null` | The basic.js object the list opens under. (Ex: a SearchInput) |
| `anchor_align:` | `"right"` | "right": the right edges meet, "left": the left edges meet. |
| `match_anchor_width:` | `0` | 1: the list is as wide as the anchor (both edges meet; maxWidth is not used). setMatchAnchorWidth() |
| `max_width:` | `380` |  |
| `max_height_ratio:` | `0.7` | Of the screen height. |
| `offset_y:` | `6` | Space between the anchor and the list. |
| `screen_margin:` | `8` | The list never comes closer than this to the edge of the screen. |
| `empty_text:` | `"No results for \"{query}\""` | {query} is replaced by the text that was searched. |
| `show_empty:` | `1` | 0: The list is not opened at all when there is no result. |
| `hint_text:` | `"↑ ↓ to move · Enter to open · Esc to close"` |  |
| `show_hint:` | `1` |  |
| `show_groups:` | `1` |  |
| `open_on_focus:` | `1` | Focus on the input opens the last results again. |
| `close_on_blur:` | `1` |  |
| `use_scroll_bar:` | `1` | basic/scroll-bar.js. 0: the scrollbar of the browser. |
| `z_index_value:` | `1000` | WHY: "zIndex" is a basic.js property of every box, the name is taken. |
| `aria_label:` | `"Search results"` |  |
| `on_select:` | `a block` |  |
| `on_open:` | `a block` |  |
| `on_close:` | `a block` |  |
| `on_active_change:` | `a block` |  |
| `style_name:` | `"light"` | "light" ("classic": its old name), "dark", "modern" or a name added to SearchResults.styles |
| `style:` | `{...}` | Light style package (default) |

## SelectBox

`SelectBox(...)` makes the SelectBox of the kit (comp/select-box.js).

`style_name:` `"classic"`, `"dark"`, `"light"`, `"minimal"`, `"minimalDark"`, `"ozden"`, `"ozdenDark"`.

A dark window gives it its dark look.

Read without a question to the page: `obj.value`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `clear`, `close`, `focus`, `get_selected_options`, `get_value`, `is_open`, `open`, `set_enabled`, `set_full_height_list`, `set_options`, `set_placeholder`, `set_value`, `toggle`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` |  |
| `width:` | `240` |  |
| `height:` | `44` |  |
| `options:` | `[]` | [{ value, label, description, iconFile, group, disabled }] or ["A", "B"] |
| `value:` | `null` | Single: a value or null. Multiple: [values] |
| `multiple:` | `0` |  |
| `searchable:` | `"auto"` | 1, 0, "auto" (more than autoSearchCount options) |
| `auto_search_count:` | `8` |  |
| `clearable:` | `0` | 1: Clear button in the field |
| `close_on_select:` | `null` | null: 1 for single, 0 for multiple |
| `show_select_all:` | `1` | Multiple: "Select all" and "Clear" buttons |
| `placeholder:` | `"Select..."` |  |
| `search_placeholder:` | `"Search..."` |  |
| `empty_text:` | `"No results"` |  |
| `select_all_text:` | `"Select all"` |  |
| `clear_text:` | `"Clear"` |  |
| `more_text:` | `"+{count}"` | Multiple: field text when many are selected. Ex: "Apple, Banana +3" |
| `field_label_count:` | `2` | Multiple: how many labels are written in the field |
| `panel_min_width:` | `220` |  |
| `panel_max_height:` | `320` |  |
| `max_render_count:` | `300` |  |
| `enabled:` | `1` |  |
| `use_scroll_bar:` | `1` | basic/scroll-bar.js on the list (load it first). 0: the scrollbar of the browser (hidden by basic.css in Chrome). |
| `use_search_input:` | `1` | 1: the search box is a SearchInput when comp/search-input.js is loaded first (style.searchInput). 0: the own input (style.search) |
| `full_height_list:` | `0` | 1: the list opens from the top of the page to its bottom, as wide as the field, at its left. (box.setFullHeightList()) |
| `scale:` | `null` | Multiplies every size. null: basic.uiScale (1, or 1 / page.zoom on a fitted page). (Only at create time) |
| `aria_label:` | `""` |  |
| `on_change:` | `a block` | self.value, self.getSelectedOptions() |
| `on_open:` | `a block` |  |
| `on_close:` | `a block` |  |
| `style_name:` | `"light"` | "light" ("classic": its old name), "dark", "ozden", "ozdenDark", "minimal", "minimalDark" or a name added to SelectBox.styles |
| `style:` | `{...}` | Light style package (default) |

## SettingsRow

`SettingsRow(...)` makes the SettingsRow of the kit (comp/settings-row.js).

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `set_description_text`, `set_title_color`, `set_title_text`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` | Your name for this object: read it in a callback (self.key) |
| `width:` | `"100%"` |  |
| `height:` | `100` |  |
| `color:` | `"white"` | The background of the row |
| `title_text:` | `""` |  |
| `description_text:` | `""` | The small text under the title. "": the title stands in the middle (setDescriptionText) |
| `title_color:` | `Black(0.8)` | Ex: "orangered" for a row that deletes something (setTitleColor) |
| `control:` | `null` | function (row): the objects made in it stand at the right (Ex: a Toggle). Its result: row.controlObject |
| `arrow:` | `0` | 1: a chevron at the right (a row that opens a page: give it onClick) |
| `on_click:` | `a block` | function (self, event): the row can be clicked (role "button", Enter / Space) |
| `style:` | `{...}` |  |

## SidePanel

`SidePanel(...)` makes the SidePanel of the kit (comp/side-panel.js).

`style_name:` `"classic"`, `"dark"`, `"light"`, `"minimal"`, `"minimalDark"`, `"modern"`.

A dark window gives it its dark look.

Read without a question to the page: `obj.is_opened`.

Objects go into it with `panel.body { ... }`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `close`, `end_body`, `get_body`, `open`, `remove`, `set_panel_size`, `set_title_text`, `start_body`, `toggle`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` |  |
| `side:` | `"right"` | "right", "left", "bottom", "top" (Only at create time) |
| `container:` | `null` | null: the page. A box: the panel and its backdrop are made in it. (Only at create time) |
| `panel_size:` | `420` | Width of a left/right panel, height of a top/bottom panel. |
| `screen_margin:` | `60` | The panel never comes closer than this to the opposite edge (of the page or the container). |
| `duration:` | `300` | Length of the animation, in milliseconds. |
| `fade:` | `1` | 1: The panel fades in / out with its slide. 0: It only slides. (The backdrop always fades.) (Only at create time) |
| `title_text:` | `""` |  |
| `allow_html:` | `0` | 1: titleText is HTML (only for your own texts) |
| `show_header:` | `1` | 0: No header. (The close button goes with it.) |
| `show_close_button:` | `1` |  |
| `show_backdrop:` | `1` |  |
| `close_on_backdrop:` | `1` |  |
| `close_on_escape:` | `1` |  |
| `exclusive:` | `1` | 1: Opening this panel closes the other open panel. |
| `opened:` | `0` | 1: Open when it is created. (No animation.) |
| `aria_label:` | `"Panel"` |  |
| `on_open:` | `a block` |  |
| `on_close:` | `a block` |  |
| `on_before_close:` | `a block` | Return false to keep the panel open. |
| `style_name:` | `"light"` | "light" ("classic": its old name), "modern", "dark", "minimal", "minimalDark" or a name added to SidePanel.styles |
| `style:` | `{...}` | Light style package (default) |

## Slider

`Slider(...)` makes the Slider of the kit (comp/slider.js).

`style_name:` `"minimal"`, `"minimalDark"`, `"round"`, `"roundDark"`, `"split"`, `"splitDark"`.

A dark window gives it its dark look.

Read without a question to the page: `obj.value`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `get_value`, `set_max_value`, `set_min_value`, `set_step`, `set_thumb_color`, `set_track_background_color`, `set_track_color`, `set_value`, `show_value`, `show_value_clean`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `0` |  |
| `width:` | `250` |  |
| `value:` | `0` | Current selected value |
| `min_value:` | `0` | The value at the left end (setMinValue) |
| `max_value:` | `100` | The value at the right end (setMaxValue) |
| `step:` | `1` | The values are min + n * step (Ex: 0.5). setStep() |
| `min_thumb_height:` | `44` |  |
| `thumb_color:` | `"rgba(0,0,0,0.7)"` | Color of the draggable button |
| `track_height:` | `16` | Ex: 16, 50 |
| `track_color:` | `"cadetblue"` | Color of the filled part |
| `track_background_color:` | `"rgba(0,0,0,0.05)"` | Color of the unfilled part |
| `on_change_start:` | `a block` | A drag starts (a tap and a key are short drags) |
| `on_change:` | `a block` | self.value changed: while dragging, a tap, a key. Not at create time, not by setValue() |
| `on_change_end:` | `a block` | The drag ends: a page that saves, saves here |
| `show_value_at_start:` | `0` |  |
| `show_value_on_set:` | `1` |  |
| `show_value_on_drag:` | `1` |  |
| `aria_label:` | `""` | The name a screen reader says (Ex: "Volume"). "": none |
| `style_name:` | `"round" (the kit alone: "split")` | "split", "splitDark", "round", "roundDark", "minimal", "minimalDark" or a name added to Slider.styles |
| `style:` | `{...}` | The split style package (default): inspired by Material 3 |

## SliderField

`SliderField(...)` makes the SliderField of the kit (comp/slider-field.js).

`style_name:` `"classic"`, `"dark"`, `"light"`, `"minimal"`, `"minimalDark"`, `"modern"`, `"ozden"`.

A dark window gives it its dark look.

Read without a question to the page: `obj.max_value`, `obj.min_value`, `obj.value`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `decrease`, `focus`, `format_number`, `get_value`, `increase`, `set_enabled`, `set_label_text`, `set_max_value`, `set_min_value`, `set_precision`, `set_range`, `set_show_ticks`, `set_step`, `set_unit_text`, `set_value`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` |  |
| `width:` | `320` |  |
| `height:` | `44` |  |
| `label_text:` | `""` | Text at the left. Ex: "Width" |
| `value:` | `0` |  |
| `min_value:` | `0` |  |
| `max_value:` | `10` |  |
| `step:` | `1` |  |
| `precision:` | `"auto"` | Decimals shown and used for rounding. "auto": the decimals of the step (0.25 -> 2) |
| `unit_text:` | `""` | After the value. Ex: "px", " kg" (with the space) |
| `editable:` | `1` | 1: A click on the value opens the typing. |
| `show_ticks:` | `1` | 1: Dots for the steps in the empty part. |
| `max_ticks:` | `30` | More steps than this -> fewer dots |
| `enabled:` | `1` |  |
| `aria_label:` | `"Value"` | Used when labelText is empty |
| `value_format:` | `a block` | Text of the value |
| `on_change:` | `a block` | self.value (also while dragging) |
| `on_change_end:` | `a block` | After a drag, a key step or a typed value |
| `style_name:` | `"light"` | "light" ("classic": its old name), "dark", "modern", "ozden", "minimal", "minimalDark" or a name added to SliderField.styles |
| `style:` | `{...}` | The base of every package (a light gray field with a gray fill): a package changes only some keys |

## SmartButton

`SmartButton(...)` makes the SmartButton of the kit (comp/smart-button.js).

`style_name:` `"minimal"`, `"minimalDanger"`, `"minimalDangerDark"`, `"minimalDark"`, `"outlined"`, `"ozden"`, `"ozden2"`, `"ozden2Dark"`, `"ozden3"`, `"ozden3Dark"`, `"ozden4"`, `"ozden4Dark"`, `"ozdenDark"`, `"pill"`.

A dark window gives it its dark look.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `cancel_ask`, `press`, `remove`, `set_animated`, `set_ask`, `set_enabled`, `set_icon`, `set_label_text`, `set_ripple`, `set_style`, `set_tone`, `set_waiting`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` |  |
| `style_name:` | `"ozden" (the kit alone: "ozden")` | the template (SmartButton.styles): "ozden" (the default) ... "ozden4", "pill", "outlined", "ozdenDark" ... "ozden4Dark", "minimal", "minimalDark", "minimalDanger", "minimalDangerDark" |
| `tone:` | `""` | a color of the kit (SmartButton.tones): "white", "cyan", "orange", "yellow", "green", "blue", "cyanDark"..., "ink" / "inkDark" (minimal). "": the gray of the template. setTone() |
| `width:` | `"auto"` | an icon button (labelText: "") is a square |
| `height:` | `44` | "auto": as high as its padding and content (an icon on top of a text is "auto") |
| `label_text:` | `"Button"` | "": an icon button |
| `allow_html:` | `0` | 1: labelText is HTML (only for your own texts) |
| `icon_file:` | `""` | "": no icon (Ex: "comp/smart-button/alert-black.png") |
| `icon_position:` | `"left"` | "left", "top" |
| `enabled:` | `1` | 0: gray, can not be pressed (set later with setEnabled) |
| `aria_label:` | `""` | "": labelText is read. An icon button needs it (Ex: "Delete") |
| `waiting:` | `0` | 1: it waits (set later with setWaiting) |
| `waiting_type:` | `"clock"` | "clock" (the default wait) or "dots" |
| `animated:` | `1` | 1: pressed it gets smaller and darker (style.press). setAnimated() |
| `ripple:` | `0` | 1: a wave from the pressed point (it works with animated: 0 too). setRipple() |
| `ask:` | `""` | "Click again to delete.": two clicks (the first one asks with an orange button and this text in a bubble). setAsk() |
| `on_before_click:` | `a block` | function (self): false stops the press, with no ask either |
| `on_click:` | `a block` | Not called while waiting |
| `on_waiting_end:` | `a block` | The wait ended (setWaiting(0)) |
| `style:` | `{...}` | ozden (the default template) |

## SmartTable

`SmartTable(...)` makes the SmartTable of the kit (comp/smart-table.js).

When to use it: to show very big data well, in both directions: very many rows (only the rows that are seen are made) and very many columns (it scrolls sideways).

`style_name:` `"classic"`, `"dark"`, `"green"`, `"light"`, `"minimal"`, `"minimalDark"`.

A dark window gives it its dark look.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `clear_column_highlight`, `clear_selection`, `filter_and_sort_data`, `generate_test_data`, `get_selected_index`, `get_total_width`, `get_vertical_scroll_width`, `remove`, `reset_sort_icons`, `scroll_page`, `select_item`, `select_next_search_title`, `set_can_select`, `set_fit_line_count`, `set_height`, `set_item_data_list`, `set_item_height`, `set_item_line_count`, `set_locale`, `set_scroll_to_top`, `set_search_title_index`, `set_show_cell_tooltip`, `set_show_search_title_select`, `set_state`, `set_title_cell_width`, `set_title_data_list`, `set_vertical_scroll_enabled`, `set_wheel_scroll`, `set_width`, `show_loading`, `stretch_last_cell`, `sync_scroll_position`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` |  |
| `title_height:` | `50` |  |
| `item_height:` | `40` |  |
| `info_height:` | `50` |  |
| `item_line_count:` | `16` |  |
| `highlight_title:` | `true` |  |
| `highlight_line:` | `true` |  |
| `invert_color:` | `0` |  |
| `no_data_found_alert:` | `"No data found!"` |  |
| `search_keyword:` | `""` |  |
| `search_title_index:` | `-1` | -1: Search in all columns (ALL). 0, 1...: Search only in this column. |
| `show_search_title_select:` | `1` | 0: Hide the column select box (ALL) next to the search input. |
| `wheel_scroll:` | `0` | 1: The mouse wheel scrolls the rows (and the page does not scroll). 0: The wheel is left to the page. |
| `allow_html:` | `0` | 1: The cell values, the titles of the columns and the texts are written as HTML. 0: As plain text (safe for the text of the users) |
| `show_cell_tooltip:` | `1` | 1: a cell whose text does not fit shows all of it in a bubble (comp/tooltip.js). 0: no bubble |
| `all_titles_text:` | `"ALL"` |  |
| `can_select:` | `1` | 1: a click or a key selects a row; Enter runs onSelect. 0: no selection, no keys |
| `fit_line_count:` | `0` | 1: rows of about itemHeight px, as many as the height of the table holds |
| `locale:` | `""` | the numbers of the info line ("": the language of the page). Ex: "en-US", "tr-TR" |
| `sort_by_title_index:` | `0` |  |
| `sort_direction:` | `"A-Z"` | "A-Z" or "Z-A" |
| `fill_test_data:` | `0` |  |
| `on_select:` | `a block` |  |
| `title_data_list:` | `[...]` | Ex: { name: "ID", dataTitle: "id", dataType: "integer", width: 100, sortable: 1 } |
| `item_data_list:` | `[...]` | Ex: { id: 1, name: "Bugra", desc: "about", email: "emainil", active: 1 } |
| `scroll_bar_params:` | `{...}` |  |
| `search_title_menu_params:` | `{}` |  |
| `search_input_params:` | `{...}` |  |
| `style_name:` | `"light"` | "light" ("classic": its old name), "dark", "green", "minimal", "minimalDark" or a name added to SmartTable.styles |
| `style:` | `{...}` | Light style package (default): the look of DataTable "light" |

## SortableList

`SortableList(...)` makes the SortableList of the kit (comp/sortable-list.js).

`style_name:` `"classic"`, `"dark"`, `"light"`, `"modern"`.

A dark window gives it its dark look.

Read without a question to the page: `obj.order`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `add_item`, `focus_item`, `get_index_by_key`, `get_items`, `get_keys`, `move_down`, `move_item`, `move_up`, `remove`, `remove_item`, `set_enabled`, `set_items`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` |  |
| `width:` | `340` |  |
| `height:` | `320` | "auto": grows with the rows (no scrolling) |
| `items:` | `[]` | Strings or { key, text, description, locked } (style.desc is the look of the description) |
| `drag_by:` | `"handle"` | "handle": drag by the grip at the left, "row": drag by the whole row (touch: the list then scrolls only by the scroll bar) |
| `show_handle:` | `1` | The grip at the left. (dragBy: "row" can hide it) |
| `show_numbers:` | `1` | Position numbers |
| `show_buttons:` | `0` | Up / down buttons |
| `removable:` | `0` | A remove button and the Delete key |
| `enabled:` | `1` |  |
| `row_gap:` | `6` | Space between the rows |
| `empty_text:` | `"No items"` |  |
| `use_scroll_bar:` | `1` | basic/scroll-bar.js. 0: the scrollbar of the browser. |
| `aria_label:` | `"Sortable list"` |  |
| `texts:` | `{...}` |  |
| `on_change:` | `a block` | self.getItems() for the new order |
| `on_remove:` | `a block` |  |
| `on_item_click:` | `a block` |  |
| `on_drag_start:` | `a block` |  |
| `on_drag_end:` | `a block` | index: the new position |
| `style_name:` | `"light"` | "light" ("classic": its old name), "modern", "dark" or a name added to SortableList.styles |
| `style:` | `{...}` | Light style package (default) |

## SparkLineBox

`SparkLineBox(...)` makes the SparkLineBox of the kit (comp/spark-line-box.js).

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `add_value`, `clear`, `get_last_value`, `get_values`, `set_icon`, `set_line_color`, `set_max_points`, `set_max_value`, `set_min_value`, `set_title_text`, `set_trend_text`, `set_value_text`, `set_values`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` |  |
| `width:` | `200` |  |
| `height:` | `80` |  |
| `title_text:` | `"Sold Items"` |  |
| `value_text:` | `"1.3K"` |  |
| `allow_html:` | `0` | 1: titleText, valueText, trendText and the text of valueFormat are HTML (only for your own texts) |
| `icon_file:` | `""` | "": No icon |
| `line_color:` | `"tomato"` |  |
| `values:` | `[]` | [10, 20, { value: 15, color: "orange" }] |
| `max_points:` | `30` | How many values are shown |
| `min_value:` | `null` | null: Auto. 0: The base line is always zero. |
| `max_value:` | `0` | 0: Auto (the biggest visible value is the top of the graph) |
| `curve:` | `"smooth"` | "smooth", "linear" |
| `show_area:` | `1` | 1: Light fill under the line |
| `show_last_dot:` | `1` | 1: A dot on the last value |
| `show_min_max:` | `0` | 1: Dots on the smallest and the biggest value |
| `show_trend:` | `1` | 1: Trend badge (last value compared with the first visible value) |
| `trend_text:` | `""` | Your own badge text. "": Calculated. (Ex: "▲ 12%") |
| `show_tooltip:` | `1` | 1: Tooltip with the value on mouse over |
| `animated:` | `1` | 1: The line moves with a short motion when a value is added. |
| `value_format:` | `a block` | Tooltip text |
| `on_click:` | `a block` |  |
| `style:` | `{...}` |  |

## Splitter

`Splitter(...)` makes the Splitter of the kit (comp/splitter.js).

`style_name:` `"dark"`, `"light"`, `"minimal"`, `"minimalDark"`.

A dark window gives it its dark look.

Read without a question to the page: `obj.first_size_now`.

Objects go into it with `splitter.first { ... } and splitter.second { ... }`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `get_first_size`, `set_area_visible`, `set_first_size`, `set_theme`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` | Your name for this object: read it in a callback (self.key) |
| `left:` | `0` |  |
| `top:` | `0` |  |
| `width:` | `"100%"` |  |
| `height:` | `"100%"` |  |
| `direction:` | `"horizontal"` | "horizontal": side by side, "vertical": one under the other |
| `first_size:` | `"30%"` | px or a part of the box |
| `second_size:` | `null` | px or a part of the box: the second area keeps its size (firstSize is not used) |
| `min_first:` | `60` | px |
| `min_second:` | `60` | px |
| `key_step:` | `16` | px: an arrow key moves the line this much |
| `aria_label:` | `"Change the sizes of the areas"` |  |
| `on_change:` | `a block` | The line moves. (Not at create time, not with silent: 1) |
| `on_change_end:` | `a block` | The line is let go. |
| `style_name:` | `"light"` | "light", "dark", "minimal", "minimalDark" or a name added to Splitter.styles |
| `style:` | `{...}` | Light style package (default) |

## StatusBar

`StatusBar(...)` makes the StatusBar of the kit (comp/status-bar.js).

`style_name:` `"dark"`, `"light"`, `"minimal"`, `"minimalDark"`.

A dark window gives it its dark look.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `get_item`, `set_busy`, `set_item_text`, `set_item_visible`, `set_items`, `set_message_text`, `set_theme`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` | Your name for this object: read it in a callback (self.key) |
| `left:` | `0` |  |
| `width:` | `"100%"` |  |
| `height:` | `28` |  |
| `message_text:` | `""` |  |
| `message_tone:` | `""` | "", "success", "warn", "error", "info" |
| `items:` | `[]` | [{ key, text, icon, tone, ariaLabel, onClick }, "Text"] |
| `busy:` | `0` |  |
| `aria_label:` | `"Status bar"` |  |
| `style_name:` | `"light"` | "light", "dark", "minimal", "minimalDark" or a name added to StatusBar.styles |
| `style:` | `{...}` | Light style package (default) |

## StepBar

`StepBar(...)` makes the StepBar of the kit (comp/step-bar.js).

`style_name:` `"dark"`, `"light"`, `"minimal"`, `"minimalDark"`.

A dark window gives it its dark look.

Read without a question to the page: `obj.step`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `get_step`, `next`, `previous`, `set_step`, `set_steps`, `set_theme`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` | Your name for this object: read it in a callback (self.key) |
| `left:` | `0` |  |
| `top:` | `0` |  |
| `width:` | `"100%"` |  |
| `height:` | `"auto"` |  |
| `steps:` | `[]` | [STEP]: a text or { key, text, description } |
| `current_step:` | `0` | The step of now, from 0. steps.length: every step is done. |
| `can_go_back:` | `1` | 1: a step that is behind can be clicked (onStepClick) |
| `show_titles:` | `1` |  |
| `aria_label:` | `"Steps"` |  |
| `on_step_click:` | `a block` | A step that is behind was chosen. setStep() goes there. |
| `style_name:` | `"light"` | "light", "dark", "minimal", "minimalDark" or a name added to StepBar.styles |
| `style:` | `{...}` | Light style package (default) |

## Stepper

`Stepper(...)` makes the Stepper of the kit (comp/stepper.js).

`style_name:` `"classic"`, `"dark"`, `"light"`, `"minimal"`, `"minimalDark"`, `"modern"`, `"ozden"`, `"ozdenDark"`.

A dark window gives it its dark look.

Read without a question to the page: `obj.value`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `decrease`, `focus`, `format_number`, `get_value`, `increase`, `set_enabled`, `set_max_value`, `set_min_value`, `set_precision`, `set_range`, `set_step`, `set_unit_text`, `set_value`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` |  |
| `width:` | `150` |  |
| `height:` | `44` |  |
| `value:` | `1` |  |
| `min_value:` | `0` |  |
| `max_value:` | `10` |  |
| `step:` | `1` |  |
| `precision:` | `0` | Decimals shown and used for rounding. (step: 0.5 -> precision: 1) |
| `unit_text:` | `""` | After the value. Ex: " kg" (with the space) |
| `editable:` | `1` | 1: The value can be typed. |
| `wrap:` | `0` | 1: After max comes min, before min comes max. |
| `hold_to_repeat:` | `1` | 1: Press and hold a button to change the value continuously. |
| `layout:` | `"horizontal"` | "horizontal": [-] value [+], "compact": value [-+] stacked at the right (Only at create time) |
| `enabled:` | `1` |  |
| `aria_label:` | `"Value"` |  |
| `value_format:` | `a block` | a format text, made by the page at once: "{:,.2f} TL", "{:.0f} kg", "{:.1%}" (not a block) |
| `on_change:` | `a block` | self.value |
| `on_min_reached:` | `a block` | Called when the value arrives at min |
| `on_max_reached:` | `a block` | Called when the value arrives at max |
| `style_name:` | `"light"` | "light" ("classic": its old name), "modern", "dark", "ozden", "ozdenDark", "minimal", "minimalDark" or a name added to Stepper.styles |
| `style:` | `{...}` | Light style package (default) |

## Tabs

`Tabs(...)` makes the Tabs of the kit (comp/tabs.js).

`style_name:` `"classic"`, `"dark"`, `"light"`, `"minimal"`, `"minimalDark"`, `"modern"`.

A dark window gives it its dark look.

Read without a question to the page: `obj.previous_value`, `obj.value`.

Objects go into it with `tabs.panel(key) { ... }`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `add_tab`, `end_panel`, `focus`, `get_active_tab`, `get_index`, `get_panel`, `get_tab`, `get_tabs`, `get_value`, `remove_tab`, `set_badge`, `set_count`, `set_enabled`, `set_panel_content`, `set_tab_enabled`, `set_tabs`, `set_value`, `start_panel`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` | Your name for this object: read it in a callback (self.key) |
| `width:` | `"100%" (the kit alone: "auto")` |  |
| `height:` | `"auto"` |  |
| `tabs:` | `[]` | [{ key, text, iconFile, count, badge, disabled, closable, selectedColor, selectedTextColor, selectedIconFile }] or ["A", "B"] |
| `value:` | `null` | Key of the active tab. null: the first enabled tab. |
| `variant:` | `"underline"` | "underline", "pill" (Only at create time) |
| `vertical:` | `0` | 1: Tabs are stacked. (Only at create time) |
| `full_width:` | `0` | 1: Tabs share the bar width equally. (Only at create time) |
| `closable:` | `0` | 1: Every tab has a close (x) button. (A tab can also set its own "closable".) |
| `add_button:` | `0` | 1: "+" button at the end of the bar. |
| `show_arrows:` | `"auto"` | "auto": Arrow buttons when the tabs do not fit. 0: Never. |
| `panels:` | `1 (the kit alone: 0)` | 1: A content Box for every tab. (Only at create time) |
| `panel_height:` | `"auto"` | Height of the panels area. Ex: 300 or "auto" (grows with the content) |
| `bar_width:` | `200` | vertical + panels: Width of the tab bar. (The panels take the rest.) |
| `scale:` | `null` | Multiplies every size. null: basic.uiScale (1, or 1 / page.zoom on a fitted page). (Only at create time) |
| `enabled:` | `1` |  |
| `aria_label:` | `"Tabs"` |  |
| `on_change:` | `a block` | self.value, self.previousValue, self.getActiveTab() |
| `on_close:` | `a block` | Return false to keep the tab. |
| `on_add:` | `a block` |  |
| `style_name:` | `"light"` | "light" ("classic": its old name), "modern", "dark", "minimal", "minimalDark" or a name added to Tabs.styles |
| `style:` | `{...}` | Light style package (default) |

## TagInput

`TagInput(...)` makes the TagInput of the kit (comp/tag-input.js).

`style_name:` `"classic"`, `"dark"`, `"light"`, `"minimal"`, `"minimalDark"`, `"modern"`.

A dark window gives it its dark look.

Read without a question to the page: `obj.tags`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `add_tag`, `blur`, `clear`, `focus`, `get_tags`, `remove_tag`, `set_enabled`, `set_max_tags`, `set_placeholder`, `set_suggestions`, `set_tags`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` |  |
| `width:` | `320` |  |
| `height:` | `"auto"` |  |
| `tags:` | `[]` | ["audio", "guide"] |
| `suggestions:` | `[]` | ["audio", "fitness", ...] Shown while typing. (Tags that are already added are hidden.) |
| `allow_custom:` | `1` | 0: Only the suggestions can be added. |
| `show_suggestions_on_focus:` | `0` | 1: The suggestion list opens also when the input is empty. |
| `max_suggestions:` | `8` |  |
| `max_tags:` | `0` | 0: No limit |
| `min_length:` | `1` |  |
| `max_length:` | `32` |  |
| `lowercase:` | `0` | 1: "Audio" -> "audio" |
| `separators:` | `","` | Characters that end a tag while typing and when a text is pasted. (Enter always works.) |
| `placeholder:` | `"Add a tag..."` |  |
| `empty_text:` | `"No suggestions"` | Suggestion list, when the typed text does not match. (allowCustom: 0) |
| `enabled:` | `1` |  |
| `aria_label:` | `"Tags"` |  |
| `validate:` | `a block` | Returns an error text, or "" when the tag is ok. |
| `on_change:` | `a block` | self.getTags() |
| `on_add:` | `a block` |  |
| `on_remove:` | `a block` |  |
| `on_reject:` | `a block` | reason: "duplicate", "max", "short", "long", "notAllowed", "invalid" (or the validate() text) |
| `messages:` | `{...}` |  |
| `style_name:` | `"light"` | "light" ("classic": its old name), "modern", "dark", "minimal", "minimalDark" or a name added to TagInput.styles |
| `style:` | `{...}` | Light style package (default) |

## TextAreaField

`TextAreaField(...)` makes the TextAreaField of the kit (comp/text-area-field.js).

A dark window gives it its dark look.

Read without a question to the page: `obj.text`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `blur_func`, `check_if_input_is_required_and_empty`, `check_input_value`, `focus_func`, `get_value`, `input_func`, `is_valid`, `set_background_color`, `set_description_text`, `set_focus_background_color`, `set_focus_line_color`, `set_line_color`, `set_max_length`, `set_placeholder`, `set_required`, `set_required_icon`, `set_required_text`, `set_title_text`, `set_unit_text`, `set_value`, `set_warning_color`, `set_warning_icon`, `set_warning_text`, `show_warning_if_not_valid`.

| Param | Default | The kit says |
|---|---|---|
| `type:` | `"textarea"` |  |
| `title_text:` | `"" (the kit alone: "MESSAGE")` |  |
| `placeholder:` | `"" (the kit alone: "How can we help you?")` |  |
| `required:` | `0 (the kit alone: 1)` |  |
| `min_char_count:` | `0 (the kit alone: 80)` | 0, 80 |
| `show_count:` | `0 (the kit alone: 1)` | 0, 1 |
| `length_text:` | `"length: "` |  |
| `warning_text:` | `"" (the kit alone: "The entered text must be longer than 80")` |  |
| `warning_color:` | `"#E5885E"` |  |
| `max_length:` | `100000 (the kit alone: 255)` |  |
| `height:` | `170` | 170 (4line) |
| `right_padding:` | `5` |  |
| `unit_style:` | `{...}` |  |
| `scroll_bar_style:` | `{...}` | The scroll bar of the text (the params of ScrollBar) |
| `key:` | `"0"` |  |
| `style_name:` | `"light" (the kit alone: "light")` | "light", "dark", "modern" ("classic": its old name), "modernDark", "ozden", "ozdenDark", "minimal", "minimalDark" or a name added to TextField.styles |
| `width:` | `350` |  |
| `left_padding:` | `20` |  |
| `title_font_size:` | `16` |  |
| `input_font_size:` | `20` |  |
| `input_height:` | `40` | px: the row of the text |
| `field_padding:` | `14` | px: over and under the title and the text (titlePosition "inside") |
| `description_font_size:` | `14` |  |
| `title_position:` | `"inside"` | "inside": the title in the field, over the text. "above": the title over the field (the field is only the row of the text). (Only at create time) |
| `title_gap:` | `4` | px between the title and the field (titlePosition "above") |
| `value:` | `""` |  |
| `show_description:` | `0` |  |
| `description_text:` | `""` |  |
| `allow_html:` | `0` | 1: titleText, descriptionText and unitText are HTML (only for your own texts) |
| `background_color:` | `"#F6F6F6"` |  |
| `focus_background_color:` | `"#F3F4E0"` |  |
| `hover_background_color:` | `""` | the field under the mouse (not while it is selected). "": no change |
| `line_color:` | `"#373836"` |  |
| `focus_line_color:` | `"#65A293"` |  |
| `back_border_color:` | `Black(0)` |  |
| `focus_back_border_color:` | `Black(0)` |  |
| `hover_back_border_color:` | `""` | the edge under the mouse (not while it is selected). "": no change |
| `back_border_top_round:` | `2` |  |
| `back_border_bottom_round:` | `0` |  |
| `title_text_color:` | `"#555555"` |  |
| `title_bold:` | `0` | 1: the title in bold (opensans-bold) |
| `title_letter_spacing:` | `""` | "": normal. Ex: "0.06em" |
| `input_text_color:` | `"#373836"` |  |
| `input_color_scheme:` | `""` | "": the page's. "dark": the autofill colors of the browser stay dark (on a dark field) |
| `placeholder_color:` | `""` | "": the color of the browser |
| `description_text_color:` | `"#999999"` |  |
| `warning_ball_border_color:` | `"#373836"` |  |
| `required_text:` | `"Required"` |  |
| `required_color:` | `"white"` |  |
| `animated_warning_ball:` | `1` |  |
| `warning_ball_type:` | `"color"` | "color": colored ball, "icon": icon image |
| `warning_ball_size:` | `16` | px: the colored ball (warningBallType "color") |
| `warning_ball_border:` | `2` | px: the edge of the colored ball (warningBallBorderColor) |
| `warning_border_color:` | `""` | the edge of the field while it shows a warning (not while typing). "": no change |
| `warning_icon_size:` | `20` |  |
| `required_icon_file:` | `""` | image path or data URI. "": built-in icon |
| `warning_icon_file:` | `""` | image path or data URI. "": built-in icon |
| `required_icon_color:` | `"#373836"` | built-in required icon color (built-in warning icon uses warningColor) |
| `tooltip_style:` | `{...}` |  |
| `select_style:` | `{...}` |  |
| `show_left_box:` | `0` |  |
| `show_right_box:` | `0` |  |
| `show_unit:` | `0` |  |
| `create_input:` | `1` |  |
| `unit_text:` | `""` |  |
| `on_focus:` | `a block` |  |
| `on_blur:` | `a block` |  |
| `on_change:` | `a block` | the user changed the text (not at create time, not by setValue()) |

## TextField

`TextField(...)` makes the TextField of the kit (comp/text-field.js).

`style_name:` `"classic"`, `"dark"`, `"light"`, `"minimal"`, `"minimalDark"`, `"modern"`, `"modernDark"`, `"ozden"`, `"ozdenDark"`.

A dark window gives it its dark look.

Read without a question to the page: `obj.text`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `blur_func`, `check_if_input_is_required_and_empty`, `check_input_value`, `focus_func`, `get_value`, `input_func`, `is_valid`, `set_background_color`, `set_description_text`, `set_focus_background_color`, `set_focus_line_color`, `set_line_color`, `set_max_length`, `set_placeholder`, `set_required`, `set_required_icon`, `set_required_text`, `set_title_text`, `set_unit_text`, `set_value`, `set_warning_color`, `set_warning_icon`, `set_warning_text`, `show_warning_if_not_valid`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` |  |
| `style_name:` | `"light" (the kit alone: "light")` | "light", "dark", "modern" ("classic": its old name), "modernDark", "ozden", "ozdenDark", "minimal", "minimalDark" or a name added to TextField.styles |
| `type:` | `"text"` |  |
| `width:` | `350` |  |
| `height:` | `"auto"` |  |
| `left_padding:` | `20` |  |
| `right_padding:` | `60` |  |
| `title_font_size:` | `16` |  |
| `input_font_size:` | `20` |  |
| `input_height:` | `40` | px: the row of the text |
| `field_padding:` | `14` | px: over and under the title and the text (titlePosition "inside") |
| `description_font_size:` | `14` |  |
| `title_position:` | `"inside"` | "inside": the title in the field, over the text. "above": the title over the field (the field is only the row of the text). (Only at create time) |
| `title_gap:` | `4` | px between the title and the field (titlePosition "above") |
| `title_text:` | `"" (the kit alone: "INPUT NAME")` |  |
| `placeholder:` | `"" (the kit alone: "input value")` |  |
| `value:` | `""` |  |
| `max_length:` | `1000 (the kit alone: 30)` |  |
| `show_description:` | `0` |  |
| `description_text:` | `""` |  |
| `allow_html:` | `0` | 1: titleText, descriptionText and unitText are HTML (only for your own texts) |
| `background_color:` | `"#F6F6F6"` |  |
| `focus_background_color:` | `"#F3F4E0"` |  |
| `hover_background_color:` | `""` | the field under the mouse (not while it is selected). "": no change |
| `line_color:` | `"#373836"` |  |
| `focus_line_color:` | `"#65A293"` |  |
| `back_border_color:` | `Black(0)` |  |
| `focus_back_border_color:` | `Black(0)` |  |
| `hover_back_border_color:` | `""` | the edge under the mouse (not while it is selected). "": no change |
| `back_border_top_round:` | `2` |  |
| `back_border_bottom_round:` | `0` |  |
| `title_text_color:` | `"#555555"` |  |
| `title_bold:` | `0` | 1: the title in bold (opensans-bold) |
| `title_letter_spacing:` | `""` | "": normal. Ex: "0.06em" |
| `input_text_color:` | `"#373836"` |  |
| `input_color_scheme:` | `""` | "": the page's. "dark": the autofill colors of the browser stay dark (on a dark field) |
| `placeholder_color:` | `""` | "": the color of the browser |
| `description_text_color:` | `"#999999"` |  |
| `warning_ball_border_color:` | `"#373836"` |  |
| `required:` | `0 (the kit alone: 0)` |  |
| `required_text:` | `"Required"` |  |
| `required_color:` | `"white"` |  |
| `warning_text:` | `"Invalid value format"` |  |
| `warning_color:` | `"#E5885E"` |  |
| `animated_warning_ball:` | `1` |  |
| `warning_ball_type:` | `"color"` | "color": colored ball, "icon": icon image |
| `warning_ball_size:` | `16` | px: the colored ball (warningBallType "color") |
| `warning_ball_border:` | `2` | px: the edge of the colored ball (warningBallBorderColor) |
| `warning_border_color:` | `""` | the edge of the field while it shows a warning (not while typing). "": no change |
| `warning_icon_size:` | `20` |  |
| `required_icon_file:` | `""` | image path or data URI. "": built-in icon |
| `warning_icon_file:` | `""` | image path or data URI. "": built-in icon |
| `required_icon_color:` | `"#373836"` | built-in required icon color (built-in warning icon uses warningColor) |
| `tooltip_style:` | `{...}` |  |
| `select_style:` | `{...}` |  |
| `show_left_box:` | `0` |  |
| `show_right_box:` | `0` |  |
| `show_unit:` | `0` |  |
| `create_input:` | `1` |  |
| `unit_text:` | `""` |  |
| `unit_style:` | `{...}` |  |
| `on_focus:` | `a block` |  |
| `on_blur:` | `a block` |  |
| `on_change:` | `a block` | the user changed the text (not at create time, not by setValue()) |
| `on_enter:` | | the Enter key: a block or a lambda that gets the field |

## TimeLine

`TimeLine(...)` makes the TimeLine of the kit (comp/time-line.js).

`style_name:` `"dark"`, `"light"`, `"minimal"`, `"minimalDark"`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `add_item`, `clear`, `get_items`, `set_enabled`, `set_items`, `set_theme`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` |  |
| `width:` | `320` | A number or "100%". (The height always grows with the items.) |
| `items:` | `[]` | [{ time, text, description, color, key, data }] or ["Order created"] |
| `item_gap:` | `20` | Space between two items. (The line is drawn in it.) |
| `dot_size:` | `12` |  |
| `line_width:` | `2` |  |
| `show_line:` | `1` | 0: Only the dots. |
| `clickable_items:` | `0` | 1: An item can be clicked. (onClick) |
| `enabled:` | `1` |  |
| `on_click:` | `a block` |  |
| `style_name:` | `"light"` | "light", "dark", "minimal", "minimalDark" or a name added to TimeLine.styles |
| `style:` | `{...}` | Light style package (default) |

## TimePicker

`TimePicker(...)` makes the TimePicker of the kit (comp/time-picker.js).

`style_name:` `"classic"`, `"dark"`, `"light"`, `"minimal"`, `"minimalDark"`.

A dark window gives it its dark look.

Read without a question to the page: `obj.value`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `close`, `get_time`, `is_open`, `open`, `set_enabled`, `set_max_time`, `set_min_time`, `set_minute_step`, `set_time`, `toggle`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` |  |
| `width:` | `160` | Field width (not used if inline: 1) |
| `height:` | `44` | Field height (not used if inline: 1) |
| `time:` | `null` | "HH:mm", Date or null |
| `min_time:` | `null` | "HH:mm" or null |
| `max_time:` | `null` | "HH:mm" or null. If it is smaller than minTime, the range goes over midnight. |
| `minute_step:` | `5` | 1, 5, 10, 15, 30... |
| `format:` | `"HH:mm"` | Tokens: HH, H, hh, h, mm, A (AM/PM), a (am/pm) |
| `language:` | `"en"` | "en", "tr" |
| `placeholder:` | `""` | Empty: uses the language text |
| `inline:` | `0` | 1: Panel is always visible, no field. |
| `enabled:` | `1` |  |
| `close_on_select:` | `1` | 1: Close after a minute is selected. |
| `use_scroll_bar:` | `1` | basic/scroll-bar.js. 0: the scrollbar of the browser. |
| `show_now_button:` | `1` |  |
| `show_clear_button:` | `1` |  |
| `on_change:` | `a block` | self.value ("19:30" or ""), self.hours, self.minutes (number or null), self.timeText |
| `on_open:` | `a block` |  |
| `on_close:` | `a block` |  |
| `style_name:` | `"light"` | "light" ("classic": its old name), "dark", "minimal", "minimalDark" or a name added to TimePicker.styles |
| `style:` | `{...}` | Light style package (default) |

## TinySelect

`TinySelect(...)` makes the TinySelect of the kit (comp/tiny-select.js).

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `get_index_by_value`, `get_selected_item`, `remove`, `set_color`, `set_enabled`, `set_list`, `set_selected_index`, `set_title_text`.

| Param | Default | The kit says |
|---|---|---|
| `title_text:` | `""` |  |
| `list:` | `[]` | [{ value: "1", label: "(none)" },] |
| `on_change:` | `a block` | Another item is chosen: self.selectedIndex, self.getSelectedItem() ({ value, label }). Not at create time; setSelectedIndex(index) calls it, setSelectedIndex(index, 1) does not. |
| `selected_index:` | `0` |  |
| `font_size:` | `20` |  |
| `border:` | `0` |  |
| `color:` | `"transparent"` | "whitesmoke" |
| `round:` | `3` |  |
| `width:` | `"auto"` |  |
| `height:` | `50` |  |
| `padding_x:` | `12` |  |
| `enabled:` | `1` | 0: it can not be opened, a little transparent (setEnabled) |
| `arrow_icon_file:` | `"data:image/svg+xml;utf8," + encodeURIComponent('<svg xml...` |  |
| `arrow_border:` | `0` | 1 |
| `arrow_border_color:` | `"rgba(0, 0, 0, 0.2)"` |  |
| `arrow_background_color:` | `"transparent"` | "white" |
| `arrow_round:` | `3` | 30 |
| `arrow_size:` | `24` |  |
| `list_font_size:` | `14` |  |
| `list_text_color:` | `"rgba(0, 0, 0, 0.8)"` |  |
| `list_over_text_color:` | `"indianred"` |  |
| `list_background_color:` | `"whitesmoke"` |  |
| `list_border:` | `1` |  |
| `list_border_color:` | `"rgba(0, 0, 0, 0.6)"` |  |
| `empty_text:` | `"Empty"` |  |
| `allow_html:` | `0` | 1: titleText, emptyText and the labels of the list are HTML (only for your own texts) |
| `invert_icon_color:` | `0` |  |
| `label_bold:` | `1` |  |
| `label_text_color:` | `"rgba(0,0,0,0.8)"` |  |

## TinyTable

`TinyTable(...)` makes the TinyTable of the kit (comp/tiny-table.js).

When to use it: a small table between the lines of a page, like a table in a text, for small data that needs nothing more: it has no sorting, no search and no selection.

`style_name:` `"classic"`, `"dark"`, `"light"`.

A dark window gives it its dark look.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `set_rows`.

| Param | Default | The kit says |
|---|---|---|
| `width:` | `"auto"` | As wide as the columns |
| `height:` | `"auto"` |  |
| `columns:` | `[]` | [{ title, width (px), align: "left" \| "center" \| "right" }] |
| `rows:` | `[]` | [["text", "text", ...], ...] |
| `body_height:` | `"auto"` | "auto" or a number: the rows scroll |
| `allow_html:` | `0` | 1: the titles and the cells are HTML (only for your own texts) |
| `on_cell_create:` | `a block` | cell.rowIndex, cell.columnIndex, cell.value, cell.label (Ex: cell.label.bold = 1) |
| `on_row_click:` | `a block` |  |
| `style_name:` | `"classic"` | "classic", "light", "dark" or a name added to TinyTable.styles |
| `style:` | `{...}` | Classic style package (default) |

## Toggle

`Toggle(...)` makes the Toggle of the kit (comp/toggle.js).

`style_name:` `"badge"`, `"classic"`, `"dark"`, `"float"`, `"label"`, `"light"`, `"minimal"`, `"minimalDark"`, `"outline"`, `"ozden"`, `"ozdenDark"`, `"round"`, `"slim"`, `"square"`, `"tick"`.

A dark window gives it its dark look.

Read without a question to the page: `obj.value`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `set_animated`, `set_background_selected_color`, `set_marks`, `set_second_state`, `set_state`, `set_value`, `switch`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` |  |
| `width:` | `70` | Standard box features are added automatically. |
| `height:` | `40` |  |
| `spacing:` | `3` | px: between the track and the knob |
| `value:` | `0` |  |
| `invert_color:` | `0` |  |
| `off_button_scale:` | `0.6` | The size of the knob when off. (1: the same size as on) |
| `on_mark:` | `a block` | Shows when on: "check", "cross" or a text ("ON"). "": nothing |
| `off_mark:` | `""` | Shows when off |
| `mark_place:` | `"track"` | "track": on the free side of the track, "knob": in the knob (Only at create time) |
| `animated:` | `1` | 1: small motions of a toggle with marks. (box.setAnimated(0/1)) |
| `focus_ring_color:` | `""` | the ring of the keyboard focus. "": the ring of basic.js |
| `mark_style:` | `{...}` |  |
| `on_change:` | `a block` | self.value changed (a click, a key, setValue()). Not at create time, not with setValue(value, 1) |
| `background_style:` | `{...}` | The track |
| `button_style:` | `{...}` | The knob |
| `style_name:` | `"ozden"` | "ozden", "ozdenDark", "light", "dark", "classic", "float", "round", "slim", "outline", "square", "tick", "badge", "label", "minimal", "minimalDark" or a name added to Toggle.styles |
| `style:` | `{}` | WHY: the look is in the params above; the packages are packages of params (see Toggle.styles). |

## ToolBar

`ToolBar(...)` makes the ToolBar of the kit (comp/tool-bar.js).

`style_name:` `"dark"`, `"light"`, `"minimal"`, `"minimalDark"`.

A dark window gives it its dark look.

Read without a question to the page: `obj.checked_keys`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `click_item`, `close_menu`, `get_checked_keys`, `is_item_checked`, `remove`, `set_enabled`, `set_item_checked`, `set_item_enabled`, `set_item_hint`, `set_item_text`, `set_items`, `set_theme`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` | Your name for this object: read it in a callback (self.key) |
| `left:` | `0` |  |
| `top:` | `0` |  |
| `width:` | `"100%"` |  |
| `height:` | `42` |  |
| `shrink:` | `0 (the kit alone: 0)` | WHY: In a full group its row must not get thinner: its height is its buttons. |
| `items:` | `[]` | [ITEM] (See AN ITEM above) |
| `enabled:` | `1` |  |
| `aria_label:` | `"Tool bar"` |  |
| `more_text:` | `"More"` | The name of the "..." button |
| `on_click:` | `a block` | An item (with a click, the keyboard, its shortcut or clickItem()) |
| `style_name:` | `"light"` | "light", "dark", "minimal", "minimalDark" or a name added to ToolBar.styles |
| `style:` | `{...}` | Light style package (default) |

## Tooltip

`Tooltip(...)` makes the Tooltip of the kit (comp/tooltip.js).

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `hide_hint`, `remove`, `set_hint_text`, `set_lbl_color`.

| Param | Default | The kit says |
|---|---|---|
| `target:` | `null` |  |
| `hint_text:` | `""` |  |
| `hint_position:` | `"top"` | "top", "left", "bottom", "right" |
| `"lbl_fontSize" =>` | `12` |  |
| `"lbl_spaceX" =>` | `8` |  |
| `"lbl_spaceY" =>` | `3` |  |
| `"lbl_color" =>` | `"rgba(255, 255, 255, 0.90)"` |  |
| `"lbl_textColor" =>` | `"rgba(0, 0, 0, 0.85)"` |  |
| `"lbl_round" =>` | `3` |  |
| `"lbl_border" =>` | `1` |  |
| `"lbl_borderColor" =>` | `"rgba(0, 0, 0, 0.9)"` |  |
| `"lbl_arrow" =>` | `0` | px: the side of the arrow (0: no arrow) |
| `content:` | `null` | function (bubble): its own objects in the bubble, in place of hintText |
| `trigger:` | `"hover"` | "hover": it follows the mouse; "click": a popover (it stays, its content can be clicked) |
| `look:` | `null` | Tooltip.BUBBLE_LOOK keys over the lbl_ ones (Ex: { shadow, padding: [16, 14], contentGap }) |
| `style_name:` | `""` | a look of Tooltip.looks under look ("minimal", "minimalDark"). "": the lbl_ params |
| `scale:` | `null` | every size of the bubble multiplied (Ex: 1.5); null: basic.uiScale when the bubble opens |
| `visible:` | `0` |  |

## TreeView

`TreeView(...)` makes the TreeView of the kit (comp/tree-view.js).

`style_name:` `"classic"`, `"dark"`, `"light"`, `"minimal"`, `"minimalDark"`, `"modern"`.

A dark window gives it its dark look.

Read without a question to the page: `obj.previous_value`, `obj.value`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `add_node`, `collapse`, `collapse_all`, `expand`, `expand_all`, `focus`, `get_items`, `get_node`, `get_node_of_event`, `get_parent`, `get_path`, `get_row_elem`, `get_selected_node`, `remove_node`, `reveal`, `set_children`, `set_empty_text`, `set_enabled`, `set_items`, `set_value`, `toggle`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` |  |
| `width:` | `260` |  |
| `height:` | `320` | "auto": no scrolling, the tree grows with its rows. |
| `items:` | `[]` | [NODE] (See NODE above) |
| `value:` | `null` | Key of the selected node. null: nothing is selected. |
| `empty_text:` | `"No items"` |  |
| `type_ahead:` | `1` | 1: Typing a letter jumps to the next row that starts with it. |
| `use_scroll_bar:` | `1` | basic/scroll-bar.js (when it is loaded). 0: the scrollbar of the browser. |
| `enabled:` | `1` |  |
| `aria_label:` | `"Tree"` |  |
| `on_select:` | `a block` | self.value, self.previousValue |
| `on_activate:` | `a block` | Double click or Enter (event.type: "dblclick" or "keydown") |
| `toggle_on_double_click:` | `1` | 0: a double click does not open / close the row (Ex: it renames it) |
| `on_toggle:` | `a block` | node.expanded: 1 or 0 |
| `on_hover:` | `a block` | node: null when the mouse leaves the rows |
| `on_load_children:` | `a block` | hasChildren: 1 and no children. Call self.setChildren(node.key, [...]). |
| `style_name:` | `"light"` | "light" ("classic": its old name), "modern", "dark", "minimal", "minimalDark" or a name added to TreeView.styles |
| `style:` | `{...}` | Light style package (default) |

## UrlField

`UrlField(...)` makes the UrlField of the kit (comp/url-field.js).

A dark window gives it its dark look.

Read without a question to the page: `obj.text`.

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `blur_func`, `check_if_input_is_required_and_empty`, `check_input_value`, `focus_func`, `get_value`, `input_func`, `is_valid`, `set_background_color`, `set_description_text`, `set_focus_background_color`, `set_focus_line_color`, `set_line_color`, `set_max_length`, `set_placeholder`, `set_required`, `set_required_icon`, `set_required_text`, `set_title_text`, `set_unit_text`, `set_value`, `set_warning_color`, `set_warning_icon`, `set_warning_text`, `show_warning_if_not_valid`.

| Param | Default | The kit says |
|---|---|---|
| `width:` | `400` |  |
| `required:` | `0 (the kit alone: 1)` |  |
| `title_text:` | `"" (the kit alone: "URL")` |  |
| `placeholder:` | `"example.com"` |  |
| `warning_text:` | `"Invalid URL format"` |  |
| `warning_color:` | `"#E5885E"` |  |
| `max_length:` | `2048 (the kit alone: 255)` |  |
| `right_padding:` | `20` |  |
| `tiny_select_params:` | `{...}` |  |
| `key:` | `"0"` |  |
| `style_name:` | `"light" (the kit alone: "light")` | "light", "dark", "modern" ("classic": its old name), "modernDark", "ozden", "ozdenDark", "minimal", "minimalDark" or a name added to TextField.styles |
| `type:` | `"text"` |  |
| `height:` | `"auto"` |  |
| `left_padding:` | `20` |  |
| `title_font_size:` | `16` |  |
| `input_font_size:` | `20` |  |
| `input_height:` | `40` | px: the row of the text |
| `field_padding:` | `14` | px: over and under the title and the text (titlePosition "inside") |
| `description_font_size:` | `14` |  |
| `title_position:` | `"inside"` | "inside": the title in the field, over the text. "above": the title over the field (the field is only the row of the text). (Only at create time) |
| `title_gap:` | `4` | px between the title and the field (titlePosition "above") |
| `value:` | `""` |  |
| `show_description:` | `0` |  |
| `description_text:` | `""` |  |
| `allow_html:` | `0` | 1: titleText, descriptionText and unitText are HTML (only for your own texts) |
| `background_color:` | `"#F6F6F6"` |  |
| `focus_background_color:` | `"#F3F4E0"` |  |
| `hover_background_color:` | `""` | the field under the mouse (not while it is selected). "": no change |
| `line_color:` | `"#373836"` |  |
| `focus_line_color:` | `"#65A293"` |  |
| `back_border_color:` | `Black(0)` |  |
| `focus_back_border_color:` | `Black(0)` |  |
| `hover_back_border_color:` | `""` | the edge under the mouse (not while it is selected). "": no change |
| `back_border_top_round:` | `2` |  |
| `back_border_bottom_round:` | `0` |  |
| `title_text_color:` | `"#555555"` |  |
| `title_bold:` | `0` | 1: the title in bold (opensans-bold) |
| `title_letter_spacing:` | `""` | "": normal. Ex: "0.06em" |
| `input_text_color:` | `"#373836"` |  |
| `input_color_scheme:` | `""` | "": the page's. "dark": the autofill colors of the browser stay dark (on a dark field) |
| `placeholder_color:` | `""` | "": the color of the browser |
| `description_text_color:` | `"#999999"` |  |
| `warning_ball_border_color:` | `"#373836"` |  |
| `required_text:` | `"Required"` |  |
| `required_color:` | `"white"` |  |
| `animated_warning_ball:` | `1` |  |
| `warning_ball_type:` | `"color"` | "color": colored ball, "icon": icon image |
| `warning_ball_size:` | `16` | px: the colored ball (warningBallType "color") |
| `warning_ball_border:` | `2` | px: the edge of the colored ball (warningBallBorderColor) |
| `warning_border_color:` | `""` | the edge of the field while it shows a warning (not while typing). "": no change |
| `warning_icon_size:` | `20` |  |
| `required_icon_file:` | `""` | image path or data URI. "": built-in icon |
| `warning_icon_file:` | `""` | image path or data URI. "": built-in icon |
| `required_icon_color:` | `"#373836"` | built-in required icon color (built-in warning icon uses warningColor) |
| `tooltip_style:` | `{...}` |  |
| `select_style:` | `{...}` |  |
| `show_left_box:` | `0` |  |
| `show_right_box:` | `0` |  |
| `show_unit:` | `0` |  |
| `create_input:` | `1` |  |
| `unit_text:` | `""` |  |
| `unit_style:` | `{...}` |  |
| `on_focus:` | `a block` |  |
| `on_blur:` | `a block` |  |
| `on_change:` | `a block` | the user changed the text (not at create time, not by setValue()) |
| `on_enter:` | | the Enter key: a block or a lambda that gets the field |

## WebView

`WebView(...)` makes the WebView of the kit (comp/web-view.js).

Methods of the kit, as `obj.method_name(...)` in snake_case (its file tells what each takes): `clear`, `get_document`, `get_iframe`, `get_window`, `hide_error`, `is_loading_page`, `load`, `load_html`, `post_message`, `reload`, `remove`, `set_auto_height`, `set_interactive`, `set_scale`, `show_error`.

| Param | Default | The kit says |
|---|---|---|
| `key:` | `"0"` |  |
| `width:` | `400` |  |
| `height:` | `300` |  |
| `url:` | `""` | "": Nothing is loaded (placeholder is shown) |
| `html_text:` | `""` | HTML text instead of a URL (srcdoc). NOTE: Not "html": that is the innerHTML setter of a basic.js Box. |
| `aria_label:` | `"Web view"` | the name a screen reader says (the title of the iframe) |
| `sandbox:` | `null` | null: No sandbox. Ex: "allow-scripts allow-same-origin allow-forms allow-popups" |
| `allow:` | `""` | Ex: "fullscreen; clipboard-write" |
| `referrer_policy:` | `""` | Ex: "no-referrer" |
| `lazy:` | `0` | 1: The browser loads the page when the box is near the screen. (loading="lazy") |
| `scale:` | `1` | 0.5: The page is shown at half size (scaled preview). NOTE: Not "zoom": basic.js uses it for the page. |
| `interactive:` | `1` | 0: The page can not be clicked or scrolled. (Preview) |
| `auto_height:` | `0` | 1: The box height follows the page height. (Same origin pages only) |
| `toolbar:` | `0` | 1: A bar with the URL, reload and "open in a new tab" buttons (Only at create time) |
| `show_loading:` | `1` | 1: Spinner until the page is loaded |
| `empty_text:` | `"No page"` | Shown when nothing is loaded |
| `load_timeout:` | `0` | Seconds. 0: No timeout. Ex: 15 -> onTimeout is called when the page is not loaded in 15 seconds. |
| `on_load:` | `a block` |  |
| `on_error:` | `a block` | Same origin URL of load() that could not be loaded (the browser shows its error page) |
| `on_timeout:` | `a block` |  |
| `on_message:` | `a block` | Messages from the page (window.parent.postMessage) |
| `on_click:` | `a block` | interactive: 0 -> click on the cover |
| `style:` | `{...}` |  |

