# 4. Olaylar ve zaman

## Bir olay bir lambda, bir metot ya da bir bloktur

```ruby
Button(text: "Kaydet", on_click: method(:save))  # yapılırken
button.on_click = -> { save }                    # sonra: öncekinin yerini alır
remove = button.on(:click) { log_click }         # bir işleyici daha; remove.call onu kaldırır
```

Olaylar için adlı değerler: `on_click:`, `on_input:`, `on_enter:`, `on_key_down:`, `on_mouse_enter:`,
`on_mouse_leave:`, `on_focus:`, `on_blur:`. Sayfanın başka her olayı `on` ile çalışır; snake_case ya da sayfanın
yazdığı gibi yazılır: `:dblclick`, `:mouse_enter`, `:key_up`, `:context_menu`.

### İşleyici ne gerekiyorsa onu alır

```ruby
Button(text: "Kaydet", on_click: -> { save })                        # hiçbir şey
Button(text: "Kaydet", on_click: ->(button) { save(button) })        # nesneyi
Button(text: "Kaydet", on_click: ->(button, event) { puts event.x }) # nesneyi ve olayı
Button(text: "Kaydet", on_click: method(:save)) # bir metot: def save, def save(button) ya da def save(button, event)
```

Bir lambda ve bir metot istedikleri kadar değer alır; bir blok (`obj.on(:click) { |obj, event| ... }`) ikisini de alır
ve adını verdiklerini kullanır. Lambda, metot ya da blok olmayan bir değer, verildiği satırla birlikte bir hata
yükseltir.

**Bir döngüde `each` her bloğa kendi değişkenini verir**, bu yüzden akla gelen kod doğrudur:

```ruby
(1..5).each do |number|
  SmartButton(label_text: number.to_s, on_click: -> { pick(number) })
end
```

Bir `for` döngüsü tek bir değişkeni bütün turlarında paylaşır: onda yapılan her lambda son sayıyı görürdü. `each`
kullanın.

Olayda bildikleri vardır:

| Okuyucu | Ne zaman |
|---|---|
| `key`, `code` | bir tuş: `"Enter"`, `"a"`, `"ArrowLeft"`; `code` tuşun klavyedeki yeridir (`"KeyA"`) |
| `shift`, `ctrl`, `alt`, `meta` | bir tuş: basılı tutulurken `true` (`meta`, Mac'te Cmd'dir) |
| `x`, `y` | fare, pencerenin köşesinden px olarak |
| `text` | bir `Input`: metni |
| `name` | olayın adı: `"click"`, `"keydown"` |

```ruby
require "ozdenui"
include OzdenUI

SPOT_COLOR = "#5BBAC1"
HOVER_COLOR = "#E0A038"

def show_key(_page, event)
  held = []
  held << "Ctrl" if event.ctrl
  held << "Alt" if event.alt
  held << "Shift" if event.shift
  held << "Meta" if event.meta
  @pressed.text = (held + [event.key]).join(" + ")
end

run(title: "Olaylar", width: 420, height: 300) do |page|
  page.color = "#F4F5F7"
  VGroup(gap: 14) do
    @pressed = Label(text: "Bir tuşa basın", font_size: 28, bold: true)
    @spot = Box(width: 160, height: 60, color: SPOT_COLOR, round: 10)
    @where = Label(text: "Kutuya tıklayın", font_size: 14, text_color: "#5A6270")
  end
  page.on(:key_down, method(:show_key))
  @spot.on(:mouse_enter) { @spot.color = HOVER_COLOR }
  @spot.on(:mouse_leave) { @spot.color = SPOT_COLOR }
  @spot.on(:click) do |_box, event|
    @where.text = "Tıklanan yer: #{event.x.round}, #{event.y.round}"
  end
end
```

`page.on(:key_down)` penceredeki her tuşu duyar; odaktaki bir alan kendi tuşlarını da duyar.

## Tek thread: kilit yok

`run`'ın bloğu, her olay ve her zamanlayıcı **teker teker, tek bir thread'de** (pencerenin thread'i) çalışır. İki
tıklama hiçbir zaman aynı anda çalışmaz ve okuduğunuz bir değer şimdinin değeridir. Kilide gerek yoktur; programınızın
yalnız bu blokların kullandığı değişkenleri için de.

Bunun öbür yüzü: bir blok çalışırken pencere bekler. 3 saniye süren bir blok pencereyi 3 saniye dondurur. Bu yüzden
**bir olayda asla `sleep` kullanmayın**: bir zamanlayıcıyla bekleyin, yavaş bir işe de bir thread verin (aşağıda).

## Zaman: every ve after

```ruby
require "ozdenui"
include OzdenUI

def tick
  @clock.text = Time.now.strftime("%H:%M:%S")
end

run(title: "Saat", width: 360, height: 220) do
  VGroup(gap: 12) do
    @clock = Label(text: Time.now.strftime("%H:%M:%S"), font_size: 48, bold: true)
    SmartButton(label_text: "Saati durdur", on_click: -> { @timer.stop })
  end
  @timer = every(1000) { tick }               # tekrar tekrar, her 1000 ms'de
  after(5000) { set_title("Saat — 5 sn") }    # bir kez
end
```

- `every(ms) { ... }` ve `after(ms) { ... }` bir zamanlayıcı döndürür: `timer.stop` onu bitirir (`timer.cancel`
  aynıdır).
- Bir zamanlayıcı da bir iştir: pencerenin thread'inde, tıklamaların arasında çalışır, bu yüzden her nesneyi
  değiştirebilir. Öncekisi hâlâ çalışırken gelen bir tık birikmez.
- `-> { @timer.stop }`, `@timer`'ı tıklamada okur, bu yüzden zamanlayıcının düğmeden sonra yapılması sorun değildir.
- `examples/clock.rb` bir kronometre ekler.

## Yavaş bir iş: bir thread ve ui { }

```ruby
require "ozdenui"
include OzdenUI

STEPS = 100

def begin_job
  @button.waiting = true # düğmede bir saat: artık tıklama almaz
  @result.text = ""
  Thread.new { work }
end

def work
  (1..STEPS).each do |step|
    sleep(0.03) # yavaş kısım: büyük bir dosya, bir indirme, bir model
    ui { @bar.value = step }
  end
  ui do
    @button.waiting = false
    @result.text = "Bitti."
  end
end

run(title: "Yavaş bir iş", width: 420, height: 260) do |page|
  page.color = "#F4F5F7"
  VGroup(gap: 14) do
    @bar = ProgressBar(title_text: "Çalışıyor", value: 0, max_value: STEPS, width: 320)
    @button = SmartButton(label_text: "Başlat", tone: "cyan", on_click: method(:begin_job))
    @result = Label(font_size: 16)
  end
end
```

- `Thread.new { work }`: iş kendi thread'inde çalışır; pencere çalışmaya devam eder.
- **Nesneler yalnız pencerenin thread'inde değiştirilir.** Sizin bir thread'iniz değişikliklerini ona `ui { ... }`
  ile verir: blok orada, şu an çalışan işten sonra çalışır. Her thread `ui`'yi çağırabilir: bir sunucu, bir soket,
  bir dosya izleyicisi.
- Başka bir thread'den değiştirilen bir nesne hata yükseltir ve mesaj çözümü söyler:
  `... works only in the block of run, an event or a timer. From another thread: ui { ... }`. Hiçbir şey sessizce
  bozulmaz.
- İşe gerekenleri (bir alanın metni, bir yol) başlamadan önce, kendi değerleri olarak verin.
- Bekleyen bir iş (bir indirme, bir dosya, başka bir program) bir thread'e en çok yakışan iştir. Ruby aynı anda tek
  bir thread çalıştırır, bu yüzden yalnız hesap yapan bir iş zamanı pencereyle paylaşır: pencere cevap vermeye devam
  eder, biraz daha yavaş.
- `close` her thread'den çalışır.
- `examples/job_log.rb` dosyaları böyle kopyalar ve yaptığını bir `LogView`'a yazar.

### İlerlemesini gösteren uzun bir iş

Bir işin komutları iş bitince sayfaya gider. Bir süre pencerenin thread'inde kalması gereken bir iş (bir kerede çok
sayıda nesne) o ana kadar yaptıklarını `flush` ile gönderebilir.

## Olayların sırası

Olaylar Ruby'ye oluştukları sırayla ulaşır, çok sayıda bir arada geldiğinde de (hızlı yazmak), ve her biri kendi işi
olarak çalışır. Hızlı ve sürekli bir olay (`obj.on(:mouse_move) { ... }`) her hareketi Ruby'ye gönderir. Sürüklenen bir
bileşen (bir `Slider`, bir `Splitter`) hareketlerini sayfada yapar ve size sonucu söyler (`on_change:`,
`on_change_end:`).

## Sonraki

[5. bölüm: Bileşenler](05-components.md): bir pencerenin hazır parçaları.
