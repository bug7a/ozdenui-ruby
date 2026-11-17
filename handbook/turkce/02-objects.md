# 2. Nesneler

Her pencere beş düz nesneden yapılır: `Box`, `Label`, `Button`, `Input` ve `Icon`. 5. bölümün bileşenleri de bunlardan
yapılmıştır. Beşi de adlı değerler alır: `Label(text: "Selam", font_size: 20)`.

| Nesne | Nedir | Kendi değerleri |
|---|---|---|
| `Box` | bir dikdörtgen; başka nesneleri tutan tek nesne | `color:`, `border:`, `round:`, `scroll_y:` |
| `Label` | bir metin | `text:`, `html:`, `font_size:`, `bold:`, `text_color:`, `text_align:` |
| `Button` | sistemin düz bir düğmesi (daha güzeli `SmartButton`) | `text:` |
| `Input` | tek satırlık bir metin alanı | `text:`, `placeholder:`, `on_enter:` |
| `Icon` | bir resim | `picture:` (bir yol, bir SVG'nin metni, bir PNG'nin ya da JPEG'in baytları, bir adres) |

## Yer ve boyut

Bir grubun dışındaki nesnenin kendi yeri vardır: sol, üst, genişlik ve yükseklik, px olarak. Bunlar adı olmayan dört
değerdir, bu sırayla:

```ruby
Box(20, 20, 100, 100, color: "orangered")
Box(left: 20, top: 20, width: 100, height: 100, color: "orangered") # aynı kutu
```

Bir boyut metin de olabilir: `width: "100%"` (içinde olduğu kutunun genişliği), `height: "auto"` (içeriği kadar
yüksek). Yeri verilmemiş bir nesne, kutusunun sol üst köşesinden başlar.

## Değerler

Bir değer, nesne yapılırken adlı bir değerdir, sonra bir setter:

```ruby
title = Label(text: "Rapor", font_size: 24, bold: true, text_color: "#2B2B2B")
title.text = "Aylık rapor"                                   # ekranda değiştirir
title.set(text: "Yıllık rapor", font_size: 28, bold: false)  # birden çoğunu bir kerede
puts title.text                                              # "Yıllık rapor": Ruby'de okunur, sayfaya sorulmaz
puts title.font_size                                         # 28
```

- **Adlar:** basic.js'in ve kitin adları, snake_case yazılmış: `fontSize`, `font_size:`'dır; `textColor`,
  `text_color:`'dır. Yanlış bir ad kaybolmaz: terminal
  `ozdenui: app.rb:12: Label: font_szie is not a value of Label (did you mean font_size?)` yazar.
- **Sayılar ve açık / kapalı değerler:** px olarak bir boyut bir sayıdır; açık / kapalı bir değer `true` / `false`'tur.
- **Renkler:** her CSS rengi: `"red"`, `"#2A78D6"`, `"rgba(0, 0, 0, 0.5)"`.
- **Yazılmayan bir değer varsayılanını korur.** `nil` "yazılmadı" demektir; `""` boş bir metindir, yazılmıştır.
- **Okumak:** `title.font_size`, `title.get(:font_size)` ve `title[:font_size]` programın verdiği değerdir. `true` /
  `false` ile verilen bir değer sonuna `?` konarak okunur: `label.bold?`.

Her nesnede olan değerler:

| Değer | Örnek |
|---|---|
| `color:` | zemin: `color: "#FFFFFF"`, `color: "transparent"` |
| `border:`, `border_color:` | `border: 1, border_color: "#DDD"` |
| `round:` | köşeler: `round: 8`; `round: 100` bir kareden daire yapar |
| `opacity:` | `opacity: 0.5` |
| `visible:` | `visible: false` gizler; bir grupta öbürleri boşluğu kapatır |
| `clickable:` | olayı olan bir nesne tıklamaları kendiliğinden alır; `clickable: false` onları geçirir |
| `cursor:` | `cursor: "pointer"` |
| `css:` | CSS'in başka her şeyi: `css: { letter_spacing: "1px" }` |

Hash'i yeniden göreceksiniz: bir stil, bir listenin bir öğesi, bir tablonun bir satırı.

### Vermediğiniz bir değer

`title.text` cevabı Ruby'den verir, çünkü onu kodunuz verdi. Sayfanın belirlediği bir değer, ör. genişliği verilmemiş
bir etiketin genişliği, `measure` ile sorulur:

```ruby
width = title.measure(:width) # şu an ekrandaki genişlik, px olarak
```

Hiç verilmemiş bir değeri okumak `nil`'dir. `measure` sayfayı bekler: onu bir döngüde değil, gerektiğinde kullanın.
Sayfanın kendisi farklıdır: `page.width` ve `page.height` her zaman günceldir.

### Metin ve HTML

Bir `Label`'ın ya da bir `Button`'ın `text:`'i tam yazıldığı gibi gösterilir; bu yüzden bir kullanıcının yazdığı ya da
bir dosyadan okunan metin olduğu gibi verilir (bir `<b>`, `<b>` olarak kalır). HTML, `html:` ile verilir:

```ruby
note.text = typed_text
title.html = "<b>3</b> yeni"
```

basic.js'te `text` HTML'dir; Ruby'de düz metindir. Bileşenlerin metinleri de yazıldıkları gibi gösterilir
(`SmartButton(label_text: typed)`); `allow_html: true` onları HTML yapar.

## Bir Box'ın içindeki nesneler

Bir `Box`'ın bloğunda yapılan nesneler onun içine girer. Yerleri kutunun köşesinden sayılır:

```ruby
require "ozdenui"
include OzdenUI

# Tikli beyaz bir daire, bir SVG'nin metni olarak: dosya gerekmez.
CHECK = "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'>" \
        "<circle cx='12' cy='12' r='11' fill='white'/><path d='M7.5 12.5l3 3 6-7' fill='none' stroke='#2B2B2B' stroke-width='2.4'/></svg>"

def change
  typed = @input.text.strip
  typed = "Merhaba" if typed.empty?
  @label.text = typed
end

run(title: "Bir kart", width: 360, height: 220) do |page|
  page.color = "#F4F5F7"
  Box(20, 20, 320, 110, color: "#5BBAC1", round: 12) do
    Icon(20, 25, 60, 60, picture: CHECK)
    @label = Label(100, 36, 200, 38, text: "Merhaba", font_size: 26, bold: true, text_color: "white")
  end
  @input = Input(20, 150, 200, 40, placeholder: "Bir metin yazın", on_enter: method(:change))
  Button(230, 150, 110, 40, text: "Değiştir", on_click: method(:change))
end
```

- `Box(...) do ... end`: blok hemen çalışır ve yaptığı her şey kutuya girer. Blok isteğe bağlıdır:
  `Box(color: "white")` boş bir kutudur. Hiçbir değeri ve bloğu yoksa parantezleri gerekir: `Box()`.
- **Nesne tutan yalnız `Box`'tır (ve kutu olan gruplar).** Bir `Label` ya da bir `Button` blok almaz. Bir düğmenin
  üstüne bir şey koymak için onu düğmenin yanında, aynı kutuda, aynı yerde yapın.
- `picture:` bu bilgisayardaki bir yolu (`"photo.png"`), bir SVG'nin metnini, bir PNG'nin ya da JPEG'in baytlarını
  (`File.binread("photo.png")` ya da programınızın yaptığı bir resim) veya bir adresi alır.
- `on_enter: method(:change)`: alanda Enter, düğmenin yaptığını yapar.
- `examples/basics.rb` bu karttır; rengi her basışta değişir.

## Gizlemek, silmek, sonradan eklemek

```ruby
require "ozdenui"
include OzdenUI

def toggle
  return if @note.nil?
  if @note.visible == false
    @note.show
  else
    @note.hide
  end
end

def measure_note
  return if @note.nil?
  @info.text = "Not #{@note.measure(:width)} px genişliğinde."
end

def remove_note
  return if @note.nil?
  @note.remove
  @note = nil # silinmiş bir nesne yeniden kullanılmaz
  @info.text = "Not gitti."
end

run(title: "Gizle ve sil", width: 420, height: 300) do |page|
  page.color = "#F4F5F7"
  VGroup(gap: 14) do
    @note = Label(text: "Gizlenecek bir not", font_size: 22, color: "white", round: 8, padding: [14, 8])
    HGroup(hug: true, gap: 8) do
      SmartButton(label_text: "Gizle / göster", on_click: method(:toggle))
      SmartButton(label_text: "Ölç", on_click: method(:measure_note))
      SmartButton(label_text: "Sil", tone: "orange", on_click: method(:remove_note))
    end
    @info = Label(text: "Genişlik sayfaya sorulur.", font_size: 14, text_color: "#5A6270")
  end
end
```

- `hide` ve `show`, `visible`'ı değiştirir; gizlenmiş bir nesne değerlerini korur ve `show` onu geri getirir.
- `remove` nesneyi ve içindeki her nesneyi kalıcı olarak siler: yeniden göstermek için yenisini yapın. Silinmiş bir
  nesne yeniden kullanılmaz: yukarıdaki program onu unutur (`@note = nil`).
- `box.add { ... }`, bir kutuda ya da bir grupta sonradan, bir olayda ya da bir zamanlayıcıda, başka nesneler yapar:

```ruby
list.add do
  Label(text: "Bir tane daha")
end
```

## Bir kutunun gösterebileceğinden fazlası olunca

`scroll_y: true`, bir kutunun içeriğini aşağı yukarı kaydırır (`scroll_x: true` yana). Bir grupta, 3. bölümün
`ScrollArea`'sı aynısını yapar ve kendisine verilen yeri alır.

## Sonraki

[3. bölüm: Yerleşim](03-layout.md): gruplar nesneleri sizin için yerleştirir.
