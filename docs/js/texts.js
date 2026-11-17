/* Bismillah */

/*

OzdenUI for Ruby Website - Texts - v26.11

The texts of the page in English and Turkish (the same keys). TEXTS.fill(text) writes the facts of CONFIG into
{version}, {ruby}, {components}, {size}, {license}.

Started Date: November 2026
Webpage: https://bug7a.github.io/ozdenui-ruby/

Copyright 2026 Bugra Ozden <bugra.ozden@gmail.com> (https://bug7a.github.io/)
Licensed under the Apache License, Version 2.0
SPDX-License-Identifier: Apache-2.0

*/

"use strict";

const TEXTS = {

    en: {

        htmlLang: "en",
        pageTitle: "OzdenUI for Ruby – Modern desktop windows, in plain Ruby",
        pageDescription: "OzdenUI for Ruby opens a small, modern window of its own from Ruby: boxes, texts, buttons and the 83 ready components of basic.js, each a method of its name, with blocks. Only Ruby: no JavaScript, no HTML, no front-end build, no other gem and no compiler.",
        languageButton: "TR",
        languageHint: "Türkçe",
        nav: { code: "Code", why: "Why", components: "Components", examples: "Examples", start: "Start" },
        navBasicJs: "basic.js",
        navHandbook: "Handbook",
        navComponents: "Components of basic.js",
        navPython: "OzdenUI for Python",
        navGo: "OzdenUI for Go",
        navRubyGems: "RubyGems",
        menu: "Menu",
        copy: "Copy",
        copied: "The code is copied.",
        copyFailed: "The code could not be copied.",

        // HERO
        heroEyebrow: "v{version} · experimental · Ruby {ruby}+ · tested on macOS", // WHY  : on a phone "tested on macOS" goes to the second line together
        heroTitle: "Modern desktop windows, in plain Ruby", // WHY  : the line breaks before "in", and "Ruby" is never alone on a line
        heroLead: "Write the window in Ruby: boxes, texts, buttons and ready components appear in a small window of its own. Only Ruby: no JavaScript, no HTML, no CSS, no front-end build, no other gem and no compiler.",
        heroPrimary: "Get started",
        heroSecondary: "See the examples",
        heroFacts: ["{components} components, each a method", "basic.js inside: about {size}, no internet", "no other gem, no compiler", "{license}"],
        heroSlidesLabel: "The windows of the examples",
        heroShotAlts: {
            "hero-gallery": "The window of examples/gallery.rb: buttons, a check box, a toggle, radio buttons, a drop-down list, a slider, a progress bar, a note field and lists, in cards.",
            "hero-minimal-theme": "The window of examples/minimal_theme.rb: every component in the minimal look, small and made of lines.",
            "hero-charts": "The window of examples/charts.rb: a live line, bars, a doughnut and two lines with a target.",
            "hero-csv-viewer": "The window of examples/csv_viewer.rb: a table of cities with their countries and people, a filter under it.",
            "hero-chat-dark": "The window of examples/chat.rb in a dark window: a question and its answer, with a list, a table and code.",
        },

        // CODE
        codeEyebrow: "THE CODE IS THE WINDOW",
        codeTitle: "A counter in a few lines",
        codeLead: "Groups place the objects for you, and a lambda given to a button runs when it is clicked.",
        codePoints: [
            { title: "A group is a block", text: "The objects made in the block of a group go into it: the shape of the code is the shape of the window." },
            { title: "Values in Ruby", text: "@label.text = \"1\" changes the window; field.text and box.checked? are read in Ruby, with no question to the window." },
            { title: "One thread, no locks", text: "The block of run, an event and a timer run one at a time. The changes of a task go to the window together, when it ends." },
        ],
        codeShotAlt: "The window of the counter: the number 0 and two buttons, Minus and Plus.",

        // WHY
        whyEyebrow: "WHY",
        whyTitle: "Only Ruby, nothing to build",
        why: [
            { icon: "feather", title: "No other gem, no compiler", text: "gem install ozdenui and nothing else: no native extension to build, no Node, no npm. basic.js and its components are inside the gem (about {size}) and are served only to this computer: no internet." },
            { icon: "grid", title: "The Ruby you already have", text: "Ruby {ruby} or newer, also the Ruby that comes with macOS. On macOS the window is the web view of the system, called through fiddle; on Windows and Linux it is an app window of Edge or Chrome." },
            { icon: "code", title: "Code that reads like the window", text: "Groups are blocks, the names are those of basic.js in snake_case, events are lambdas, methods or blocks. A wrong name is told in the terminal with the line of your program and the name you meant." },
            { icon: "bolt", title: "Threads welcome", text: "A slow job runs in a Thread of its own and the window does not wait. ui { } brings its result back to the objects." },
        ],

        // COMPONENTS
        componentsEyebrow: "COMPONENTS",
        componentsTitle: "Ready components, called from Ruby",
        componentsLead: "Each one is a method of its name: the params of the kit in snake_case, a lambda or a method for a callback. Its state is read in Ruby: box.checked?, field.text, select_box.value. ozdenui doc SelectBox prints every param in the terminal.",
        componentsDarkTitle: "A dark window, in one word",
        componentsDarkText: "run(theme: \"dark\"): every component takes its dark look by itself, the plain objects and the page too. \"auto\" follows the system, and set_theme(\"dark\") changes it while the program runs.",
        componentsDarkShotAlt: "The gallery in a dark window: buttons, check boxes, a list and pictures on dark cards.",
        components: [
            { name: "SmartButton", text: "The default button: a text, an icon, a waiting clock." },
            { name: "TextField", text: "A text field with a title and warnings. EmailField, PasswordField and NumberField are made from it." },
            { name: "UrlField, PhoneField", text: "An address with its protocol, a phone number in its mask; CurrencyField writes an amount in groups of three." },
            { name: "TextAreaField", text: "A text of more lines, with a count of its letters." },
            { name: "SearchInput", text: "A search box with a clear button; a text at every change." },
            { name: "CheckBox", text: "A check with its label, read with checked?." },
            { name: "Toggle", text: "An on / off switch." },
            { name: "RadioButton", text: "One choice of a group; radio_value gives the checked one." },
            { name: "SelectBox", text: "A drop-down list, with search." },
            { name: "Slider, RangeSlider", text: "A number on a thin bar with a round knob, or a range with two knobs. SliderField is a number in the shape of a field." },
            { name: "Stepper", text: "A number with - and + buttons. A typed number too." },
            { name: "DatePicker", text: "A date from a calendar. TimePicker and ColorPicker are the same kind of field." },
            { name: "FilePicker", text: "A place to drop files, or a click to choose them. open_file opens the file dialog of the system and gives the real path." },
            { name: "ProgressBar, StepBar", text: "The progress of a job, from a thread too; and the steps of a job in a row." },
            { name: "ItemList", text: "A list to choose from, or a gallery of pictures." },
            { name: "SortableList", text: "A list whose order the user changes: drag a row, or Space and the arrows." },
            { name: "SmartTable", text: "A table of any size: it makes only the rows that are seen. Sorting and a filter; a row comes back as a Hash." },
            { name: "TreeView", text: "A tree of nodes: open, close, choose." },
            { name: "Tabs", text: "Pages in one window: the objects of a page are made in its block." },
            { name: "Accordion", text: "Sections that fold, one or more open. A closed one keeps its objects." },
            { name: "GridGroup", text: "Objects in columns and rows: a form, the keys of a calculator." },
            { name: "GraphBox", text: "Charts with no other gem: line, bar, pie, radar, scatter. A tooltip, a legend, a table." },
            { name: "LogView", text: "The output of your program in colored lines. writer(:info) makes it an output like $stdout, from any thread." },
            { name: "ImageView", text: "A picture with a zoom: a file, or bytes your program made." },
            { name: "Canvas", text: "Lines, shapes, texts and pictures, each with a key: a click finds it, a drag moves it, a pen draws free lines." },
            { name: "MarkdownView, JsonView", text: "A text in Markdown: a report, or the answer of an AI as it comes. And a value as a tree, with the path of a row." },
            { name: "JsonEditor", text: "A list of JSON written in a table: rows, columns, switches, a JSON view, undo." },
            { name: "ChatView", text: "A conversation with an AI: bubbles, answers in Markdown that come piece by piece, Send and Stop." },
            { name: "WebView", text: "A web page or an HTML text with its scripts; a message from its script reaches your program." },
            { name: "MenuBar, ToolBar", text: "File, Edit, View with shortcuts and submenus, and the row of small buttons under them." },
            { name: "StatusBar, Splitter", text: "A short message at the bottom of the window; and two areas with a line between them: a drag changes their sizes." },
            { name: "CodeEditor", text: "Line numbers and colors for the languages of the kit; the line and the column of the cursor." },
            { name: "ContextMenu, Tooltip", text: "A menu on a right click. A hint under the mouse, a bubble at an object." },
            { name: "Dialog, toast", text: "Dialogs that return their answer, and a short message in a corner." },
        ],
        componentsOthersTitle: "Any component, also by its name",
        componentsOthersText: "All {components} components of the kit have a method of their own: Gauge, Badge, TimeLine and the others that are not in this list. component(\"Gauge\", ...) makes one by its name, with the params of the kit. A component goes into the page when the program first uses it.",
        componentsShotAlt: "A window with two rings: 72% Disk and 35% Memory.",

        // YOUR OWN COMPONENT
        ownEyebrow: "YOUR OWN COMPONENTS",
        ownTitle: "A component of your own, in plain Ruby",
        ownLead: "A class that makes its objects in a group is a component: use it again and again, change it with its methods, share it as a file or a gem. No JavaScript is needed.",
        ownPoints: [
            { title: "A class and its objects", text: "<code>Card.new</code> makes its objects in a group, and keeps the ones it changes later: <code>@box</code>, <code>@title</code>." },
            { title: "Methods change it", text: "<code>card.title = \"Opened\"</code> changes its title, as the <code>setX()</code> methods of the components of basic.js do." },
            { title: "A file to share", text: "Put it in a file of its own, then require it in every program that needs it." },
        ],
        ownShotAlt: "The window of the cards: three white cards, Sales, Stock and Orders, each with a text and an Open button.",

        // DIALOGS
        dialogsEyebrow: "DIALOGS",
        dialogsTitle: "A dialog that returns its answer",
        dialogsLead: "confirm waits for the answer and returns it, like a question in a terminal. The window keeps working meanwhile: timers run and the page is drawn.",
        dialogsPoints: [
            "alert, confirm, prompt, and ask with your own buttons",
            "toasts that never wait: toast(\"Saved.\")",
            "the file dialogs of the system: open_file, save_file, choose_folder",
        ],
        dialogsShotAlt: "A dialog asks 'Replace it?' with the buttons Cancel and Replace.",

        // EXAMPLES
        examplesEyebrow: "EXAMPLES",
        examplesTitle: "Twenty-one small programs",
        examplesLead: "In the examples folder of the repository: ruby -Ilib examples/gallery.rb. A check draws each one in a hidden browser, light and dark, and fails on a wrong name.",
        examples: [
            { key: "editor", image: "editor", title: "A small code editor", text: "Write Ruby, press F5 and read its output: a menu, a row of buttons, two areas, a dark theme." },
            { key: "markdown_editor", image: "markdown-editor", title: "A small Markdown editor", text: "Write on the left, read on the right: headings, a table, colored code, a file with its pictures." },
            { key: "json_viewer", image: "json-viewer", title: "A small JSON viewer", text: "Open a file, click a row to see its path, right click to copy its value." },
            { key: "csv_viewer", image: "csv-viewer", title: "CSV viewer", text: "A CSV file in a table with a filter; 100000 rows stay fast." },
            { key: "chat", image: "chat", title: "A chat", text: "An answer that comes word by word from a thread; Stop ends it, New chat starts again." },
            { key: "charts", image: "charts", title: "Charts", text: "A live line, bars with a format, a doughnut, two lines with a target." },
            { key: "image_viewer", image: "image-viewer", title: "Image viewer", text: "Open a picture, or draw a plot made in plain Ruby again and again: the zoom stays." },
            { key: "job_log", image: "job-log", title: "A job and its log", text: "A thread, ui { } and the levels of a LogView." },
            { key: "form", image: "form", title: "A form", text: "Fields of text with warnings, a date, a time, a color, a number." },
            { key: "settings", image: "settings", title: "Settings", text: "Settings on three tabs; Save shows them." },
            { key: "todo", image: "todo", title: "To do", text: "Add, tick and delete with a question." },
            { key: "notes", image: "notes", title: "Notes", text: "The program of the rules for an AI assistant: a field, a list that grows, a count." },
            { key: "dialogs", image: "dialog-open", title: "Dialogs", text: "alert, confirm, prompt, ask and a toast; each one returns its answer." },
            { key: "gallery", image: "gallery", title: "Gallery", text: "The main components on one page, in two columns of cards." },
            { key: "minimal_theme", image: "minimal-theme-dark", title: "The minimal look", text: "Every component in its minimal look, made of lines: run(style: \"minimal\"); a dark window too." },
            { key: "calculator", image: "calculator", title: "Calculator", text: "The keys in a GridGroup; the keys of the keyboard work too." },
            { key: "basics", image: "basics", title: "The basic objects", text: "A Box, an Icon, a Label, an Input and a Button, each in a place of its own." },
            { key: "counter", image: "counter", title: "Counter", text: "Two buttons change a number." },
            { key: "greeting", image: "greeting", title: "Greeting", text: "A TextField read in Ruby; Enter or a button." },
            { key: "clock", image: "clock", title: "Clock", text: "every(1000) { }: a clock and a stopwatch." },
            { key: "game", image: "game", title: "Catch the dots", text: "Places of their own, the keys and a timer." },
        ],

        // WHERE IT FITS
        fitEyebrow: "WHERE IT FITS",
        fitTitle: "Small tools, inner tools, quick windows",
        fitGoodTitle: "A good choice for",
        fitGood: [
            "a script or a command line tool that needs a window",
            "a tool for your team: one Ruby file and gem install ozdenui",
            "a modern look without HTML, CSS or a front-end build",
            "people who already use basic.js, or OzdenUI for Python or Go",
        ],
        fitOtherTitle: "Something else is better for",
        fitOther: [
            "more than one window: v{version} has one window for a program",
            "a program given as an app of its own: v{version} runs with ruby app.rb (on macOS the Dock shows it as Ruby)",
            "a large desktop application with the widgets of the system: Ruby/GTK",
            "a web application for many users: Rails or Sinatra",
        ],
        fitNote: "OzdenUI is small on purpose. When it is not enough, these are good choices.",

        // START
        startEyebrow: "GET STARTED",
        startTitle: "Three steps",
        steps: [
            { title: "Install it", text: "One gem, with no other gem behind it and nothing to compile. On macOS the Ruby of the system is enough; on Windows and Linux the window is an app window of Edge or Chrome." },
            { title: "Write the block of run", text: "Make the objects of the window in it. Groups place them; a lambda or a method runs on a click." },
            { title: "Run it", text: "A window opens, and run returns when it is closed. A wrong name is told in the terminal with the line of your program: read it." },
        ],
        startHandbook: "Then the handbook: from the first window to a component of your own, in English and Turkish.",
        readHandbook: "Read the handbook", // the hero and the end of Start: a verb, as the other buttons
        agentsTitle: "With an AI assistant",
        agentsText: "OzdenUI is new, so an assistant does not know it yet. One command writes its rules (the layout, the events, the components, the mistakes to avoid) into AGENTS.md of your project, where Claude Code, Codex, Cursor or Copilot read them by themselves. And the assistant can look at the window it made, without a window.",
        startNote: "Ruby {ruby}+. Tested on macOS: the window is the web view of the system (WKWebView). On Windows and Linux it is an app window of Edge or Chrome; these two are checked by the tests of the repository, not yet by hand.",

        // FOOTER
        footerText: "OzdenUI for Ruby is open source under the {license} license.",
        footerMade: "This page is built with basic.js. Developed with the help of Claude Code (Anthropic).",

    },

    tr: {

        htmlLang: "tr",
        pageTitle: "OzdenUI for Ruby – Düz Ruby ile modern masaüstü pencereleri",
        pageDescription: "OzdenUI for Ruby, Ruby'den kendi küçük, modern penceresini açar: kutular, metinler, düğmeler ve basic.js'in 83 hazır bileşeni, her biri kendi adında bir yöntem, bloklarla. Yalnız Ruby: JavaScript yok, HTML yok, ön yüz derlemesi yok, başka gem ve derleyici yok.",
        languageButton: "EN",
        languageHint: "English",
        nav: { code: "Kod", why: "Neden", components: "Bileşenler", examples: "Örnekler", start: "Başlangıç" },
        navBasicJs: "basic.js",
        navHandbook: "El kitabı",
        navComponents: "basic.js bileşenleri",
        navPython: "OzdenUI for Python",
        navGo: "OzdenUI for Go",
        navRubyGems: "RubyGems",
        menu: "Menü",
        copy: "Kopyala",
        copied: "Kod kopyalandı.",
        copyFailed: "Kod kopyalanamadı.",

        // HERO
        heroEyebrow: "v{version} · deneysel · Ruby {ruby}+ · macOS'ta denendi",
        heroTitle: "Düz Ruby ile modern masaüstü pencereleri",
        heroLead: "Pencereyi Ruby ile yazın: kutular, metinler, düğmeler ve hazır bileşenler kendi küçük penceresinde görünür. Yalnız Ruby: JavaScript, HTML, CSS ve ön yüz derlemesi yok; başka gem ve derleyici de yok.",
        heroPrimary: "Başlayın",
        heroSecondary: "Örneklere bakın",
        heroFacts: ["{components} bileşen, her biri bir yöntem", "içinde basic.js: yaklaşık {size}, internetsiz", "başka gem ve derleyici gerekmez", "{license}"],
        heroSlidesLabel: "Örneklerin pencereleri",
        heroShotAlts: {
            "hero-gallery": "examples/gallery.rb'nin penceresi: kartlarda düğmeler, onay kutusu, açma-kapama düğmesi, seçenek düğmeleri, açılır liste, kaydırıcı, ilerleme çubuğu, not alanı ve listeler.",
            "hero-minimal-theme": "examples/minimal_theme.rb'nin penceresi: her bileşen minimal görünümünde, küçük ve çizgilerden.",
            "hero-charts": "examples/charts.rb'nin penceresi: canlı bir çizgi, çubuklar, bir halka ve hedef çizgili iki çizgi.",
            "hero-csv-viewer": "examples/csv_viewer.rb'nin penceresi: şehirlerin ülkeleri ve nüfuslarıyla bir tablo, altında bir süzgeç.",
            "hero-chat-dark": "examples/chat.rb koyu bir pencerede: bir soru ve listesi, tablosu ve koduyla cevabı.",
        },

        // CODE
        codeEyebrow: "KOD PENCERENİN KENDİSİ",
        codeTitle: "Birkaç satırda bir sayaç",
        codeLead: "Gruplar nesneleri sizin için yerleştirir; bir düğmeye verilen lambda, düğmeye tıklanınca çalışır.",
        codePoints: [
            { title: "Grup bir bloktur", text: "Bir grubun bloğunda yapılan nesneler o gruba girer: kodun şekli pencerenin şeklidir." },
            { title: "Değerler Ruby'de", text: "@label.text = \"1\" pencereyi değiştirir; field.text ve box.checked? pencereye sorulmadan Ruby'de okunur." },
            { title: "Tek iş parçacığı, kilit yok", text: "run'ın bloğu, bir olay ve bir zamanlayıcı sırayla, birer birer çalışır. Bir işin değişiklikleri, iş bitince pencereye birlikte gider." },
        ],
        codeShotAlt: "Sayacın penceresi: 0 sayısı ve iki düğme, Minus ve Plus.",

        // WHY
        whyEyebrow: "NEDEN",
        whyTitle: "Yalnız Ruby, derlenecek bir şey yok",
        why: [
            { icon: "feather", title: "Başka gem yok, derleyici yok", text: "gem install ozdenui, başka bir şey değil: derlenecek yerel eklenti, Node, npm yok. basic.js ve bileşenleri gem'in içindedir (yaklaşık {size}) ve yalnız bu bilgisayara sunulur: internet gerekmez." },
            { icon: "grid", title: "Zaten olan Ruby'niz", text: "Ruby {ruby} ya da daha yenisi; macOS ile gelen Ruby de olur. macOS'ta pencere, fiddle ile çağrılan sistemin web görünümüdür; Windows'ta ve Linux'ta Edge'in ya da Chrome'un bir uygulama penceresidir." },
            { icon: "code", title: "Pencere gibi okunan kod", text: "Gruplar bloktur, adlar snake_case ile basic.js'in adlarıdır, olaylar lambda, yöntem ya da bloktur. Yanlış bir ad, terminalde programınızın satırıyla ve demek istediğiniz adla söylenir." },
            { icon: "bolt", title: "Thread'ler rahat", text: "Yavaş bir iş kendi Thread'inde çalışır, pencere onu beklemez. ui { } sonucunu nesnelere geri getirir." },
        ],

        // COMPONENTS
        componentsEyebrow: "BİLEŞENLER",
        componentsTitle: "Hazır bileşenler, Ruby'den",
        componentsLead: "Her biri kendi adında bir yöntemdir: kitin parametreleri snake_case adlarla, geri çağrılar bir lambda ya da yöntem olarak. Durumu Ruby'de okunur: box.checked?, field.text, select_box.value. ozdenui doc SelectBox her parametreyi terminalde yazar.",
        componentsDarkTitle: "Tek kelimeyle koyu pencere",
        componentsDarkText: "run(theme: \"dark\"): her bileşen koyu görünüşünü kendisi alır, sade nesneler ve sayfa da. \"auto\" sistemi izler; set_theme(\"dark\") program çalışırken değiştirir.",
        componentsDarkShotAlt: "Koyu pencerede galeri: koyu kartlarda düğmeler, onay kutuları, bir liste ve resimler.",
        components: [
            { name: "SmartButton", text: "Varsayılan düğme: bir metin, bir ikon, bekleme saati." },
            { name: "TextField", text: "Başlıklı ve uyarılı metin alanı. EmailField, PasswordField ve NumberField ondan yapılır." },
            { name: "UrlField, PhoneField", text: "Protokolüyle bir adres, maskesinde bir telefon numarası; CurrencyField bir tutarı üçlü gruplarla yazar." },
            { name: "TextAreaField", text: "Birden çok satırlık metin, harf sayısıyla." },
            { name: "SearchInput", text: "Temizleme düğmeli arama kutusu; her değişiklikte metni verir." },
            { name: "CheckBox", text: "Etiketiyle bir onay kutusu; checked? ile okunur." },
            { name: "Toggle", text: "Açma-kapama düğmesi." },
            { name: "RadioButton", text: "Bir grubun seçeneklerinden biri; radio_value işaretli olanı verir." },
            { name: "SelectBox", text: "Aramalı açılır liste." },
            { name: "Slider, RangeSlider", text: "İnce çubukta yuvarlak düğmeli sayı ya da iki düğmeli aralık. SliderField, alan şeklinde bir sayıdır." },
            { name: "Stepper", text: "- ve + düğmeli sayı. Yazarak da girilir." },
            { name: "DatePicker", text: "Takvimden tarih. TimePicker ve ColorPicker aynı türden alanlar." },
            { name: "FilePicker", text: "Dosya bırakılan bir yer ya da tıklayınca seçim. open_file sistemin dosya diyaloğunu açar ve gerçek yolu verir." },
            { name: "ProgressBar, StepBar", text: "Bir işin ilerleyişi, bir Thread'den de; bir de işin adımları bir satırda." },
            { name: "ItemList", text: "Seçim yapılan bir liste ya da resim galerisi." },
            { name: "SortableList", text: "Sırasını kullanıcının değiştirdiği bir liste: bir satırı sürükleyin ya da Boşluk ve oklarla taşıyın." },
            { name: "SmartTable", text: "Her boyutta tablo: yalnız görünen satırları yapar. Sıralama ve süzme; bir satır Hash olarak geri gelir." },
            { name: "TreeView", text: "Düğümlerden bir ağaç: açın, kapatın, seçin." },
            { name: "Tabs", text: "Bir pencerede birkaç sayfa: bir sayfanın nesneleri onun bloğunda yapılır." },
            { name: "Accordion", text: "Katlanan bölümler, biri ya da birkaçı açık. Kapalı olan nesnelerini korur." },
            { name: "GridGroup", text: "Sütun ve satırlarda nesneler: bir form, hesap makinesinin tuşları." },
            { name: "GraphBox", text: "Başka gem'siz grafikler: çizgi, çubuk, pasta, radar, dağılım. İpucu, açıklama, tablo." },
            { name: "LogView", text: "Programınızın çıktısı renkli satırlarla. writer(:info) onu her Thread'den yazılan, $stdout gibi bir çıktı yapar." },
            { name: "ImageView", text: "Yakınlaştırmalı resim: bir dosya ya da programınızın yaptığı baytlar." },
            { name: "Canvas", text: "Çizgi, şekil, yazı ve resim, her biri bir anahtarla: tıklama onu bulur, sürükleme taşır, kalem serbest çizer." },
            { name: "MarkdownView, JsonView", text: "Markdown metni: bir rapor ya da gelirken yapay zekâ cevabı. Bir de değeri, satırın yoluyla bir ağaç olarak gösterir." },
            { name: "JsonEditor", text: "Bir tabloda yazılan JSON listesi: satırlar, sütunlar, anahtarlar, JSON görünümü, geri alma." },
            { name: "ChatView", text: "Bir yapay zekâyla konuşma: balonlar, parça parça gelen Markdown cevaplar, Gönder ve Durdur." },
            { name: "WebView", text: "Bir web sayfası ya da betikleriyle bir HTML metni; betiğinin gönderdiği mesaj programınıza ulaşır." },
            { name: "MenuBar, ToolBar", text: "Dosya, Düzenle, Görünüm, kısayollar ve alt menülerle; altında küçük düğmeler." },
            { name: "StatusBar, Splitter", text: "Pencerenin altında kısa mesaj; bir de aralarında çizgi olan iki alan: sürükleyince boyutları değişir." },
            { name: "CodeEditor", text: "Kitin dilleri için satır numaraları ve renkler; imlecin satırı ve sütunu." },
            { name: "ContextMenu, Tooltip", text: "Sağ tıkla menü. Fare altında ipucu, bir nesnenin yanında baloncuk." },
            { name: "Dialog, toast", text: "Cevabını döndüren diyaloglar ve köşede kısa bir mesaj." },
        ],
        componentsOthersTitle: "Her bileşen, adıyla da",
        componentsOthersText: "Kitin {components} bileşeninin hepsinin kendi yöntemi var: Gauge, Badge, TimeLine ve bu listede olmayan ötekiler. component(\"Gauge\", ...) bir bileşeni adıyla, kitin parametreleriyle yapar. Bileşen, program onu ilk kullandığında sayfaya yüklenir.",
        componentsShotAlt: "İki halkalı bir pencere: %72 Disk ve %35 Memory.",

        // YOUR OWN COMPONENT
        ownEyebrow: "KENDİ BİLEŞENİNİZ",
        ownTitle: "Düz Ruby ile kendi bileşeniniz",
        ownLead: "Nesnelerini bir grupta yapan bir sınıf bir bileşendir: tekrar tekrar kullanılır, kendi yöntemleriyle değişir, bir dosya ya da gem olarak paylaşılır. JavaScript gerekmez.",
        ownPoints: [
            { title: "Bir sınıf ve nesneleri", text: "<code>Card.new</code> nesnelerini bir grupta yapar, sonradan değişecekleri tutar: <code>@box</code>, <code>@title</code>." },
            { title: "Yöntemlerle değişir", text: "<code>card.title = \"Opened\"</code> başlığını değiştirir; basic.js bileşenlerinin <code>setX()</code> yöntemleri gibi." },
            { title: "Paylaşılan bir dosya", text: "Kendi dosyasına koyun, onu gereken her programda require edin." },
        ],
        ownShotAlt: "Kartların penceresi: üç beyaz kart (Sales, Stock, Orders), her birinde bir metin ve bir Open düğmesi.",

        // DIALOGS
        dialogsEyebrow: "DİYALOGLAR",
        dialogsTitle: "Cevabını döndüren bir diyalog",
        dialogsLead: "confirm cevabı bekler ve terminaldeki bir soru gibi döndürür. Pencere bu sırada çalışmaya devam eder: zamanlayıcılar çalışır, sayfa çizilir.",
        dialogsPoints: [
            "alert, confirm, prompt ve kendi düğmelerinizle ask",
            "hiç beklemeyen kısa mesajlar: toast(\"Saved.\")",
            "sistemin dosya diyalogları: open_file, save_file, choose_folder",
        ],
        dialogsShotAlt: "Bir diyalog 'Replace it?' diye soruyor; Cancel ve Replace düğmeleri var.",

        // EXAMPLES
        examplesEyebrow: "ÖRNEKLER",
        examplesTitle: "Yirmi bir küçük program",
        examplesLead: "Deponun examples klasöründe: ruby -Ilib examples/gallery.rb. Bir denetim her birini gizli bir tarayıcıda açık ve koyu çizer; yanlış bir adda hata verir.",
        examples: [
            { key: "editor", image: "editor", title: "Küçük bir kod düzenleyici", text: "Ruby yazın, F5'e basın, çıktısını okuyun: menü, düğme satırı, iki alan, koyu tema." },
            { key: "markdown_editor", image: "markdown-editor", title: "Küçük bir Markdown düzenleyici", text: "Solda yazın, sağda okuyun: başlıklar, tablo, renkli kod, resimleriyle bir dosya." },
            { key: "json_viewer", image: "json-viewer", title: "Küçük bir JSON görüntüleyici", text: "Dosya açın, satıra tıklayıp yolunu görün, sağ tıkla değerini kopyalayın." },
            { key: "csv_viewer", image: "csv-viewer", title: "CSV görüntüleyici", text: "Süzmeli bir tabloda bir CSV dosyası; 100000 satırda bile hızlı." },
            { key: "chat", image: "chat", title: "Bir sohbet", text: "Cevabı bir Thread'den kelime kelime gelen bir konuşma; Stop onu bitirir, New chat baştan başlar." },
            { key: "charts", image: "charts", title: "Grafikler", text: "Canlı bir çizgi, biçimli çubuklar, bir halka, hedef çizgili iki çizgi." },
            { key: "image_viewer", image: "image-viewer", title: "Resim görüntüleyici", text: "Bir resim açın ya da düz Ruby ile yapılan grafiği tekrar tekrar çizin: yakınlaştırma korunur." },
            { key: "job_log", image: "job-log", title: "Bir iş ve günlüğü", text: "Bir Thread, ui { } ve bir LogView'un düzeyleri." },
            { key: "form", image: "form", title: "Bir form", text: "Uyarılı metin alanları, bir tarih, bir saat, bir renk, bir sayı." },
            { key: "settings", image: "settings", title: "Ayarlar", text: "Üç sekmede ayarlar; Save onları gösterir." },
            { key: "todo", image: "todo", title: "Yapılacaklar", text: "Ekle, işaretle, sorarak sil." },
            { key: "notes", image: "notes", title: "Notlar", text: "Yapay zekâ yardımcısının kurallarındaki program: bir alan, büyüyen bir liste, bir sayı." },
            { key: "dialogs", image: "dialog-open", title: "Diyaloglar", text: "alert, confirm, prompt, ask ve bir toast; her biri cevabını döndürür." },
            { key: "gallery", image: "gallery", title: "Galeri", text: "Ana bileşenler bir sayfada, iki sütun kartta." },
            { key: "minimal_theme", image: "minimal-theme-dark", title: "Minimal görünüm", text: "Çizgilerden yapılmış minimal görünümüyle her bileşen: run(style: \"minimal\"); koyu pencerede de." },
            { key: "calculator", image: "calculator", title: "Hesap makinesi", text: "Tuşlar bir GridGroup'ta; klavyenin tuşları da çalışır." },
            { key: "basics", image: "basics", title: "Temel nesneler", text: "Bir Box, bir Icon, bir Label, bir Input ve bir Button, her biri kendi yerinde." },
            { key: "counter", image: "counter", title: "Sayaç", text: "İki düğme bir sayıyı değiştirir." },
            { key: "greeting", image: "greeting", title: "Selam", text: "Ruby'de okunan bir TextField; Enter ya da düğme." },
            { key: "clock", image: "clock", title: "Saat", text: "every(1000) { }: bir saat ve bir kronometre." },
            { key: "game", image: "game", title: "Noktaları yakala", text: "Kendi yerindeki nesneler, tuşlar ve bir zamanlayıcı." },
        ],

        // WHERE IT FITS
        fitEyebrow: "NEREDE UYGUN",
        fitTitle: "Küçük araçlar, iç araçlar, hızlı pencereler",
        fitGoodTitle: "İyi bir seçim",
        fitGood: [
            "pencere gereken bir betik ya da komut satırı aracı için",
            "ekibiniz için bir araç: tek bir Ruby dosyası ve gem install ozdenui",
            "HTML, CSS ya da ön yüz derlemesi olmadan modern bir görünüş için",
            "zaten basic.js ya da Python veya Go için OzdenUI kullananlar için",
        ],
        fitOtherTitle: "Başka bir şey daha iyi",
        fitOther: [
            "birden çok pencere için: v{version} bir programa bir pencere açar",
            "kendi başına bir uygulama olarak verilen bir program için: v{version} ruby app.rb ile çalışır (macOS'ta Dock onu Ruby olarak gösterir)",
            "sistemin parçalarıyla büyük bir masaüstü uygulaması için: Ruby/GTK",
            "çok kullanıcılı bir web uygulaması için: Rails ya da Sinatra",
        ],
        fitNote: "OzdenUI bilerek küçük. Yetmediğinde bunlar iyi seçimler.",

        // START
        startEyebrow: "BAŞLANGIÇ",
        startTitle: "Üç adım",
        steps: [
            { title: "Kurun", text: "Tek bir gem; arkasında başka gem yok, derlenecek bir şey yok. macOS'ta sistemin Ruby'si yeter; Windows'ta ve Linux'ta pencere, Edge'in ya da Chrome'un bir uygulama penceresidir." },
            { title: "run'ın bloğunu yazın", text: "Pencerenin nesnelerini içinde yapın. Gruplar onları yerleştirir; tıklanınca bir lambda ya da yöntem çalışır." },
            { title: "Çalıştırın", text: "Bir pencere açılır; pencere kapanınca run döner. Yanlış bir ad, terminalde programınızın satırıyla söylenir: okuyun." },
        ],
        startHandbook: "Sonra el kitabı: ilk pencereden kendi bileşeninize, İngilizce ve Türkçe.",
        readHandbook: "El kitabını okuyun",
        agentsTitle: "Bir yapay zekâ yardımcısıyla",
        agentsText: "OzdenUI yeni, bu yüzden yardımcılar onu henüz bilmez. Tek bir komut, kurallarını (yerleşim, olaylar, bileşenler, kaçınılacak hatalar) projenizin AGENTS.md dosyasına yazar; Claude Code, Codex, Cursor ya da Copilot onları kendiliğinden okur. Yardımcı, yaptığı pencereye pencere açmadan da bakabilir.",
        startNote: "Ruby {ruby}+. macOS'ta denendi: pencere sistemin web görünümüdür (WKWebView). Windows'ta ve Linux'ta Edge'in ya da Chrome'un bir uygulama penceresidir; bu ikisi deponun testleriyle denetlenir, henüz elle denenmedi.",

        // FOOTER
        footerText: "OzdenUI for Ruby, {license} lisansı ile açık kaynaktır.",
        footerMade: "Bu sayfa basic.js ile yapılmıştır. Claude Code (Anthropic) yardımıyla geliştirildi.",

    },

};

TEXTS.fill = function (text) {
    return String(text)
        .replace(/\{version\}/g, CONFIG.version)
        .replace(/\{ruby\}/g, CONFIG.rubyVersion)
        .replace(/\{components\}/g, CONFIG.componentCount)
        .replace(/\{size\}/g, CONFIG.embedSize)
        .replace(/\{license\}/g, CONFIG.license);
};
