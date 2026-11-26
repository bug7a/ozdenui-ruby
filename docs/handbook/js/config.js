/* Bismillah */

/*

OzdenUI for Ruby Handbook Website - Config - v26.11 (a copy of the handbook page of OzdenUI for Python)

The settings of the handbook page in one place. Texts: js/texts.js.
The chapters are the Markdown files of the handbook of the gem (ozdenui-ruby/handbook), copied into english/ and
turkce/ by tools/update-handbook.sh of the site. The page reads them with fetch: open it with a web server.
A chapter whose file is not there yet is shown as a short "not here yet" page (js/site.js), with the name given here.

Started Date: November 2026
Webpage: https://bug7a.github.io/ozdenui-ruby/

Copyright 2026 Bugra Ozden <bugra.ozden@gmail.com> (https://bug7a.github.io/)
Licensed under the Apache License, Version 2.0
SPDX-License-Identifier: Apache-2.0

*/

"use strict";

const CONFIG = {

    // *** BRAND:
    brandName: "OzdenUI",
    version: "0.1.5", // the version of the gem (js/config.js of the main page of the site has it too)

    // *** PATHS:
    // The root of the site (the main page of the gem) from the address of this page: it is always <site>/handbook/.
    // WHY from the address and not a parent path written here: _make-standalone.sh lists a path that leaves the folder
    //     in the code; this one is read from the address, so nothing is listed and the logo comes from the site.
    siteRootURL: new URL(".", location.href).href.replace(/handbook\/$/, ""),
    logoFile: "", // written below: the logo of OzdenUI FOR RUBY in assets/ of the site (364 x 130, its version for a light ground)
    // The chapters (Markdown), relative to this page; a folder for each language
    handbookPath: "./",
    languageFolders: {
        en: "english",
        tr: "turkce",
    },

    // *** CHAPTERS: (the order of the menu; group: js/texts.js -> groups)
    // title: the name in the menu, else the title of the file. name: the name of a chapter whose file is not there yet.
    chapters: [
        { id: "start", file: "README.md", group: "start", title: { en: "Introduction", tr: "Giriş" } },
        { id: "first-window", file: "01-first-window.md", group: "basics", name: { en: "1. The first window", tr: "1. İlk pencere" } },
        { id: "objects", file: "02-objects.md", group: "basics", name: { en: "2. Objects", tr: "2. Nesneler" } },
        { id: "layout", file: "03-layout.md", group: "basics", name: { en: "3. Layout", tr: "3. Yerleşim" } },
        { id: "events-and-time", file: "04-events-and-time.md", group: "basics", name: { en: "4. Events and time", tr: "4. Olaylar ve zaman" } },
        { id: "components", file: "05-components.md", group: "components", name: { en: "5. Components", tr: "5. Bileşenler" } },
        { id: "dialogs-and-files", file: "06-dialogs-and-files.md", group: "components", name: { en: "6. Dialogs, messages and files", tr: "6. Diyaloglar, mesajlar ve dosyalar" } },
        { id: "looks", file: "07-looks.md", group: "components", name: { en: "7. Looks", tr: "7. Görünüm" } },
        { id: "data-and-pictures", file: "08-data-and-pictures.md", group: "components", name: { en: "8. Data and pictures", tr: "8. Veri ve resimler" } },
        { id: "your-own-component", file: "09-your-own-component.md", group: "more", name: { en: "9. Your own component", tr: "9. Kendi bileşeniniz" } },
        { id: "going-further", file: "10-going-further.md", group: "more", name: { en: "10. Going further", tr: "10. Daha ileri" } },
    ],

    // *** LINKS:
    githubURL: "https://github.com/bug7a/ozdenui-ruby", // the repository of the gem ("": the GitHub button is hidden)
    basicjsURL: "https://bug7a.github.io/basic.js/",
    componentsURL: "https://bug7a.github.io/js-components/",

    // *** LOADING:
    loadConcurrency: 4, // chapters read at the same time

    // *** LAYOUT:
    sidebarWidth: 280,
    headerHeight: 60,
    articleMaxWidth: 780,
    tocWidth: 220,
    drawerBreakpoint: 960, // under it the chapter list is a drawer opened with the menu button
    tocBreakpoint: 1280, // over it the "On this page" list is shown on the right

    // *** LANGUAGE:
    defaultLanguage: "en", // "tr", "en"
    languageStorageKey: "bjsruby_lang", // WHY the key of the main page of the site: a language chosen on either page holds on both

    // *** SEO:
    // The published address of this page (docs/handbook/ of the repository, GitHub Pages): canonical, hreflang, og:url.
    siteURL: "https://bug7a.github.io/ozdenui-ruby/handbook/",
    ogImage: "assets/og-image.jpg", // the link preview picture: the one of the main page (the root of the site)

    // *** BEHAVIOR:
    resizeDelay: 120,

};

CONFIG.logoFile = CONFIG.siteRootURL + "assets/ozdenui-ruby.svg";
