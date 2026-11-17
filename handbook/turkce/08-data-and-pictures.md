# 8. Veri ve resimler

Bu bölümün bileşenleri bir Ruby programında genellikle olanları gösterir: sayılar, satırlar, kayıtlar, metinler, kod ve
resimler. Hiçbiri başka bir gem istemez: onları sayfa çizer.

## Grafikler: GraphBox

```ruby
GraphBox(type: "bar", labels: ["Oca", "Şub", "Mar"], values: [1200, 1900, 700], format_value: "{:,.0f} TL")
```

- `type:`: `"line"`, `"area"`, `"bar"`, `"pie"`, `"doughnut"`, `"radar"`, `"scatter"`, `"bubble"`.
- `values:` herhangi sayılardan bir Array'dir. Daha çok çizgi ya da çubuk:
  `datasets: [{ label: "2025", data: [8, 11, 9] }, { label: "2026", data: [10, 14, 12] }]`.
- `format_value:` bir blok değil bir biçim metnidir, çünkü sayfa çizerken bir sayının metnine ihtiyaç duyar:
  `"{}"`, `"{:.2f}"`, `"{:,}"`, `"{:,.0f} TL"`, `"{:.1%}"`. Bir biçim alan bir metot onu `number_format` ile alır:
  `graph.set_format_value(number_format("{:.0f} kg"))`.
- Sonra: `graph.set_values([...])`, `graph.set_type("line")`, `graph.add_value("Nis", 15)`.
  `on_click: ->(graph, item) { }`: `item[:label]`, `item[:value]`.

### Canlı bir grafik ve bir kayıt

```ruby
require "ozdenui"
include OzdenUI

POINTS = 30
FIRST_ONES = 12 # başta, birer saniye arayla çizilen değerler

def measure_at(time)
  value = (20 + rand * 6 - 3).round(1)
  @chart.add_value(time.strftime("%H:%M:%S"), value) # en eskisi POINTS değerden sonra gider
  if value > 22
    @log.warn(format("Sıcak: %.1f°", value))
    return
  end
  @log.info(format("%.1f°", value))
end

run(title: "Bir algılayıcı", width: 560, height: 520) do |page|
  page.color = "#F4F5F7"
  VGroup(gap: 12, padding: 20) do
    @chart = GraphBox(type: "area", title_text: "Sıcaklık", labels: [], values: [], curve: "smooth",
                      show_points: false, max_count: POINTS, format_value: "{:.1f}°", width: "100%", height: 240)
    @log = LogView(fill: true)
  end
  FIRST_ONES.downto(1) { |back| measure_at(Time.now - back) }
  every(1000) { measure_at(Time.now) }
end
```

`examples/charts.rb`'de canlı bir grafik, tıklanabilen çubuklar, bir halka, hedefi olan iki çizgi ve bir PNG dosyası
olarak kaydedilen bir grafik vardır (`graph.get_image("image/png", 2)` onun veri adresini verir).

## Tablolar

Bir satır bir Hash ya da programınızın bir Struct'ıdır: üyeleri, sütunların andığı anahtarlardır. `on_select:` satırı
bir Hash olarak geri verir; bir metinle ya da bir sembolle okunur:

```ruby
require "ozdenui"
include OzdenUI

Person = Struct.new(:name, :city, :orders)

COLUMNS = [
  { name: "Ad", dataTitle: "name", width: 180, sortable: 1 },
  { name: "Şehir", dataTitle: "city", width: 160, sortable: 1 },
  { name: "Sipariş", dataTitle: "orders", dataType: "integer", width: 100, sortable: 1 }
].freeze

@people = [Person.new("Ada", "Londra", 12), Person.new("Alan", "Manchester", 7), Person.new("Grace", "New York", 21)]

def show_person(_table, row)
  @chosen.text = "#{row[:name]}, #{row[:city]}: #{row[:orders]} sipariş"
end

def add_person
  @people << Person.new("Kişi #{@people.length + 1}", "İzmir", 0)
  @table.item_data_list = @people # bütün liste yeniden: tablo onu çizer
end

run(title: "Kişiler", width: 520, height: 420, language: "tr") do |page| # "tr": başlıklar "SİPARİŞ" olarak büyür
  page.color = "#F4F5F7"
  VGroup(gap: 12, padding: 20, align: "left top") do
    @table = SmartTable(title_data_list: COLUMNS, item_data_list: @people, width: "100%", height: 260,
                        on_select: method(:show_person))
    HGroup(hug: true, gap: 12, align: "left center") do
      SmartButton(label_text: "Bir tane ekle", on_click: method(:add_person))
      @chosen = Label(text: "Bir satıra tıklayın.", font_size: 15)
    end
  end
end
```

- **`SmartTable`** yalnız görünen satırları yapar, bu yüzden çok büyük bir liste de hızlı kalır
  (`examples/csv_viewer.rb`'de 100000 satır için bir düğme vardır). Bir süzgeç kutusu ve başlıklarında sıralama vardır.
- Bir sütun: `name` (başlığı), `dataTitle` (satırın anahtarı), `width`, `dataType` (`"string"`, `"integer"`...),
  `sortable`. Bir sütunun anahtarları, kitin yazdığı gibi kitin adlarıdır. Değerler metin olarak gösterilir: onları
  Ruby'de biçimlendirin (`format("%.2f", price)`).
- **`DataTable`** birkaç yüz satıra kadar içindir; sütunları metinlerine uyar.
- `examples/csv_viewer.rb` bir CSV dosyasını bir SmartTable'da açar (Ruby'nin `csv` kütüphanesiyle).

## Resimler

Bir resim bir dosya yolu, bir SVG'nin metni, baytlar (bir PNG ya da bir JPEG: `File.binread` ya da programınızın
yaptığı bir resim) veya bir web adresi olabilir. `picture()` bunların her birini sayfanın gösterebileceği bir adrese
çevirir:

```ruby
Icon(width: 48, height: 48, picture: "logo.png")             # picture: bir yol, bir SVG ya da baytlar alır
view = ImageView(height: 400, image_file: "photo.jpg")         # _file ile biten bir parametre: bir yol
view.set_image(picture(png_bytes))                           # bir metotta: picture()
```

- Bir `ImageView` tekerlekle ya da iki parmakla yakınlaşır ve sürüklenerek kayar. Yeni bir resim yakınlığı ve yeri
  korur, böylece bir program çizimini tekrar tekrar çizebilir.
- Sayfa bu bilgisayardaki bir dosyayı yolundan okuyamaz, bu yüzden Ruby onu okur ve içeriğini bir `data:` adresi
  olarak verir. `_file` ile biten bir parametre ve bir `Icon`'un `picture:`'ı bunu kendiliğinden yapar; başka her
  yerde (bir listenin öğesi, bir stil, bir metot) `picture(path)` verin.
- Adres bütün resmi taşır: çok kez gösterdiğiniz bir resim için `picture(...)`'ı bir değişkende tutun.

```ruby
require "ozdenui"
require "zlib"
include OzdenUI

SIZE = 240

@shade = 0

# RGB piksel satırlarından bir PNG dosyasının baytları: düz Ruby ile, zlib ile yapılmış bir resim.
def png_chunk(name, data)
  [data.bytesize].pack("N") + name + data + [Zlib.crc32(name + data)].pack("N")
end

def png_bytes(rows)
  header = [SIZE, SIZE, 8, 2, 0, 0, 0].pack("NNCCCCC")
  pixels = rows.map { |row| "\0".b + row }.join
  "\x89PNG\r\n\x1A\n".b + png_chunk("IHDR", header) + png_chunk("IDAT", Zlib::Deflate.deflate(pixels)) + png_chunk("IEND", "")
end

# Bir resmi piksel piksel çizer, sizin bir programınızın yapacağı gibi.
def gradient(shade)
  rows = (0...SIZE).map do |y|
    (0...SIZE).map { |x| [x, y, shade].pack("C3") }.join
  end
  png_bytes(rows)
end

def draw_again
  @shade = (@shade + 80) % 256
  @view.set_image(picture(gradient(@shade)))
end

run(title: "Ruby'nin bir resmi", width: 420, height: 420) do |page|
  page.color = "#F4F5F7"
  VGroup(gap: 12, padding: 20) do
    @view = ImageView(width: 300, height: 300, image_file: picture(gradient(@shade)))
    SmartButton(label_text: "Yeniden çiz", on_click: method(:draw_again))
  end
end
```

`examples/image_viewer.rb` bir resim dosyası açar ya da bir çizimi tekrar tekrar çizer.

## Kayıtlar: LogView

```ruby
log = LogView(height: 300)
log.info("Dosya okunuyor")
log.success("Bitti")
log.error("Dosya orada değil")
log.writer(:warn).puts("Disk dolu") # $stdout gibi bir çıktı: bir thread'den de
$stdout = log.writer(:info)          # bütün programın puts'u ona gider
```

Seviyeler `:info`, `:success`, `:warn`, `:error` ve `:debug`'dır. Görünüm, okuyan yukarı kaydırana kadar son satırı
izler. Bir metin hiçbir zaman HTML olarak okunmaz. `log.writer(level)` her thread'den kullanılabilir: kendiliğinden
`ui { }`'den geçer ve onun her satırı görünümün bir satırıdır. `examples/job_log.rb`.

## Metinler, JSON ve kod

| | |
|---|---|
| `MarkdownView(markdown_text: "# Bir rapor\n\nBirkaç **kalın** kelime")` | `view.append_text(piece)` sonuna ekler: bir yapay zekânın cevabı, geldikçe; `view.markdown_text = text` |
| `JsonView(value: data, height: 400, on_select: fn)` | Hash'lerden, Array'lerden, metinlerden ve sayılardan herhangi bir Ruby değeri; bir tıklama: `->(view, entry) { }`, `entry[:pathText]` (`users[0].name`) |
| `JsonEditor(value: rows, height: 360, on_change: fn)` | bir tabloda yazılan bir JSON listesi ya da Hash'i; `->(editor, value) { }` bütün değeri alır |
| `CodeEditor(value: "x = 1", language: "python", height: 300, on_change: fn)` | metni sorulur: `editor.get_value`; Python, JavaScript, Go, JSON, HTML, CSS, SQL, Bash |
| `ChatView(empty_text: "Bir şey sorun", on_send: fn)` | `->(chat, text) { }`; bir cevap: `chat.add_message(key: key, role: "assistant")`, sonra `chat.append_text(key, piece)`; `chat.busy = true` noktaları ve Stop'u gösterir |
| `WebView(html_text: page, height: 400)` | bir web sayfası (`url:`) ya da betikleriyle bir HTML metni; `on_message: ->(view, data) { }` sayfasının `parent.postMessage` ile gönderdiğini alır |

- **Büyük ya da hızlı bir değer tutulmaz, sorulur**: bir `CodeEditor` metnini her tuşta göndermez. Gerektiğinde, onun
  `on_change`'inde ya da kullanıcı kaydederken sorun (`change_delay: 120` yazmanın durulmasını bekler).
- `CodeEditor`'ün henüz Ruby için renkleri yoktur: `language: "text"` bir Ruby programını renksiz gösterir.
- Bir Markdown metni hiçbir zaman HTML olarak okunmaz ve hiçbir betiği çalışmaz. Sayfa bir dosyayı yolundan okuyamaz:
  bu bilgisayardaki bir resim metne `picture(path)` olarak girer (`examples/markdown_editor.rb` bunu yapar). `http`
  adresli bir resim bir bağlantı olarak kalır (güvendiğiniz bir metin için `remote_pictures: true`).
- Bir `ChatView` cevabının parçaları bir thread'den `ui { }` ile gelebilir: pencere çalışmaya devam eder ve görünüm,
  okuyan yukarı kaydırana kadar sonu izler (`examples/chat.rb`).
- `examples/markdown_editor.rb`, `examples/json_viewer.rb` ve `examples/editor.rb` (Python programını çalıştıran küçük
  bir düzenleyici) bunları gösterir.

## Çizim: Canvas

```ruby
Canvas(width: "100%", height: 300, shapes: [
  { key: "sun", type: "circle", x: 100, y: 80, radius: 30, fill: "orange", draggable: 1 },
  { key: "path", type: "line", x1: 20, y1: 200, x2: 260, y2: 200, color: "tomato", lineWidth: 4 },
  { key: "title", type: "text", x: 20, y: 12, text: "Güneşi sürükleyin", fontSize: 16 }
], on_shape_move: ->(_canvas, shape) { puts "taşındı: #{shape[:key]}" })
```

Sayfa `draggable` bir şekli kendiliğinden taşır; `on_shape_move` Ruby'ye nerede durduğunu söyler. `drawing: true`
fareye bir kalem verir. Metotları (`add_shape`, `move_shape`, `remove_shape`, `get_image`...) nesnenin metotlarıdır.
Bir şeklin anahtarları, her öğede olduğu gibi kitin adlarıdır (`lineWidth:`, `fontSize:`).

## Sonraki

[9. bölüm: Kendi bileşeniniz](09-your-own-component.md).
