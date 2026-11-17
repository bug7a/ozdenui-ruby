# 1. İlk pencere

## Kurulum

```
gem install ozdenui
```

Ruby 2.6 ya da daha yenisi gerekir, başka bir gem gerekmez: hiçbir şey derlenmez, bu yüzden C derleyicisi de derleme
araçları da gerekmez.

- **macOS:** pencere, programınızın içindeki sistemin web görünümüdür (WKWebView); Ruby'nin sistemi çağıran kütüphanesi
  `fiddle` ile yapılır. macOS ile gelen Ruby'yle (`/usr/bin/ruby`) çalışır; o Ruby ile
  `gem install --user-install ozdenui` gem'i ev klasörünüze kurar (onun kendi gem klasörü `sudo` ister).
- **Windows, Linux:** pencere, Edge'in ya da Chrome'un bir uygulama penceresidir: adres çubuğu yok, sekme yok.
  Windows'ta Edge her zaman vardır.

Derleme adımı yoktur: `ruby app.rb` programı yazıldığı gibi çalıştırır.

## En küçük pencere

```ruby
require "ozdenui"
include OzdenUI

run {}
```

800 x 600 px boyutunda, başlığı "OzdenUI" olan boş bir pencere. `ruby app.rb` onu açar ve siz kapatınca döner.

## Sayaçlı bir pencere

```ruby
require "ozdenui"
include OzdenUI

@count = 0

def change(step)
  @count += step
  @label.text = @count.to_s
end

run(title: "Sayaç", width: 400, height: 320) do |page|
  page.color = "#F4F5F7"
  VGroup(gap: 16) do
    @label = Label(text: "0", font_size: 64, bold: true)
    HGroup(hug: true, gap: 12) do
      SmartButton(label_text: "−", on_click: -> { change(-1) })
      SmartButton(label_text: "+", tone: "cyan", on_click: -> { change(1) })
    end
  end
end
```

Yukarıdan aşağı okuyun:

- **`require "ozdenui"`** gem'i yükler; **`include OzdenUI`** onun kısa adlarını verir (`run`, `Label`, `toast`). Onsuz
  her ad modülün bir metodudur: `OzdenUI.run`, `OzdenUI.Label(...)`.
- **`run(...) do |page| ... end`** penceredir. Onu açar, sayfa hazır olunca bloğu çalıştırır ve pencere kapanınca
  döner. Programın sonunda bir kez çağırın.
- **`run`'ın bloğu** nesneleri yapar. `page` pencerenin zeminidir: bir rengi, bir genişliği ve bir yüksekliği vardır;
  kendi kutusu olmayan her nesne onun üstündedir. Nesneler bu blokta ya da sonra (bir olayda, bir zamanlayıcıda)
  yapılır, hiçbir zaman `run`'dan önce değil.
- **`VGroup(gap: 16) do ... end`** bir gruptur: bloğunun içinde yapılan nesneler ona girer, alt alta ve 16 px
  aralıkla. İçindeki `HGroup` iki düğmeyi yan yana koyar; `hug: true` onu yalnız düğmeleri kadar büyük yapar.
- **`Label(text: "0", font_size: 64, bold: true)`** bir metindir. Değerleri adlı değerlerdir: basic.js'in adları,
  snake_case yazılmış.
- **`on_click: -> { change(-1) }`** olaydır: bir tıklama lambda'yı çalıştırır.
- **`@label.text = ...`** etiketi değiştirir. `@label.text` onu pencereye sormadan geri okur.

Sonradan değiştireceğiniz nesneleri değişkenlerde saklayın (burada `@label`); öbürlerine gerek yoktur. Dosyanın
başındaki bir instance değişkenini `run`'ın bloğu da dosyanın metotları da görür.

Gem'in `examples/counter.rb`'si bunun gibi bir programdır.

## Nasıl çalışır

Pencere, gem'in içindeki bir sayfayı gösterir. Sayfada basic.js ve kitin bileşenleri vardır; gem onları yanında
getirir, internet gerekmez. Sayfa yalnız bu bilgisayara sunulur.

```
Ruby kodunuz ──komutlar──▶ sayfa (basic.js nesneleri) ──▶ gördüğünüz
      ▲                                    │
      └──────── olaylar (bir tıklama) ◀────┘
```

- Ruby'deki bir nesne küçük bir vekildir: bir kimlik ve kendisine verilen değerleri tutar, gerçek nesnenin yaşadığı
  sayfaya komutlar gönderir. Bir işin (`run`'ın bloğu, bir olay, bir zamanlayıcı) bütün komutları, iş bitince sayfaya
  birlikte gider.
- Sayfadaki bir tıklama, bloğunuzu pencerenin thread'inde çağırır (4. bölüm).
- Kodunuz düz Ruby'dir, istediğiniz her gem'le: dosyalar, veritabanları, `net/http`, bir yapay zekâ istemcisi.

## Pencerenin seçenekleri

```ruby
run(
  title: "Notlar",   # pencerenin başlığı (verilmezse "OzdenUI")
  width: 800,        # sayfanın px olarak boyutu (verilmezse 800 x 600)
  height: 600,
  theme: "light",    # "light", "dark" ya da "auto" (sistem ne istiyorsa): 7. bölüm
  style: nil,        # nil ya da "minimal": 7. bölüm
  language: "tr",    # metinlerinin dili: "tr" büyük harfleri Türkçe yazar ("İ"); verilmezse "en"
  debug: false       # true: web görünümünün geliştirici araçları (sağ tık > Inspect Element)
) do |page|
  # ...
end
```

`run`'ın bilmediği bir ad programı hemen durdurur ve aldığı adların listesini yazar. Pencerenin öbür metotları
`run`'ın bloğunda, bir olayda ya da bir zamanlayıcıda çalışır (`close` her thread'den de):

```ruby
set_title("Notlar — kaydedildi")
close             # pencereyi kapatır; run döner
theme             # "light" ya da "dark"
dark?             # koyu bir pencerede true
set_theme("dark") # pencere başka bir temada yeniden: 7. bölüm
```

## Birden çok metotlu bir program

Çoğu program, sonradan değiştireceği nesneleri saklar. Dosyanın başındaki instance değişkenleri bunun en basit
yeridir, ve dosyanın bir metodu `method(:ad)` ile bir olay olarak verilebilir:

```ruby
require "ozdenui"
include OzdenUI

def greet
  typed = @name.text.strip
  if typed.empty?
    @answer.text = "Önce adınızı yazın."
    return
  end
  @answer.text = "Merhaba, #{typed}!"
end

run(title: "Selamlama", width: 420, height: 320) do |page|
  page.color = "#F4F5F7"
  VGroup(gap: 14, padding: 40) do
    @name = TextField(title_text: "Adınız ne?", placeholder: "Ada", width: 300, on_enter: method(:greet))
    SmartButton(label_text: "Selamla", tone: "cyan", on_click: method(:greet))
    @answer = Label(font_size: 18)
  end
end
```

`@name.text` her zaman alandaki metindir: sayfa onu her tuşta gönderir. Bir `Label` yazılan metni olduğu gibi gösterir
(bir `<b>`, `<b>` olarak kalır).

Kendi sınıfınız da aynı iyi çalışır (metotlarında `@name = TextField(...)`, sonra `run { NotesApp.new.start }`):
9. bölüm kendi bileşeninizi böyle yapar. Dosyanın en üstündeki kendi metotlarınıza OzdenUI'nin (`run`, `close`,
`ask`, `page`, `after`) ya da Ruby'nin (`send`, `format`, `open`) metotlarının adlarını vermeyin.
`examples/greeting.rb` yukarıdakine benzer bir programdır.

## Bir pencereye onu açmadan bakmak

```
OZDENUI_LOOK=app.png ruby app.rb
```

programı olduğu gibi çalıştırır, penceresinin bir resmini `app.png` olarak kaydeder ve biter; hiçbir pencere açılmaz.
Bilgisayarda Chrome, Edge ya da Chromium gerekir. `OZDENUI_THEME=dark` koyu pencereyi gösterir, `OZDENUI_LOOK_WAIT=3`
resimden önce üç saniye bekler. Hatasız çalışan bir programın da bir parçası örtülü ya da kesik olabilir: resme bir
bakış bunu söyler.

## Sayfa yeniden yüklenince

`debug: true` ile sayfayı yeniden yüklemek (sağ tık > Reload) nesneleri yeniden yapar: `run`'ın bloğu yeniden
çalışır, zamanlayıcılar durur ve terminal `ozdenui: the page was loaded again: the block of run runs again` yazar.
Verisini Ruby'de tutan bir program (bir Array, bir dosya) onu yeniden gösterir; başka bir şey gerekmez.

## Sonraki

[2. bölüm: Nesneler](02-objects.md): beş düz nesne ve değerleri.
