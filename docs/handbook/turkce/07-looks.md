# 7. Görünüm

En genişinden en küçüğüne üç seviye: pencerenin **teması** (açık ya da koyu), pencerenin **stili** (her zamanki görünüm
ya da sizin renginizde minimal olan) ve **tek bir bileşenin görünümü** (paketi ve renkleri). Kodunuzun verdiği bir
görünüm her zaman pencereninkine üstün gelir.

## Koyu bir pencere

```ruby
run(theme: "dark") { make_the_window } # "light" (varsayılan), "dark" ya da "auto": sistem ne istiyorsa
```

- Her bileşen koyu görünümünü alır; diyaloglar ve toast'lar da.
- Sayfa, bir `Label`, bir `Box` ve bir `Input` da uyar: koyu bir zemin, açık bir metin.
- Bir `SmartButton`'ın `tone:`'u koyu tonu olur (`"cyan"` → `"cyanDark"`).
- `dark?` koyu bir pencerede (`"auto"`'dan sonra da) true'dur ve `theme` `"light"` ya da `"dark"`'tır: kendi
  nesnelerinizin renkleri için onları kullanın.

```ruby
text_soft = dark? ? "#9AA3B5" : "#5A6270"
Label(text: "Bugün güncellendi", text_color: text_soft)
```

`OZDENUI_THEME=dark ruby app.rb` herhangi bir programı kodunu değiştirmeden koyu açar: ikisini de görmenin hızlı bir
yolu.

## Program çalışırken temayı değiştirmek

On altı bileşen sayfadayken temalarını değiştirir: `LogView`, `ImageView`, `MarkdownView`, `JsonView`, `ChatView`,
`RangeSlider`, `StepBar`, `Canvas`, `MenuBar`, `ToolBar`, `StatusBar`, `Splitter`, `CodeEditor`, `Accordion`,
`GraphBox` ve `TimeLine`:

```ruby
log_view.style_name = "dark" # ya da log_view.set_theme("dark")
```

Öbürleri görünümlerini yapılırken alır, bu yüzden bütün bir pencere temasını sayfasını yeniden yaparak değiştirir.
`set_theme("dark")` bunu yapar (`"light"`, `"dark"` ya da `"auto"`): sayfa yeniden yapılır ve **`run`'ın bloğu yeniden
çalışır**. Her nesne yenidir, bir alana yazılmış metin gider ve önceden kurulmuş zamanlayıcılar durur. Programınızın
kendi değişkenlerinde tuttukları kalır; bu yüzden veriyi bloğun dışında tutun, nesneleri blokta ondan doldurun ve
zamanlayıcıları orada kurun:

```ruby
require "ozdenui"
include OzdenUI

# Bu programın her temadaki renkleri: anahtar, pencerenin temasıdır.
PAGE_COLORS = { "light" => "#F4F5F7", "dark" => "#141413" }.freeze
CARD_COLORS = { "light" => "#FFFFFF", "dark" => "#232322" }.freeze
TEXT_SOFT = { "light" => "#5A6270", "dark" => "#9AA3B5" }.freeze
THEME_NAMES = { "light" => "açık", "dark" => "koyu" }.freeze

@clicks = 0 # bloğun dışında: sayfa yeniden yapılınca kalır

def click
  @clicks += 1
  @count.text = @clicks.to_s
end

run(title: "Tema", width: 420, height: 320) do |page|
  other = dark? ? "light" : "dark"
  page.color = PAGE_COLORS[theme]
  VGroup(gap: 16) do
    VGroup(width: 300, height: "auto", padding: 20, gap: 10, color: CARD_COLORS[theme], round: 12) do
      Label(text: "Tıklamalar", font_size: 13, text_color: TEXT_SOFT[theme])
      @count = Label(text: @clicks.to_s, font_size: 40, bold: true)
      SmartButton(label_text: "Tıkla", tone: "cyan", on_click: method(:click))
    end
    SmartButton(label_text: "Pencereyi #{THEME_NAMES[other]} yap", on_click: -> { set_theme(other) })
  end
end
```

`examples/gallery.rb`'nin ToolBar'ında bunun için bir Dark / Light düğmesi vardır. `examples/editor.rb` yalnız
çubuklarını ve görünümlerini `set_theme` ile değiştirir, böylece düzenleyicideki metin kalır.

## Sizin renginizde minimal görünüm

```ruby
run(style: "minimal") { make_the_window }                    # küçük ve çizgilerden yapılmış; theme: "dark" de çalışır
run(style: "minimal", accent: "#2A78D6") { make_the_window } # aynısı, sizin renginizde
```

**`style: "minimal"`** yaklaşık 40 bileşene minimal görünümlerini verir: 28 px kontroller, 13 px bir metin, kendilerine
ait dolgu ve gölge yok; böylece pencerenin zeminini alırlar. Bir araç, bir düzenleyici, bir ayarlar paneli onda sakin
görünür.

**`accent:`** minimal görünüme tek bir renk verir (yalnız `style: "minimal"` ile birlikte). Görünümün mürekkebini
çizdiği yere gider: açık bir toggle, işaretli bir kutu, bir slider'ın ve bir ilerleme çubuğunun dolgusu, seçili sekme,
satır ve adım, yazarken bir alanın kenarı ve ana düğme. Çizgiler, metinler ve odak halkası olduğu gibi kalır.

```ruby
require "ozdenui"
include OzdenUI

ACCENT = "#2A78D6" # beyaz üstünde okunan bir renk: seçili sekmenin metni de odur

run(title: "Minimal", width: 420, height: 380, style: "minimal", accent: ACCENT) do |page|
  page.color = dark? ? "#1A1A19" : "#FFFFFF"
  VGroup(gap: 14, padding: 30, align: "left top") do
    Label(text: "Hesap", font_size: 18, bold: true)
    Tabs(tabs: ["Genel", "Gizlilik", "Gelişmiş"], panels: false, width: 300)
    CheckBox(label_text: "Beni hatırla", checked: true)
    HGroup(hug: true, gap: 10) do
      Toggle(value: true)
      Label(text: "Sesler", font_size: 13)
    end
    ProgressBar(title_text: "Yükleniyor", value: 62, width: 260)
    HGroup(hug: true, gap: 8) do
      SmartButton(label_text: "Vazgeç")
      SmartButton(label_text: "Kaydet", tone: "accent")
      SmartButton(label_text: "Sil", style_name: "minimalDanger")
    end
  end
end
```

- **`tone: "accent"`** her pencerenin ana işidir: burada vurgu rengi, vurgu yokken minimal görünümün mürekkebi, her
  zamanki görünümde `"cyan"`.
- **`style_name: "minimalDanger"`**: minimal görünümde bir silme (koyu bir pencerede koyu ikizi).
- **Koyu bir pencerede** renk, koyu zeminde okunana kadar açılır. `accent_dark: "#7FB6DE"` onu seçer.
- Minimal görünümü olmayan bir bileşen her zamankini korur. `examples/minimal_theme.rb` hepsini gösterir.

## Tek bir bileşenin görünümü

### Bir paket: style_name

Çoğu bileşenin paket denen birkaç görünümü vardır. Bileşenin `ozdenui doc`'u onları sayar (`ozdenui doc CheckBox`):

```ruby
CheckBox(label_text: "Beni hatırla", style_name: "modern")
ItemList(items: photos, layout: "grid", style_name: "gallery")
SmartButton(label_text: "İleri", style_name: "pill", tone: "blue")
```

Adını verdiğiniz bir paket her pencerede kalır; koyu bir pencerede koyu ikizi olan açık bir paket ikizini alır
(`"gallery"` → `"galleryDark"`, `"minimalDanger"` → `"minimalDangerDark"`). Bir bileşen paketiyle yapılır: sonradan
verilen bir `obj.style_name = ...` onu değiştirmez (terminal bunu söyler); yukarıdaki on altısı dışında.

### Sizin renkleriniz: style

`style:` bir bileşenin parçalarını değiştirir. Anahtarları kitin adlarıdır; bir stilde snake_case de olabilirler:

```ruby
SmartButton(label_text: "Git", style: {
  box: { color: "#2A78D6" },
  hover: { color: "#2367BA" },
  label: { text_color: "white" }
})
Toggle(value: true, style_name: "classic", background_style: { selected_color: "#6AC966" })
```

- `style:` paketin üstüne gelir: verdiğiniz kazanır, gerisi kalır.
- Parçaların adları (`box`, `hover`, `label`...) bileşenin basic.js'teki adlarıdır;
  [lib/ozdenui/web/comp](https://github.com/bug7a/ozdenui-ruby/tree/main/lib/ozdenui/web/comp)'taki dosyası ve
  [katalog](https://bug7a.github.io/js-components/) onları gösterir.
- `_style` ile biten bir parametre (`background_style:`, `button_style:`) de bir stildir.
- `unframed: true` bir bileşenin çerçevesini kaldırır (kutusunda kenarlık ve yuvarlak köşe yok): iki çubuğun
  arasındaki yeri dolduran bir `LogView` ya da bir `CodeEditor`.

### Düz nesneler

Bir `Box`, bir `Label`, bir grup renklerini değerlerinden alır (`color:`, `text_color:`, `border_color:`): 2. bölüm.
Bir programın renklerini dosyasının başında, sabitler olarak (ya da `theme`'ye göre bir Hash olarak) tutun; böylece
bir değişiklik tek satırdır:

```ruby
PAGE_COLOR = "#F4F5F7"
CARD_COLOR = "#FFFFFF"
TEXT_SOFT = "#5A6270"
```

## Sonraki

[8. bölüm: Veri ve resimler](08-data-and-pictures.md): grafikler, büyük tablolar, kayıtlar, Markdown, JSON, kod ve
resimler.
