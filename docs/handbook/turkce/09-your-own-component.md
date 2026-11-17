# 9. Kendi bileşeniniz

Birden çok kez gereken bir parça (bir kart, bir formun bir satırı, bir puanlama) sizin bir sınıfınız olur: `initialize`'ı
nesnelerini yapar, değiştireceklerini tutar ve metotları onları değiştirir. JavaScript gerekmez, kaydedilecek bir şey
de yoktur: düz Ruby'dir.

## Bir kart

```ruby
require "ozdenui"
include OzdenUI

# Bu programın bir bileşeni: bir başlık, bir metin ve bir düğme.
class Card
  attr_reader :box # kartı tutan grup

  # İçinde yapıldığı grupta bir kart yapar. Blok, düğmesine tıklanınca çalışır.
  def initialize(title, text, &on_open)
    @on_open = on_open
    @box = VGroup(width: 220, height: "auto", align: "left top", padding: 16, gap: 8, color: "white", round: 12) do
      @title = Label(text: title, font_size: 18, bold: true)
      Label(text: text, font_size: 15, text_color: "#5A6270")
      SmartButton(label_text: "Aç", on_click: -> { @on_open.call(self) if @on_open })
    end
  end

  # Başlığını değiştirir.
  def title=(title)
    @title.text = title
  end
end

run(title: "Kartlar", width: 760, height: 240) do |page|
  page.color = "#F4F5F7"
  HGroup(gap: 16, padding: 24, wrap: true) do
    ["Satışlar", "Stok", "Siparişler"].each do |name|
      Card.new(name, "Bugün güncellendi.") { |card| card.title = "Açıldı" }
    end
  end
end
```

- **`Card.new` nesneleri çağrıldığı yerde yapar**, kitin bir bileşeninin yaptığı gibi: bir grubun bloğunun içinde kart
  o gruba girer. En üstteki `include OzdenUI` kısa adları sınıfa da verir.
- **Nesne, nesnelerini instance değişkenlerinde tutar** (`@box`, `@title`). Bir okuyucu (`attr_reader :box`) kartı
  kullanan program içindir; öbürleri içeride kalır.
- **Metotlar onu değiştirir** (`title=`), bileşenlerin setter'larının yaptığı gibi.
- **Nesneleri sıradan nesnelerdir:** `card.box.remove` kartı ve içindeki her şeyi siler;
  `card.box.on(:mouse_enter) { ... }` ve `card.box.measure(:width)` her nesnedeki gibi çalışır.
- `initialize`'ın içindeki bloklar kartın instance değişkenlerini görür: onlarda `self` karttır.

Hiçbir şey tutmayan bir parçanın sınıfa ihtiyacı yoktur: nesnelerini yapan ve nesneyi döndüren bir metot yeter.

```ruby
# Bir sayfanın bir bölümünün üstündeki küçük başlık.
def caption(text)
  Label(text: text.upcase, font_size: 11, bold: true, text_color: "#5A6270")
end
```

## Kendi durumu ve kendi callback'i

Sizin bir bileşeniniz durumunu Ruby'de tutar ve kullanıcı onu değiştirince programa söyler:

```ruby
require "ozdenui"
include OzdenUI

STAR_ON = "#E0A038"
STAR_OFF = "#C9CDD4"

# Beş yıldız: value (0'dan 5'e); blok, kullanıcı bir yıldıza tıklayınca çalışır.
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

  # Kod için: bileşenlerin yaptığı gibi bloğu çağırmaz.
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

run(title: "Puan", width: 320, height: 200) do
  VGroup(gap: 12) do
    said = Label(text: "Puan verin", font_size: 16)
    Rating.new(3) { |rating| said.text = "#{rating.value} yıldız" }
  end
end
```

`-> { click(number) }` her yıldıza kendi sayısını verir: `each`'in her turunun kendi `number`'ı vardır. Sınıfın private
bir metodu (`click`) sınıfın bir lambda'sında çalışır.

## Nesne tutan bir bileşen

Nesneleri, `VGroup`'un yaptığı gibi bir blok olarak alın ve onları tutan kutuyu döndürün, böylece program sonradan
`add` ile başkalarını ekleyebilir:

```ruby
# Bir formun başlıklı bir bölümü. Blok nesnelerini yapar; section.add { ... } sonradan başkalarını koyar.
def section(title, &content)
  body = nil
  VGroup(width: "100%", height: "auto", gap: 8, align: "left top") do
    Label(text: title.upcase, font_size: 11, bold: true, text_color: "#5A6270")
    body = VGroup(width: "100%", height: "auto", gap: 10, align: "left top", &content)
  end
  body
end

sound = section("Ses") do
  CheckBox(label_text: "Bir ses çal")
  Slider(value: 7, min_value: 0, max_value: 10)
end
sound.add { Toggle(value: true) }
```

## Paylaşmak: bir dosya, sonra bir gem

Birden çok dosyanın kullandığı bir bileşen kendi dosyasına gider:

```
myapp/
  app.rb           require "ozdenui" ... require_relative "widgets/card" ... Card.new("Satışlar", "Bugün güncellendi.")
  widgets/
    card.rb        class Card (include OzdenUI sınıfın içinde)
```

```ruby
# widgets/card.rb
require "ozdenui"

class Card
  include OzdenUI # kısa adlar yalnız bu sınıfın içinde: dosya, onu require eden programı değiştirmez

  def initialize(title, text)
    @box = VGroup(width: 220, height: "auto", padding: 16, gap: 8, color: "white", round: 12) do
      Label(text: title, font_size: 18, bold: true)
      Label(text: text, font_size: 15)
    end
  end
end
```

- Başkalarının require ettiği bir dosyada `include OzdenUI` en üste değil, sınıfın (ya da sizin bir modülünüzün) içine
  gider.
- Çok sayıda program için onu, gemspec'inde `spec.add_dependency "ozdenui"` olan kendi gem'iniz yapın ve her programın
  Gemfile'ına `gem "your_widgets"` yazın.
- Her public metodun üstündeki bir yorum, gem'in metotlarının yaptığı gibi, kullanıcısına ne aldığını söyler.

## Hangisi Ruby'nin, hangisi sayfanın

**"Bir tıklama, sonra bir değişiklik" Ruby'nindir.** Bloğunuz çalışır ve blok bitince sayfa değişikliği gösterir.

**"Her kare, her fare hareketi" sayfanındır.** Ruby'den gönderilen çok adımlı bir hareket takılırdı. Sayfaya nasıl
hareket edeceğini söyleyin, sonra sonu verin:

```ruby
ball.set_motion("left 0.3s, opacity 0.2s") # bu değerler artık yumuşakça değişir
ball.left = 300                            # sayfa onu 0.3 sn'de oraya taşır
```

Bir `Canvas` bunu kendiliğinden yapar: serbest çizgileri sayfa çizer ve sürüklenen şekilleri sayfa taşır; Ruby yalnız
sonlarını duyar.

### Hemen cevap vermesi gereken bir callback

Bileşenlerin bazı callback'leri hemen bir cevap döndürmelidir (bir listenin satırını çizen bir blok, bir tıklamayı
durduran bir denetim). Ruby'nin cevabı biraz sonra gelir, bu yüzden böyle bir callback programınızın bir bloğu olamaz:
bunun yerine değerleri sayfaya gitmeden önce Ruby'de biçimlendirin ve bileşenlerin verdiği parametreleri kullanın
(10. bölüm onları sayar).

## Sonraki

[10. bölüm: Daha ileri](10-going-further.md).
