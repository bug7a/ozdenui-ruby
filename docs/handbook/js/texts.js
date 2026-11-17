/* Bismillah */

/*

OzdenUI for Ruby Handbook Website - Texts - v26.11 (a copy of the handbook page of OzdenUI for Python)

The texts of the page in English and Turkish (the same keys). The chapters come from the Markdown files.

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
        siteTitle: "OzdenUI for Ruby Handbook",
        pageTitle: "OzdenUI for Ruby – The Handbook",
        pageDescription: "Learn OzdenUI for Ruby step by step: the first window, objects, layout, events, components, dialogs, looks, data and a component of your own. Ten short chapters for people who know Ruby.",
        languageButton: "TR",
        languageHint: "Türkçe",

        // HEADER
        searchPlaceholder: "Search the handbook",
        searchHint: "Press / to search",
        searchEmpty: "Nothing found for \"{query}\"",
        searchKeys: "↑ ↓ to move · Enter to open · Esc to close",
        menu: "Menu",
        closeMenu: "Close the menu",
        navSite: "OzdenUI",
        navSiteHint: "The main page of OzdenUI for Ruby",
        navGithub: "GitHub",

        // SIDEBAR GROUPS
        groups: {
            start: "Start here",
            basics: "The basics",
            components: "Components and looks",
            more: "Further",
        },

        // ARTICLE
        onThisPage: "On this page",
        previous: "Previous",
        next: "Next",
        loading: "Loading the handbook…",
        loadError: "The handbook could not be loaded.",
        fileProtocol: "The chapters are read with fetch, which does not work when the page is opened as a file (file://). Open this folder with a web server, for example VS Code Live Server.",
        retry: "Try again",
        chapterMissing: "This chapter is not here yet: it is being written. The other chapters are in the menu.",

        // CODE BLOCKS
        copy: "Copy",
        copied: "The code is copied.",
        copyFailed: "The code could not be copied.",

        // FOOTER
        footerText: "OzdenUI for Ruby is open source (Apache 2.0). This page is made with basic.js and reads the handbook from its Markdown files; the same files are in the handbook folder of the repository.",
    },

    tr: {
        htmlLang: "tr",
        siteTitle: "OzdenUI for Ruby El Kitabı",
        pageTitle: "OzdenUI for Ruby – El Kitabı",
        pageDescription: "OzdenUI for Ruby'yi adım adım öğrenin: ilk pencere, nesneler, yerleşim, olaylar, bileşenler, diyaloglar, görünüm, veri ve kendi bileşeniniz. Ruby bilenler için on kısa bölüm.",
        languageButton: "EN",
        languageHint: "English",

        // HEADER
        searchPlaceholder: "El kitabında ara",
        searchHint: "Aramak için / tuşuna basın",
        searchEmpty: "\"{query}\" için bir sonuç yok",
        searchKeys: "↑ ↓ ile gezin · Enter ile açın · Esc ile kapatın",
        menu: "Menü",
        closeMenu: "Menüyü kapat",
        navSite: "OzdenUI",
        navSiteHint: "OzdenUI for Ruby'nin ana sayfası",
        navGithub: "GitHub",

        // SIDEBAR GROUPS
        groups: {
            start: "Buradan başlayın",
            basics: "Temeller",
            components: "Bileşenler ve görünüm",
            more: "İleri",
        },

        // ARTICLE
        onThisPage: "Bu sayfada",
        previous: "Önceki",
        next: "Sonraki",
        loading: "El kitabı yükleniyor…",
        loadError: "El kitabı yüklenemedi.",
        fileProtocol: "Bölümler fetch ile okunur; sayfa dosya olarak (file://) açıldığında bu çalışmaz. Bu klasörü bir web sunucusu ile açın, örneğin VS Code Live Server.",
        retry: "Tekrar dene",
        chapterMissing: "Bu bölüm henüz burada değil: yazılıyor. Diğer bölümler menüde.",

        // CODE BLOCKS
        copy: "Kopyala",
        copied: "Kod kopyalandı.",
        copyFailed: "Kod kopyalanamadı.",

        // FOOTER
        footerText: "OzdenUI for Ruby açık kaynaktır (Apache 2.0). Bu sayfa basic.js ile yapıldı ve el kitabını Markdown dosyalarından okur; aynı dosyalar deponun handbook klasöründedir.",
    },

};
