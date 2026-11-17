# Bismillah
# Settings on three tabs. Save shows them (also in the terminal).
require "ozdenui"
include OzdenUI

PAGE_COLOR = "#F4F5F7"
CARD_COLOR = "#FFFFFF"
CARD_COLOR_DARK = "#232322"
TEXT_SOFT = "#5A6270"
FORM_WIDTH = 460
PANEL_HEIGHT = 250
FIRST_NAME = "Ada"
QUALITIES = ["Low", "Normal", "High"].freeze

def panel_group(gap, &content)
  VGroup(width: "100%", height: "auto", align: "left top", gap: gap, padding: [0, 16], &content)
end

def general_panel
  panel_group(14) do
    @name = TextField(title_text: "Name", value: FIRST_NAME, width: FORM_WIDTH)
    Label(text: "Language", font_size: 13, text_color: TEXT_SOFT)
    @language = SelectBox(options: ["English", "Türkçe", "Deutsch"], value: "English", width: FORM_WIDTH)
  end
end

def notifications_panel
  panel_group(16) do
    @email = CheckBox(label_text: "E-mail", checked: true)
    @sms = CheckBox(label_text: "SMS")
    HGroup(hug: true, gap: 12, align: "left center") do
      @sounds = Toggle(value: true)
      Label(text: "Play a sound", font_size: 15)
    end
  end
end

def sound_panel
  panel_group(16) do
    Label(text: "Volume", font_size: 13, text_color: TEXT_SOFT)
    @volume = Slider(value: 7, min_value: 0, max_value: 10, width: FORM_WIDTH, style_name: "round")
    HGroup(hug: true, gap: 18) do
      QUALITIES.each do |quality|
        RadioButton(group: "quality", value: quality, label_text: quality, checked: quality == "Normal")
      end
    end
  end
end

def settings_text
  "name: #{@name.text}, language: #{@language.value}, email: #{@email.checked?}, sms: #{@sms.checked?}, " \
    "sounds: #{@sounds.checked?}, volume: #{@volume.value}, quality: #{radio_value('quality')}"
end

def save
  settings = settings_text
  puts "saved: #{settings}"
  @saved.text = settings
  toast_success("The settings are saved.")
end

def reset
  @name.value = FIRST_NAME
  @language.value = "English"
  @email.checked = true
  @sms.checked = false
  @sounds.value = true
  @volume.value = 7
  @saved.text = ""
end

run(title: "Settings", width: 580, height: 560) do |page|
  page.color = PAGE_COLOR unless dark? # a dark window has its own ground
  VGroup(gap: 16, padding: 30, align: "left top") do
    Label(text: "Settings", font_size: 24, bold: true)
    VGroup(width: FORM_WIDTH + 40, height: "auto", align: "left top", gap: 16, padding: 20, color: dark? ? CARD_COLOR_DARK : CARD_COLOR, round: 12) do
      tabs = Tabs(tabs: ["General", "Notifications", "Sound"], panel_height: PANEL_HEIGHT)
      tabs.panel("General") { general_panel }
      tabs.panel("Notifications") { notifications_panel }
      tabs.panel("Sound") { sound_panel }
      HGroup(hug: true, gap: 10) do
        SmartButton(label_text: "Save", tone: "cyan", on_click: method(:save))
        SmartButton(label_text: "Reset", on_click: method(:reset))
      end
    end
    @saved = Label(font_size: 13, text_color: TEXT_SOFT)
  end
end
