# 3. Yerleşim

Kendi yeri olan bir nesne (`Box(20, 20, ...)`) bir oyun ya da bir çizim için iyidir. Bir programın penceresi
**gruplarla** daha kolaydır: gruplar nesnelerini yerleştirir ve pencerenin boyu değişince yeniden yerleştirir.

## VGroup ve HGroup

```ruby
VGroup(gap: 10, padding: 20, align: "left top") do
  Label(text: "Bir")
  Label(text: "İki") # "Bir"in altında, 10 px aşağıda
  HGroup(hug: true, gap: 8) do
    SmartButton(label_text: "Evet")
    SmartButton(label_text: "Hayır") # "Evet"in yanında
  end
end
```

- `VGroup` nesnelerini alt alta, `HGroup` yan yana koyar.
- Bir grup kutusu kadar büyüktür: `width: "100%"`, `height: "100%"`. `hug: true` onu yalnız nesneleri kadar büyük
  yapar.
- `gap:`: nesnelerin arasındaki boşluk. `padding:`: kenarının içindeki boşluk: `20` ya da `[x, y]` (`[30, 12]`).
- `align:`: nesnelerin durduğu yer: `"center"` (varsayılan), `"left top"`, `"right center"`, `"center bottom"`...
- `wrap: true`: yer kalmayınca nesneler bir sonraki satıra geçer (kartlar, etiketler).
- Bir grup bir `Box`'tır: `color:`, `round:`, `border:` onda da çalışır.

Bir grupta bir nesnenin yalnız boyutu gerekir: `Label(text: "Bir", width: 200)`. Boyutu yoksa içeriği kadar büyüktür.

**Bir grubun içindeki grup** neredeyse her zaman bunlardan birini ister: `hug: true` (nesneleri kadar büyük), bir
yükseklik (`height: "auto"` ya da bir sayı) ya da `fill: true` (aşağıda). Bir `VGroup`'taki %100'lük iki grup
birbirini sıkıştırır.

**Sığandan fazlası:** kutusunun tutabileceğinden fazlası olan bir grup nesnelerini sıkıştırır ve biri öbürünü
örtebilir (bir kartın altında kalan bir başlık). Pencereye daha çok yer verin ya da içeriği bir `ScrollArea`'ya koyun
(aşağıda).

## Kalan yeri almak: fill

Tipik bir pencere: üstte bir çubuk, ortada bütün yeri alan bir parça, altta bir satır.

```ruby
require "ozdenui"
include OzdenUI

FOLDERS = ["Hepsi", "İş", "Ev"].freeze

run(title: "Notlar", width: 640, height: 420) do |page|
  page.color = "#F4F5F7"
  VGroup(gap: 0) do
    HGroup(height: 52, padding: [16, 0], gap: 10, align: "left center", color: "white") do
      Label(text: "Notlar", font_size: 18, bold: true)
      SmartButton(label_text: "Yeni", tone: "cyan")
    end
    HGroup(gap: 0, fill: true) do
      VGroup(width: 180, height: "100%", padding: 16, gap: 8, align: "left top", color: "#E9EBEF") do
        FOLDERS.each { |folder| Label(text: folder, font_size: 15) }
      end
      ScrollArea(padding: 16, gap: 12) do
        (1..40).each { |number| Label(text: "Not #{number}", font_size: 15) }
      end
    end
    Label(text: "40 not", font_size: 13, text_color: "#5A6270", height: 28)
  end
end
```

- `fill: true` bir nesneye öbürlerinin bıraktığı yeri verir: bir `VGroup`'ta kalan **yüksekliği** (çubukla alt satır
  arasındaki orta sıra), bir `HGroup`'ta kalan **genişliği**. Her nesne ve her bileşen alır: `HGroup(fill: true)`,
  `LogView(fill: true)`, `Splitter(fill: true)`.
- `fill:` nesne yapılırken verilir; sonradan bir setter'la değiştirilemez.
- `ScrollArea` öbürlerinin bıraktığı yeri kendiliğinden alır (genişliği ve yüksekliği kalanın `"100%"`'üdür) ve
  içindekini kaydırır. Sayfanın bir nesnesi olarak (bir grupta değil) bütün penceredir.
- Nesneleri, bir `VGroup`'taki gibi sol üstten başlayarak alt alta dizilir: ona `align:`, `gap:` ve `padding:` verin
  (padding onlarla birlikte kayar). `scroll_x: true` yana da kaydırır. Kitin kaydırma çubuğu vardır; pencereyle birlikte
  açık ya da koyudur.

## GridGroup: sütunlar ve satırlar

```ruby
require "ozdenui"
include OzdenUI

KEYS = "789/456*123-0.=+".chars.freeze

run(title: "Tuşlar", width: 320, height: 300) do
  VGroup(padding: 16, align: "left top") do
    GridGroup(columns: 4, gap: 8) do |grid|
      KEYS.each { |key| SmartButton(label_text: key, width: "100%") }
      clear_key = SmartButton(label_text: "Sil", width: "100%", tone: "orange")
      grid.place(clear_key, column_span: 4)
    end
  end
end
```

- Nesneler sırayla hücrelere girer: soldan sağa, satır satır.
- `columns: 4`: eşit sütunlar. `columns: [120, "1fr", "auto"]`: 120 px, kalan yer, içeriği kadar geniş.
- Bir nesne hücresini doldurur; grid'e verilen `align: "left center"` her birini bunun yerine hücresinin içine koyar.
- `grid.place(obj, column_span: 2)`, `grid.place(obj, column: 1, row: 0)`: kendine ait bir hücre (0'dan sayılır).
- **Bir grubun bloğu grubu alır** (`|grid|`), bu yüzden grup bir değişkene girmeden önce de kullanılabilir. `current`
  da aynıdır: şu an yapılan nesneleri alan kutu.
- Öbür gruplardan farklı olarak, bir grid satırları kadar yüksektir (`height: "auto"`). `padding:`, `color:` ve
  `round:` bir gruptaki gibi onda da çalışır. `examples/calculator.rb` bütün bir hesap makinesidir.

## Gruptan taşanlar

Bir grup kenarından taşanı kesmez: bir düğmenin odak halkası, bir gölge ya da farenin altında büyüyen bir düğme, küçük
bir grupta da bütün görünür:

```ruby
HGroup(hug: true, gap: 8) do
  SmartButton(label_text: "Kaydet", tone: "cyan")
  SmartButton(label_text: "Vazgeç")
end
```

`clip_content: true`, kesmenin istendiği yerde keser (çerçevedeki bir resim). Kayan bir grup (`scroll_y: true`) ve
bir `ScrollArea` kendiliğinden keser.

Bir program daha az şey söylesin diye iki varsayılan basic.js'inkiler değildir:

- basic.js'in bir `VGroup` / `HGroup`'u içeriğini keser; Ruby'de kesmez.
- `MenuBar`, `ToolBar`, `StatusBar`, `SearchInput` ve `FilePicker` bir grupta küçülmez (`shrink: 0`): bir
  `ScrollArea` ya da `fill: true` olan bir nesne kalanı alırken yüksekliklerini korurlar.

## Kendi yeri olan nesne

Bir grubun dışında, bir `Box`'ta ya da sayfada, bir nesne onu koyduğunuz yerde durur: sol, üst, genişlik, yükseklik.
Bir oyunun, bir çizimin ya da üste binen bir parçanın yolu budur:

```ruby
Box(width: 400, height: 300, color: "#1E2230") do
  @player = Box(180, 130, 40, 40, color: "#5BBAC1", round: 8)
end
@player.left = 200 # onu kutusunun solundan 200 px'e taşır
```

`@player.left` kodunuzun verdiğini sayfaya sormadan geri okur, bu yüzden yeri tutmak için iyi bir yerdir:
`@player.left += 20`. `examples/game.rb` bir kutuyu ok tuşlarıyla böyle taşır. Bir boyut metin olabilir:
`width: "100%"` kutusunu doldurur.

## Pencerenin boyu değişince

Gruplar nesnelerini kendiliğinden yeniden yerleştirir. Kendi hesaplarınız için `page.width` ve `page.height` her zaman
günceldir ve `page.on(:resize)` size haber verir:

```ruby
require "ozdenui"
include OzdenUI

def show_size(page)
  @size.text = "#{page.width.round} x #{page.height.round}"
end

run(title: "Boyut", width: 420, height: 240) do |page|
  page.color = "#F4F5F7"
  @size = Label(20, 60, font_size: 28, bold: true)
  Label(20, 20, text: "Pencerenin boyunu değiştirin.", font_size: 15, text_color: "#5A6270")
  show_size(page)
  page.on(:resize, method(:show_size))
end
```

`page.on(:resize, ...)`, her olayın aldığı türden işleyicileri alır (4. bölüm): burada sayfayı alan bir metot.

## Sonraki

[4. bölüm: Olaylar ve zaman](04-events-and-time.md): tıklamalar, tuşlar, zamanlayıcılar ve uzun işler.
