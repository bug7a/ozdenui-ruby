# OzdenUI for Ruby — El Kitabı

Düz Ruby ile bir masaüstü penceresi kurun: nesneler, gruplar ve hazır bileşenler. Yalnız Ruby: JavaScript yok, HTML
yok, CSS yok, derleme adımı yok, derleyici yok. Bu kitap, Ruby bilen ama hiç web sayfası yazmamış kişiler için konuyu
adım adım anlatır.

*English: [OzdenUI for Ruby — The Handbook](../README.md)*

```ruby
require "ozdenui"
include OzdenUI

run(title: "Merhaba", width: 360, height: 200) do
  VGroup(gap: 12) do
    Label(text: "Ruby'den merhaba", font_size: 24, bold: true)
    SmartButton(label_text: "Kapat", on_click: -> { close })
  end
end
```

## Bölümler

| | Bölüm | Öğrendikleriniz |
|---|---|---|
| 1 | [İlk pencere](01-first-window.md) | kurulum, `run`, bloğu, pencerenin seçenekleri, pencere ile kodunuz nasıl konuşur |
| 2 | [Nesneler](02-objects.md) | `Box`, `Label`, `Button`, `Input`, `Icon`; adlı değerler; verdiğiniz ve okuduğunuz değerler; silmek |
| 3 | [Yerleşim](03-layout.md) | `VGroup`, `HGroup`, `GridGroup`, `fill: true`, `ScrollArea`, kendi yeri olan nesne |
| 4 | [Olaylar ve zaman](04-events-and-time.md) | tıklamalar ve tuşlar, olay, `every` ve `after`, bir thread ve `ui { }` |
| 5 | [Bileşenler](05-components.md) | hazır parçalar: düğmeler, alanlar, seçimler, listeler, tablolar, sekmeler, çubuklar |
| 6 | [Diyaloglar, mesajlar ve dosyalar](06-dialogs-and-files.md) | `confirm`, kısa mesajlar (toast), balonlar, sistemin dosya pencereleri |
| 7 | [Görünüm](07-looks.md) | koyu pencereler, sizin renginizde minimal görünüm, tek bir bileşenin renkleri |
| 8 | [Veri ve resimler](08-data-and-pictures.md) | grafikler, büyük tablolar, kayıtlar, Markdown, JSON, kod, resimler |
| 9 | [Kendi bileşeniniz](09-your-own-component.md) | nesnelerden yapılmış kendi sınıfınız, bir dosya ya da bir gem olarak paylaşmak |
| 10 | [Daha ileri](10-going-further.md) | Ruby'den basic.js, hız, thread'ler, sınırlar, hata bulmak |

1'den 4'e kadar sırayla okuyun: bütün fikir onlarda. Sonra gereken bölümleri seçin.

## Nasıl okunur

- `require "ozdenui"` ile başlayan her program eksiksizdir: onu `app.rb` olarak kaydedin ve `ruby app.rb` ile
  çalıştırın (`gem install ozdenui`'den sonra). Gem'in bir denetimi bunların hepsini çalıştırır ve çizer, bu yüzden
  doğru kalırlar.
- Gem'in örnekleri (kaynağındaki `examples/` klasörü) daha uzun programlardır: bir yapılacaklar listesi, bir hesap
  makinesi, bir CSV görüntüleyici, bir düzenleyici, küçük bir oyun. Bölümler onları yeri geldikçe anar. Deponun bir
  kopyasından: `ruby -Ilib examples/todo.rb`.
- `kod` biçimindeki bir ad, Ruby'deki bir addır. Penceredeki sayfa küçük bir JavaScript kütüphanesi olan
  [basic.js](https://bug7a.github.io/basic.js/) ile yapılır. Hiç JavaScript yazmanız gerekmez; 10. bölüm yine de ona
  nasıl ulaşacağınızı gösterir.
- Her bileşenin her parametresi terminaldedir: `ozdenui doc SelectBox`, ve
  [COMPONENTS.md](https://github.com/bug7a/ozdenui-ruby/blob/main/lib/ozdenui/COMPONENTS.md)'dedir. Gem:
  [rubygems.org/gems/ozdenui](https://rubygems.org/gems/ozdenui). Site: https://bug7a.github.io/ozdenui-ruby/

## Bir dakikada

- `run(title: ..., width: ..., height: ...) do |page| ... end` bir pencere açar. Bloğu nesneleri yapar; `page`
  pencerenin zeminidir.
- Bir nesne yazıldığı yerde yapılır: bir kutunun ya da bir grubun bloğunun içindeyse o kutuya ya da gruba girer.
- Bir grup nesnelerini yerleştirir: `VGroup` alt alta, `HGroup` yan yana.
- Bir değer, nesne yapılırken adlı bir değerdir (`Label(font_size: 20)`), sonra bir setter
  (`label.font_size = 24`, `label.set(text: "Selam", font_size: 24)`).
- Bir olay bir lambda, bir metot ya da bir bloktur: `on_click: method(:save)`. Hiçbir şey almayabilir, nesneyi ya da
  nesneyle olayı alabilir.
- Bileşenler durumlarını Ruby'de tutar: `box.checked?`, `select_box.value`, `field.text`. Bunu okumak sayfaya bir şey
  sormaz.
- Kodunuz tek bir thread'de çalışır: bir olay, bir zamanlayıcı ve `run`'ın bloğu hiçbir zaman aynı anda çalışmaz.
