# 10. Daha ileri

## Bir hatayı bulmak

Bir programı çalışmadan önce denetleyen bir derleyici yoktur, bu yüzden OzdenUI adları program çalışırken denetler ve
size programınızın satırıyla söyler:

- **Nesnenin bir değeri olmayan bir ad** (adlı bir değerde, bir setter'da ya da `set`'te) bir kez söylenir:

  ```
  ozdenui: app.rb:17: Label: font_szie is not a value of Label (did you mean font_size?)
  ozdenui: app.rb:24: TextField: warning_txt is not a value of TextField (did you mean warning_text?)
  ```

- **Var olmayan bir metot** (`graph.set_typ("line")`), yakın olduğu adla bir `NoMethodError` yükseltir:
  `set_typ is not a value or a method of GraphBox (did you mean set_type?)`.
- **Hiç verilmemiş bir değer** (`"auto"` bir etiketin `label.width`'i) `nil`'dir: `measure(:width)` sayfaya sorar.
- **Bir olaydaki ya da bir zamanlayıcıdaki bir hata**, içinde işiniz olan pencereyi kapatmaz: terminal
  `ozdenui: a task failed: ...` yazar ve programınızın oraya götüren satırlarını yazar; pencere çalışmaya devam eder.
- **Sizin bir thread'inizden değiştirilen bir nesne**, mesajında çözümüyle bir hata yükseltir: `ui { ... }`.
- **Sayfanın bir mesajı** (kendisinden isteneni yapamayan bir bileşen) `ozdenui (page ...): ...` olarak gelir.
- `run(debug: true)` pencereye web görünümünün geliştirici araçlarını verir: sağ tık > Inspect Element.

Yani: programı çalıştırın ve **terminali okuyun**.

## Ruby'den basic.js

basic.js'in ve kitin her şeyine ulaşılabilir, henüz bir Ruby metodu olmayanlara da:

```ruby
gauge.call(:set_value, 80)                          # sayfadaki nesnenin bir metodu; beklenmez
text = editor.ask(:get_selected_text)               # bir metot ve sonucu
width = label.measure(:width)                       # sayfanın şu an tuttuğu bir değer ("auto" bir boyut)
field.part(:input).call(:select)                    # bir bileşenin içindeki bir kutu

# Herhangi bir JavaScript; label.js nesnenin kendisidir.
value = evaluate("#{label.js}.elem.offsetWidth")

# Kitin herhangi bir bileşeni adıyla, ve kitin snake_case olmayan bir adı, metin olarak.
gauge = component("Gauge", value: 72, width: 200)
LoginPage("tab_border" => 1)
```

- `call` işin öbür komutlarıyla birlikte gider. `ask`, `measure` ve `evaluate` sayfayı bekler, bu yüzden onları
  döngülerin dışında tutun. Kitin bir metodu nesnenin de bir metodudur (`gauge.set_value(80)`); `call`, Ruby'nin zaten
  kullandığı bir ad içindir: `chat.call(:send, text)`.
- Sayfadan dönen düzdür: bir sayı bir Integer ya da bir Float'tır, kitin açık / kapalı bir değeri `1` / `0`'dır, bir
  liste bir Array'dir, bir nesne bir metinle ya da bir sembolle okunan bir Hash'tir (`row["name"]`, `row[:name]`).
  `on?(value)` açık / kapalı bir değeri okur.
- Bir bileşenin `ozdenui doc`'u metotlarını listeler; her birinin ne aldığı kitteki dosyasındadır:
  [lib/ozdenui/web/comp](https://github.com/bug7a/ozdenui-ruby/tree/main/lib/ozdenui/web/comp). Orada parametreleri
  adlarını camelCase olarak korur.

```ruby
require "ozdenui"
include OzdenUI

# Çizgiyi başlık kadar geniş yapar: "auto" bir boyutu yalnız sayfa bilir.
def underline
  width = @title.measure(:width).to_f
  @line.width = width
  pixels = evaluate("window.devicePixelRatio")
  @info.text = "Başlık #{width.round} px genişliğinde; bu ekranın piksel oranı #{pixels}."
end

def retitle
  @title.text = @name.text
  underline
  @name.part(:input).call(:select) # alanın metni seçilir, bir sonrakine hazır
end

run(title: "Ölçülmüş", width: 480, height: 340) do |page|
  page.color = "#F4F5F7"
  VGroup(gap: 14, padding: 24, align: "left top") do
    @title = Label(text: "Sayfanın ölçtüğü", font_size: 26, bold: true)
    @line = Box(width: 20, height: 4, color: "#2A78D6", round: 2)
    @name = TextField(title_text: "Yeni bir başlık", value: "Merhaba", width: 300, on_enter: method(:retitle))
    SmartButton(label_text: "Kullan", tone: "cyan", on_click: method(:retitle))
    @info = Label(text: "-", font_size: 14, text_color: "#5A6270")
  end
  @line.set_motion("width 0.3s") # genişliği sayfa hareket ettirir; Ruby yalnız sonu verir
  underline
end
```

## Thread'ler, bir kez daha

| | nesneleri değiştirebilir mi | sayfaya sorabilir mi (`ask`, `measure`, `evaluate`), bir diyalog gösterebilir mi |
|---|---|---|
| `run`'ın bloğu, olaylar, zamanlayıcılar (pencerenin thread'i) | evet | evet |
| sizin bir thread'iniz | `ui { ... }`'in içinde | `ui { ... }`'in içinde, ama thread onu beklemez |

Her thread `ui`'yi, `close`'u, `set_theme`'i çağırabilir ve `log.writer(level)`'a yazabilir.

## Hız

Bir pencereyi yavaşlatan neredeyse her zaman iki şeyden biridir:

- **Bir döngüde sayfaya bir soru**: her `measure`, `ask` ya da `evaluate` bir cevap bekler. Programınızın verdiğini
  ya da bir bileşenin söylediğini okumak (`obj.text`, `field.text`, `box.checked?`) bir şey sormaz.
- **Pencerenin thread'inde yavaş bir iş**: o bitene kadar pencere cevap vermez. Onu bir thread'e koyun (4. bölüm).

Bir işin bütün komutları iş bitince sayfaya birlikte gider, bu yüzden bir döngüde 500 nesne yapmak 500 değil, tek bir
mesajdır. Pencerenin thread'inde kalması gereken uzun bir iş ilerlemesini `flush` ile gösterebilir: o ana kadar
yapılan komutlar hemen sayfaya gider.

```ruby
require "ozdenui"
include OzdenUI

LIMIT = 400_000
PARTS = 20

def prime?(number)
  return false if number < 2
  divisor = 2
  while divisor * divisor <= number
    return false if (number % divisor).zero?
    divisor += 1
  end
  true
end

# Pencerenin thread'inde çalışır: flush her parçayı biter bitmez gösterir.
def count_primes
  count = 0
  step = LIMIT / PARTS
  PARTS.times do |part|
    (part * step...(part + 1) * step).each { |number| count += 1 if prime?(number) }
    @bar.value = part + 1
    flush
  end
  @result.text = "#{LIMIT}'den küçük asal sayılar: #{count}"
end

run(title: "Asal sayılar", width: 420, height: 260) do |page|
  page.color = "#F4F5F7"
  VGroup(gap: 16, padding: 24) do
    @bar = ProgressBar(title_text: "Denetlenen sayılar", value: 0, max_value: PARTS, width: 320)
    SmartButton(label_text: "Asalları say", tone: "cyan", on_click: method(:count_primes))
    @result = Label(text: "#{LIMIT}'den küçük asal sayılar: ?", font_size: 15)
  end
end
```

Çubuk ilerler, ama bir tıklama sayım bitene kadar bekler. Saniyeler süren bir iş, `ui { }` ile bir thread'e aittir.

## Pencerenin resmi, kişisiz bir denetim

```
OZDENUI_LOOK=app.png ruby app.rb                         # programı çalıştırır, app.png'yi kaydeder, biter; pencere yok
OZDENUI_THEME=dark OZDENUI_LOOK=dark.png ruby app.rb     # koyu pencere, kodu değiştirmeden
OZDENUI_LOOK_WAIT=3 OZDENUI_LOOK=app.png ruby app.rb     # ilk çizimden 3 sn sonra (varsayılan 1.5)
OZDENUI_LOOK_SCALE=2 OZDENUI_LOOK=app.png ruby app.rb    # iki kat noktalı bir resim
OZDENUI_WINDOW=headless ruby app.rb                      # program close'u çağırana kadar gizli bir pencere
OZDENUI_WINDOW=browser ruby app.rb                       # Edge'in ya da Chrome'un uygulama penceresi, macOS'ta da
OZDENUI_WINDOW=tab ruby app.rb                           # varsayılan tarayıcının bir sekmesi
```

- Bir resim için bilgisayarda Chrome, Edge ya da Chromium gerekir. Hatasız çalışan bir programın da bir parçası
  örtülü, kesik ya da sıkışmış olabilir: resim bunu gösterir.
- Bir programın denetimi onu koddan kapatır: `run`'ın bloğunun ilk satırı olarak `after(3000) { close }`. Bir
  diyaloğa varmamalıdır: bir diyalog bir kişiyi bekler.

## Bir yapay zekâ asistanıyla

OzdenUI yeni olduğu için bir yapay zekâ asistanı (Claude Code, Codex, Cursor, Copilot...) onu henüz bilmez ve bildiği
araç takımlarından tahmin eder. Gem'in `ozdenui` komutu gem'in kurallarını projenizin klasörüne yazar; asistan onları
oradan kendiliğinden okur:

```
ozdenui agents              # AGENTS.md'ye
ozdenui agents CLAUDE.md    # Claude Code'un okuduğu dosyaya
ozdenui agents --print      # yalnız yazdırır
ozdenui doc SelectBox       # bir bileşenin parametreleri, sizin ve asistanın için
```

- Kurallar kısadır: bir programın nasıl yapıldığı, yerleşim, olaylar, bileşenler, kaçınılacak hatalar ve
  `OZDENUI_LOOK`; böylece asistan yaptığı pencereye bakar.
- Var olan bir dosya sizin satırlarınızı korur: kurallar onun sonuna, iki işaretin arasına gider. Gem'in bir
  güncellemesinden sonra (`gem update ozdenui`) komutu yeniden çalıştırın: yalnız o kısım değişir.

## Bir programı başka birine vermek

Bir Ruby programı `.rb` dosyalarıdır: derlenecek bir şey yoktur. Öbür bilgisayarda Ruby 2.6 ya da daha yenisi (macOS'ta
bir tane vardır) ve gem gerekir. Programın yanındaki bir `Gemfile` neye ihtiyacı olduğunu söyler:

```ruby
source "https://rubygems.org"

gem "ozdenui"
gem "fiddle" if RUBY_VERSION >= "3.5" # macOS'un penceresi, Windows'un dosya diyalogları: fiddle, Ruby 3.5'te varsayılan gem'lerden çıktı
```

```
bundle install
bundle exec ruby app.rb
```

- Sayfa, basic.js ve bileşenler gem'in içindedir, bu yüzden programın kitin başka bir dosyasına ve internete ihtiyacı
  yoktur. Kendi dosyaları (resimler, veri) onunla birlikte gider.
- Bundler olmadan `gem install ozdenui` ve `ruby app.rb` yeter.

## v0.1'in sınırları

- Denenmiş sistemler macOS, Windows 11 ve Linux'tur (Ubuntu 24.04 ve onun Chromium'u). Windows ve Linux, Edge'in,
  Chrome'un ya da Chromium'un uygulama penceresini açar (hiçbiri yoksa varsayılan tarayıcının bir sekmesini).
- macOS'ta menü çubuğu programı penceresinin başlığıyla anar, ama Dock onu bir Ruby programı olarak gösterir (bir
  uygulama paketi değildir).
- Bir program için tek pencere.
- Hemen cevap vermesi gereken bir callback programın bir bloğu olamaz, çünkü cevap sonra gelir: bir doğrulayıcı, bir
  satırın nesnelerini kuran bir blok (`createItemView`). Bir tablonun değerlerini Ruby'de biçimlendirin; bir
  `GraphBox`'ın ya da bir `Stepper`'ın sayıları bir biçim metni alır (8. bölüm).
- Bir `FilePicker`'a bırakılan bir dosya yolunu değil adını verir; tıklamayla seçilen bir dosyanın yolu vardır
  (6. bölüm).
- Bir `Tooltip` balonu sizin nesnelerinizi değil, bir metni gösterir.
- On altı bileşen sayfadayken temalarını değiştirir; öbürleri onu yapılırken alır (7. bölüm).
- Sıcak yeniden yükleme yok: yeniden `ruby app.rb`.

## Bundan sonra

- Gem'in **örnekleri**, en küçüğünden: `counter`, `greeting`, `basics`, `notes`, `todo`, `form`, `settings`,
  `calculator`, `dialogs`, `clock`, `game`, `charts`, `csv_viewer`, `json_viewer`, `image_viewer`, `editor`,
  `markdown_editor`, `job_log`, `chat`, `gallery` (ana bileşenler), `minimal_theme`.
- Gem'in **README**'si: her bileşen tek bir tabloda.
- **`ozdenui doc SelectBox`**: bir bileşenin her parametresi varsayılanıyla, görünümleri, tuttuğu değerler ve
  metotları; `ozdenui doc`: her bileşenin adı.
- **[basic.js](https://bug7a.github.io/basic.js/)** ve **[bileşenler](https://bug7a.github.io/js-components/)**:
  altındaki kütüphane, her bileşenin canlı bir örneğiyle.

[Başa dön](README.md)
