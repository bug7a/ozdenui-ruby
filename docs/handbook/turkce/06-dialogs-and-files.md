# 6. Diyaloglar, mesajlar ve dosyalar

## Diyaloglar cevaplarını döndürür

OzdenUI'de bir diyalog, cevabı döndüren bir metot çağrısıdır; bir terminalde `gets`'in yaptığı gibi:

```ruby
if confirm("Dosya silinecek.", title: "Silinsin mi?", confirm_text: "Sil", danger: true)
  delete_the_file
end

name = prompt("Klasör için bir ad:", value: "Fotoğraflar", required: true) # nil: vazgeçildi
choice = ask("Değişiklikler kaydedilsin mi?", "Kaydet", "Kaydetme", "Vazgeç") # düğmenin metni
choice = ask("Kaydedilsin mi?", "Kaydet", "Kaydetme", title: "Kaydedilmemiş değişiklikler")
alert("Kopyalama bitti.", title: "Bitti")
```

- **Kodunuz beklerken pencere çalışmaya devam eder**: başka olaylar ve zamanlayıcılar çalışır, bir saat işlemeyi
  sürdürür. Cevabı yalnız soran metot bekler.
- Metinler adlı değerlerdir: `title:`, `confirm_text:`, `cancel_text:`; `prompt` için ayrıca `value:`,
  `placeholder:`, `field_text:` ve `required:` (boş bir cevap alınmaz). Yazmadığınız, kitin metnini korur.
- `danger: true` onay düğmesini bir silme olarak çizer. `ask` ilk düğmesini ana düğme yapar.
- Escape ya da dışarıya bir tıklama "hayır"dır: `confirm` için `false`, `prompt` ve `ask` için `nil`.
- Bir diyalog, buradaki gibi bir olaydan ya da bir zamanlayıcıdan sorulur. Sizin bir thread'iniz pencereye yalnız
  `ui { }` ile ulaşır (4. bölüm).

`examples/dialogs.rb`'de her biri için bir düğme vardır ve cevabı Ruby'nin yazdığı gibi (`inspect`) gösterir.

## Kısa mesajlar: toast'lar

```ruby
toast("Kaydedildi.")                                        # type: :success (varsayılan)
toast_error("Dosya kaydedilemedi.", title: "Hata")          # mesajla birlikte bir başlık gelebilir
toast_warning("Disk dolmak üzere.")
toast_info("3 yeni mesaj")
toast("Kaydedildi.", type: :info)                           # toast_info ile aynı
```

Bir toast bir köşeden gelir ve kendiliğinden gider. Hiç beklemez: kod hemen devam eder.

## Balonlar: show_hint ve Tooltip

```ruby
save = SmartButton(label_text: "Kaydet")
Tooltip(target: save, hint_text: "Dosyayı kaydeder (Ctrl+S)") # farenin altında, kendiliğinden

show_hint(save, "Kaydedildi.", 2000)                    # şimdi düğmede, 2 sn ("top" tarafıdır)
hint = show_hint(save, "Çalışıyor", 0, side: "bottom")  # 0: hint.remove'a kadar kalır
```

- `trigger: "click"` olan bir `Tooltip` bir popover'dır: hedefine bir tıklama onu açar ve dışarıya bir tıklamaya
  kadar kalır. `hint_position:` tarafıdır: `"top"`, `"bottom"`, `"left"`, `"right"`.
- v0.1'de bir balon bir metin gösterir. Sizin nesnelerinizi tutan bir balon henüz yok.

## Sistemin dosya pencereleri

```ruby
path = open_file(types: ["png", "jpg"])                     # bir yol ya da nil (vazgeçildi)
paths = open_files                                          # bir Array; vazgeçilince boş
target = save_file(file_name: "rapor.csv", types: ["csv"])
folder = choose_folder(title: "Fotoğraflar nerede?")
```

- Bunlar bilgisayarın pencereleridir (Linux'ta: `zenity`), bu yüzden yollar gerçektir: onları `File` ile okuyun ve
  yazın.
- Adlı değerleri: `title:`, `directory:` (açıldığı klasör), `file_name:` (`save_file`'ın önerdiği ad), `types:`
  (gösterdiği uzantılar).
- `save_file` yalnız yolu verir: dosyayı programınız yazar.

### Küçük bir düzenleyici

```ruby
require "ozdenui"
include OzdenUI

PAGE_COLOR = "#F4F5F7"
FILE_TYPES = ["txt", "md"].freeze

@path = nil # notun dosyası; açılana ya da kaydedilene kadar nil

def open_note
  chosen = open_file(types: FILE_TYPES)
  return if chosen.nil?
  begin
    content = File.read(chosen, encoding: "UTF-8")
  rescue SystemCallError => error
    toast_error(error.message, title: "Açılamadı")
    return
  end
  @path = chosen
  @note.value = content
  @note.title_text = File.basename(@path)
end

def save_note
  @path ||= save_file(file_name: "not.txt", types: FILE_TYPES)
  return if @path.nil?
  begin
    File.write(@path, @note.text)
  rescue SystemCallError => error
    toast_error(error.message, title: "Kaydedilemedi")
    return
  end
  @note.title_text = File.basename(@path)
  toast_success("Kaydedildi.", title: File.basename(@path))
end

def clear_note
  return unless confirm("Penceredeki metin gider.", title: "Not temizlensin mi?", confirm_text: "Temizle", danger: true)
  @note.value = ""
end

run(title: "Not", width: 560, height: 420) do |page|
  page.color = PAGE_COLOR
  VGroup(gap: 12, padding: 20, align: "left top") do
    HGroup(hug: true, gap: 8) do
      SmartButton(label_text: "Aç", on_click: method(:open_note))
      SmartButton(label_text: "Kaydet", tone: "cyan", on_click: method(:save_note))
      SmartButton(label_text: "Temizle", tone: "orange", on_click: method(:clear_note))
    end
    @note = TextAreaField(title_text: "Not", width: "100%", height: 260)
  end
end
```

`@note.text` sayfaya bir şey sormaz: kullanıcı yazarken alan metnini programa söyler. `examples/csv_viewer.rb`,
`examples/image_viewer.rb` ve `examples/markdown_editor.rb` dosyalarını aynı yolla açar.

## Pencerenin üstünde bir bekleme: LoadingScreen

```ruby
loading = LoadingScreen(title_text: "Kopyalanıyor", message_text: "Başlıyor...", progress: 0)
Thread.new do
  (1..4).each do |step|
    copy_one_file(step) # yavaş iş, thread'in içinde
    ui do
      loading.set_progress(step / 4.0) # 0 .. 1
      loading.set_message_text("Dosya #{step} / 4")
    end
  end
  ui { loading.close }
end
```

Nerede yapılırsa yapılsın bütün pencereyi örter. `progress: -1` (varsayılanı) çubuk göstermez; `min_duration:` (ms)
onu bir an tutar, böylece hızlı bir iş göz kırpmaz; `remove_on_close: true` onu `close`'dan sonra siler, bir kez
kullanılan bir ekran için.

## Dosya bırakılacak bir yer: FilePicker

`FilePicker`, üstüne dosya bırakılan ya da bir dosya için tıklanan bir yerdir. `picker.files` onun listesidir,
Hash'lerden bir Array: `name`, `path`, `size`, `sizeText`, `type`, `extension`, `lastModified`.

Bir tıklama sistemin dosya penceresini açar, bu yüzden seçilen dosyalar gerçek yollarıyla gelir; `picker.paths`
onları listeler. Üstüne bırakılan bir dosya sayfadan gelir ve sayfa bir dosyanın nerede olduğunu hiç bilmez: `path`'i
yalnız adıdır ve `picker.paths`'te değildir.

```ruby
require "ozdenui"
include OzdenUI

@rows = []

def show_files(picker)
  @rows.each(&:remove)
  @rows = []
  @list.add do
    picker.files.each do |file|
      @rows << Label(text: "#{file[:path]} (#{file[:sizeText]})", font_size: 14)
    end
  end
end

run(title: "Dosyalar", width: 520, height: 460) do |page|
  page.color = "#F4F5F7"
  VGroup(gap: 14, padding: 24, align: "left top") do
    FilePicker(width: "100%", zone_height: 140, multiple: true, show_list: false,
               title_text: "Dosyaları buraya bırakın", description_text: "ya da seçmek için tıklayın",
               on_change: method(:show_files))
    @list = VGroup(width: "100%", height: "auto", gap: 6, align: "left top") do
      @rows << Label(text: "Henüz dosya yok.", font_size: 14, text_color: "#5A6270")
    end
  end
end
```

- `accept: ".csv,.txt"` ya da `"image/*"`; `max_size:` (bayt) ve `max_files:`: geçmeyenler `on_error:`'a gider.
  `multiple: true` listeye ekler; o olmadan yeni bir dosya eskisinin yerini alır.
- `picker.clear` onu boşaltır; `title_text:`, `description_text:`: metinleri; `icon_file:`: sizin bir resminiz.
- `picker.add_files("rapor.pdf", "notlar.txt")` koddan bu bilgisayarın dosyalarını ekler.
  `on_open_dialog: ->(picker) { ... }` sistemin penceresinin yerine sizin bir pencerenizi koyar.
- Bırakılan bir dosyanın baytları Ruby'ye ulaşmaz. Bir dosyanın içeriği için onu yolundan okuyun (`File.read`): bir
  tıklama bir yol verir, bırakmak vermez.

## Sonraki

[7. bölüm: Görünüm](07-looks.md): koyu pencereler, minimal görünüm ve sizin renkleriniz.
