# 5. Bileşenler

Bir bileşen, 2. bölümün nesnelerinden yapılmış, bir pencerenin hazır bir parçasıdır: bekleme saati olan bir düğme,
başlığı ve uyarısı olan bir alan, arama kutusu olan bir liste, 100000 satırlık bir tablo. 83 tanesinin kendi metodu
vardır; `component("Ad", ...)` herhangi birini adıyla yapar.

## Her bileşen nasıl çalışır

```ruby
remember = CheckBox(label_text: "Beni hatırla", checked: true, on_change: method(:show))
```

- **Parametreler adlı değerlerdir**: kitin parametreleri, snake_case yazılmış: `title_text:`, `selected_keys:`,
  `panel_height:`. Bir terminalde `ozdenui doc CheckBox` her parametreyi varsayılanı ve aldığı değerle, görünümlerini,
  tuttuğu değerleri ve metotlarını listeler. Yanlış bir ad terminalde, programınızın satırı ve yakın olduğu adla
  söylenir.
- **Yazılmayan bir parametre kitin varsayılanını korur.** `nil` "yazılmadı" demektir; `""` boş bir metindir,
  yazılmıştır (`label_text: ""`: yalnız simgesi olan bir düğme).
- **Bir callback bir parametredir**: `on_change: method(:show)`. Bir olay gibi ne gerekiyorsa onu alır: `-> { }`,
  `->(box) { }` ya da daha fazlası. Nesneden sonraki değerler `ozdenui doc`'un andıklarıdır:
  `on_select: ->(table, row) { puts row[:name] }` satırı bir Hash olarak, `on_step_click: ->(bar, index) { }` bir sayı
  olarak alır.
- **Durumu Ruby'dedir**: `remember.checked?`, `select_box.value`, `field.text`, `list.selected_keys`. Bunu okumak
  sayfaya bir şey sormaz; `ozdenui doc` her birinin neyi tuttuğunu söyler.
- **Onu değiştirmek**: `remember.checked = false`, `bar.value = 40`, `field.value = ""` ya da herhangi bir parametre,
  adıyla: `field.unit_text = "kg"`. Kitte metodu olan bir parametre (`setUnitText`) o metotla değiştirilir, böylece
  bileşen kendini yeniden çizer.
- **Kitin bir metodu** nesnenin bir metodudur, snake_case yazılmış: `list.add_item(key: "c", text: "Kiraz")`
  (beklenmez). `get_`, `is_` ya da `has_` ile başlayan bir metot sonucunu bekler: `list.get_selected_keys` (sayfaya
  bir soru, bu yüzden bir döngüde değil). Her birinin ne aldığı
  [kitteki dosyasındadır](https://github.com/bug7a/ozdenui-ruby/tree/main/lib/ozdenui/web/comp).
- **Kodunuzun yaptığı bir değişiklik callback'i çağırmaz**; yalnız kullanıcınınki çağırır.

## İki sekmeli bir form

```ruby
require "ozdenui"
include OzdenUI

FORM_WIDTH = 400
QUALITIES = ["Düşük", "Normal", "Yüksek"].freeze

def profile_panel
  VGroup(width: "100%", height: "auto", gap: 14, padding: [0, 16], align: "left top") do
    @name = TextField(title_text: "Ad", required: true, width: FORM_WIDTH)
    @language = SelectBox(options: ["English", "Türkçe", "Deutsch"], value: "Türkçe", width: FORM_WIDTH)
    @news = CheckBox(label_text: "Bana haberleri gönder")
  end
end

def sound_panel
  VGroup(width: "100%", height: "auto", gap: 16, padding: [0, 16], align: "left top") do
    @volume = Slider(value: 7, min_value: 0, max_value: 10, width: FORM_WIDTH)
    HGroup(hug: true, gap: 18) do
      QUALITIES.each do |quality|
        RadioButton(group: "quality", value: quality, label_text: quality, checked: quality == "Normal")
      end
    end
    @sounds = Toggle(value: true)
  end
end

def save
  return unless @name.valid? # uyarıyı alanda gösterir
  puts @name.text, @language.value, @news.checked?, @volume.value, radio_value("quality"), @sounds.checked?
  toast_success("Kaydedildi.")
end

run(title: "Ayarlar", width: 540, height: 580) do |page|
  page.color = "#F4F5F7"
  VGroup(gap: 16, padding: 24, align: "left top") do
    Label(text: "Ayarlar", font_size: 24, bold: true)
    VGroup(width: 460, height: "auto", padding: 20, gap: 16, align: "left top", color: "white", round: 12) do
      tabs = Tabs(tabs: ["Profil", "Ses"], panel_height: 240)
      tabs.panel("Profil") { profile_panel }
      tabs.panel("Ses") { sound_panel }
      SmartButton(label_text: "Kaydet", tone: "cyan", on_click: method(:save))
    end
  end
end
```

`value`, kullanıcı değiştirene kadar kodunuzun verdiği değerdir (slider'ın `7`'si), sonra sayfanın söylediği değer:
sayfadan gelen bir sayı, JSON'un yazdığı gibi bir Integer ya da bir Float'tır. Sayfadan gelen açık / kapalı bir değer
`1` / `0`'dır: `checked?` onu okur, `on?(value)` her birini okur. `examples/settings.rb` üç sekmeli daha uzun bir
örnektir, `examples/form.rb` tarihleri, bir saati ve bir rengi olan bir form.

## Bileşenler, yaptıkları işe göre

### Düğmeler

| | |
|---|---|
| `SmartButton(label_text: "Kaydet", tone: "cyan", on_click: method(:save))` | `tone:`: `"cyan"` ana iş, `"orange"` bir silme, `"yellow"`, `"green"`, `"blue"`, `"white"`; `"accent"`: minimal bir pencerenin ana işi (7. bölüm) |
| `SmartButton(label_text: "", icon_file: "plus.svg", aria_label: "Ekle")` | bir simge düğmesi: bir kare |
| `button.waiting = true` | üstünde bir saat; `button.waiting = false` olana kadar tıklama almaz |
| `SmartButton(label_text: "Sil", ask: "Silmek için yeniden tıklayın.")` | ilk tıklama sorar, ikincisi `on_click`'i çalıştırır |
| `button.enabled = false`, `button.label_text = "Kaydedildi"` | |

### Alanlar

| | |
|---|---|
| `TextField(title_text: "Ad", placeholder: "Ada", on_change: fn, on_enter: fn)` | `field.text`; `on_change` her değişiklikte, `on_enter` Enter'da |
| `EmailField`, `PasswordField`, `NumberField`, `TextAreaField` | aynısı; bir e-posta, bir parola, bir sayı, çok satır için |
| `required: true`, sonra `field.valid?` | uyarıyı alanda gösterir; uyarı yoksa `true` |
| `max_length: 40`, `PasswordField(min_length: 8)` | en çok ve en az harf |
| `UrlField(title_text: "Site")` | protokolüyle bir adres |
| `PhoneField(...)`, `CurrencyField(unit_text: "₺")` | maskesindeki numara; gruplanmış tutar |
| `SearchInput(placeholder: "Bul", on_change: fn)` | `fn` her değişiklikte arama kutusunu alır; `search.text` |
| `TagInput(tags: ["ses"], suggestions: [...])` | `field.tags` |

`valid?` bir alanın uyarısını gösterir. Bir formun bütün uyarılarını göstermek için önce hepsini denetleyin, sonra
karar verin: `checks = [@name.valid?, @email.valid?]`, sonra `checks.all?` (`&&` ile ilki geçmeyince ikincisi
denetlenmezdi).

### Seçimler

| | |
|---|---|
| `CheckBox(label_text: "Beni hatırla", checked: true)` | `box.checked?` |
| `Toggle(value: true)` | `toggle.checked?` |
| `RadioButton(group: "size", value: "M", label_text: "Orta")` | `radio_value("size")` |
| `SelectBox(options: ["Elma", "Armut"], value: "Armut")` | `select_box.value` |
| `Slider(value: 30, min_value: 0, max_value: 100, on_change_end: fn)` | `slider.value`; `on_change_end`: fare onu bırakınca |
| `SliderField(...)`, `Stepper(value: 2, min_value: 0, max_value: 10)` | `.value` |
| `RangeSlider(low_value: 200, high_value: 800, max_value: 1000, step: 50)` | `slider.low`, `slider.high` |
| `DatePicker(date: "2026-11-20")`, `TimePicker(time: "19:30")`, `ColorPicker(selected_color: "#3871E0")` | `.value`: `"2026-11-20"`, `"19:30"`, `"#3871E0"` |

### Listeler, tablolar ve ağaçlar

```ruby
fruits = ItemList(
  items: ["Elma", { key: "p", text: "Armut", description: "Yeşil" }],
  selection: "multiple", height: 240,
  on_change: ->(list) { p list.selected_keys }
)
fruits.add_item(key: "c", text: "Kiraz")
fruits.remove_item("p")
```

- **`ItemList`**: `list.selected_keys` (anahtarların bir Array'i), `list.selected`. Metin olan bir öğe anahtar olarak
  sırasını alır (`"0"`); bir öğedeki `enabled: false` seçilemez. `layout: "grid", style_name: "gallery"` resimleri
  gösterir. `examples/todo.rb` onlardan biriyle yapılmış bir yapılacaklar listesidir.
- **Bir öğe** bir metin ya da bir Hash'tir. **Bir öğenin içindeki anahtarlar sayfaya yazıldıkları gibi gider**, bu
  yüzden kitin yazdığı gibi kitin adlarıdır: `text:`, `description:`, `iconFile:`, `enabled:`... (`icon_file:` değil,
  `iconFile:`).
- **`SmartTable`**: çok sayıda satır (yalnız görünen satırlar yapılır), bir süzgeç kutusu ve sıralama. Sütunları:
  `title_data_list: [{ name: "AD", dataTitle: "name", width: 160, sortable: 1 }]`; satırları: `item_data_list:`
  (Hash'ler ya da Struct'lar); `on_select: ->(table, row) { }`. 8. bölümde daha fazlası var.
- **`DataTable`** (`columns:`, `rows:`): daha küçük bir tablo; `table.selected_row`. **`TreeView`**
  (`items: [{ key: "a", text: "A", children: ["b"] }, { key: "b", text: "B" }]`): `tree.value` seçili anahtardır.
  **`SortableList`**: kullanıcı sırayı değiştirir; `list.order` anahtarları yeni sırasıyla verir.

### Sizin nesnelerinizi tutan alanlar

Bazı bileşenler sizin nesnelerinizi tutar. Her biri, bir kutunun yaptığı gibi, alanının bir bloğunu verir:

```ruby
tabs = Tabs(tabs: ["Siparişler", "Müşteriler"])
tabs.panel("Siparişler") { Label(text: "Henüz sipariş yok") }

folds = Accordion(sections: ["Genel", "Gelişmiş"])
folds.section("Genel") { CheckBox(label_text: "Sistemle birlikte başla") }

split = Splitter(first_size: 240) # iki alan, aralarında sürüklenen bir çizgi
split.first { Label(text: "Sol") }
split.second { Label(text: "Sağ") }

panel = SidePanel(title_text: "Süzgeçler") # yandan kayarak gelir
panel.body { CheckBox(label_text: "Yalnız yeniler") }
SmartButton(label_text: "Süzgeçler", on_click: -> { panel.open })
```

Metin olarak verilen bir sekmenin ya da bölümün anahtarı o metindir. Bir `Splitter` kutusu kadar büyüktür: bir grupta
ona `fill: true` ya da bir boyut verin. `ScrollArea` ve `GridGroup` nesnelerini kendi bloklarında alır (3. bölüm).

### Pencerenin çubukları

| | |
|---|---|
| `MenuBar(menus: [{ text: "Dosya", items: [{ text: "Kaydet", shortcut: "Ctrl+S", onClick: method(:save) }] }])` | sayfanın içinde, pencerenin görünümünde; Mac'te Ctrl, Cmd'dir |
| `ToolBar(items: [{ key: "save", icon: "save", hint: "Kaydet" }, "-"], on_click: fn)` | `"-"` bir çizgi; `toggle: true` basılı kalır; `fn` çubuğu ve öğeyi alır |
| `StatusBar(message_text: "Hazır", items: ["UTF-8"])` | `bar.set_message_text("Kaydedildi", "success", 3000)`, `bar.set_busy(true)` |
| `ContextMenu(target: table, items: ["Aç", "-", { text: "Sil", onClick: fn }])` | hedefe sağ tıklama onu açar |

Bir menüsü, bir araç çubuğu, yeri alan bir listesi ve bir durum çubuğu olan pencere, bunların `gap: 0` olan bir
`VGroup`'udur; ortadaki parçada `fill: true` vardır (3. bölüm):

```ruby
require "ozdenui"
include OzdenUI

FILES = [
  { key: "report", text: "rapor.pdf", description: "120 KB" },
  { key: "photo", text: "foto.jpg", description: "2.4 MB" },
  { key: "notes", text: "notlar.txt", description: "4 KB" }
].freeze

def tell(text)
  @status.set_message_text(text, "info", 2000)
end

def press_tool(_bar, item)
  tell("#{item[:hint]} basıldı")
end

def choose(list)
  tell("Seçilen: #{list.selected_keys.join(', ')}")
end

run(title: "Dosyalar", width: 620, height: 420) do
  VGroup(gap: 0) do
    MenuBar(menus: [
      { text: "Dosya", items: [
        { text: "Yeni", shortcut: "Ctrl+N", onClick: -> { tell("Yeni") } },
        "-",
        { text: "Kapat", onClick: -> { close } }
      ] }
    ])
    ToolBar(on_click: method(:press_tool), items: [
      { key: "new", icon: "new", hint: "Yeni" },
      { key: "save", icon: "save", hint: "Kaydet" }
    ])
    ItemList(fill: true, unframed: true, items: FILES, on_change: method(:choose))
    @status = StatusBar(message_text: "Hazır", items: ["3 dosya"])
  end
end
```

`unframed: true` listenin kenarlığını ve yuvarlak köşelerini kaldırır: iki çubuğun arasındaki yeri doldurur.
`examples/editor.rb` ve `examples/gallery.rb` bu türden daha büyük pencerelerdir.

### İlerleme ve adımlar

| | |
|---|---|
| `ProgressBar(title_text: "Kopyalanıyor", value: 0)` | `bar.value = 40` |
| `LoadingScreen(title_text: "Uygulamam", message_text: "Okunuyor...")` | pencereyi örter; `loading.set_progress(0.4)`, `loading.close` |
| `StepBar(steps: ["Sepet", "Adres", "Ödeme"], current_step: 1)` | `bar.next`, `bar.previous`, `bar.step` |
| `Tooltip(target: button, hint_text: "Dosyayı kaydeder")` | farenin altında bir ipucu; öbür biçimleri 6. bölümde |

### Görünümler: 8. bölüm

`GraphBox` (grafikler), `LogView`, `ImageView`, `MarkdownView`, `JsonView`, `JsonEditor`, `CodeEditor`, `Canvas`,
`ChatView` ve `WebView` veri, resim, kod, bir konuşma ve web sayfaları gösterir (`JsonEditor` ve `CodeEditor` onları
yazar da): 8. bölüm.

### Bileşenlerin kendi metinleri

Bir bileşenin kendi yazdığı metinler (bir uyarı, bir diyaloğun düğmeleri, boş bir tablonun mesajı) İngilizcedir. Her
biri bir parametreyle değişir:

```ruby
TextField(title_text: "Ad", required: true, required_text: "Gerekli") # "Required" yerine
confirm("Dosya silinecek.", title: "Silinsin mi?", confirm_text: "Sil", cancel_text: "Kalsın", danger: true)
SmartTable(no_data_found_alert: "Kayıt yok", all_titles_text: "HEPSİ")
DatePicker(date: "2026-11-20", language: "tr") # aylar ve günler Türkçe
JsonEditor(texts: { addRow: "Satır", search: "Satırlarda ara", table: "Tablo" })
```

Bir bileşenin metin parametreleri `_text` ile biter ya da ne olduklarını söyler (`placeholder:`, `empty_text:`);
`ozdenui doc` her birini İngilizce varsayılanıyla gösterir. Bir `JsonEditor`'ün metinleri, kitin adlarıyla, tek bir
`texts:` Hash'indedir (`addRow:`).

## Herhangi bir bileşen adıyla: component()

Adının metodu kolay yoldur. `component()` aynı bileşeni adından yapar; programınızın çalışırken seçtiği bir ad için
yol budur:

```ruby
Gauge(value: 72, sub_text: "Disk")
component("Gauge", value: 35, sub_text: "Bellek") # aynı bileşen, adıyla
```

- Sayfa bir bileşeni, programınız onu ilk kez andığında, gerekenleriyle birlikte yükler: bir program yalnız
  kullandığının bedelini öder. `run`'dan önce hiçbir şey listelenmez.
- Kitin snake_case yazılamayan bir adı, olduğu gibi bir metin olarak verilir: `LoginPage("tab_border" => 1)`.
- Her bileşen, her birinin bir örneğiyle: [katalog](https://bug7a.github.io/js-components/) ve `ozdenui doc`. Bir
  bileşenin içindeki, içine nesne koymak ya da çağırmak için bir kutu: `obj.part(:name)`.

## Sonraki

[6. bölüm: Diyaloglar, mesajlar ve dosyalar](06-dialogs-and-files.md).
