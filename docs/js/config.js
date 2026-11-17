/* Bismillah */

/*

OzdenUI for Ruby Website - Config - v26.11

The values of the site in one place: the brand, the links, the facts and the state of the gem.
The site is the sister of the sites of OzdenUI for Go and for Python (the same theme, header and build).

Started Date: November 2026
Webpage: https://bug7a.github.io/ozdenui-ruby/

Copyright 2026 Bugra Ozden <bugra.ozden@gmail.com> (https://bug7a.github.io/)
Licensed under the Apache License, Version 2.0
SPDX-License-Identifier: Apache-2.0

*/

"use strict";

const CONFIG = {

    // *** BRAND:
    familySelf: "ruby", // this site in the strip of the family (js/sections/family.js)
    brandName: "OzdenUI",
    logoFile: "assets/ozdenui-ruby-dark.svg", // the logo of OzdenUI FOR RUBY (364 x 130), its version for the dark bar

    // *** PATHS: (relative to this page)
    rootPath: "./",
    imagesPath: "images/",

    // *** THE GEM:
    gemName: "ozdenui",
    version: "0.1.3",
    rubyVersion: "2.6",
    githubURL: "https://github.com/bug7a/ozdenui-ruby", // the repository of the gem ("": the GitHub button is hidden)
    rubygemsURL: "https://rubygems.org/gems/ozdenui", // the gem on RubyGems ("": its link is hidden)

    // *** LINKS:
    basicjsURL: "https://bug7a.github.io/basic.js/", // the site of basic.js
    // The handbook of the gem: a page of this site (Ex: "handbook/"); its language follows the page.
    // "": there is none yet, and its buttons and links are hidden.
    handbookURL: "handbook/",
    componentsURL: "https://bug7a.github.io/js-components/",
    pythonURL: "https://bug7a.github.io/ozdenui-python/", // OzdenUI for Python and for Go, the twins of this gem
    goURL: "https://bug7a.github.io/ozdenui-go/",
    authorURL: "https://bug7a.github.io/",

    // *** FACTS: (of ozdenui v0.1.3: its README, kit.json and lib/ozdenui/web/)
    // WHY \u00A0: a number and its unit stay on one line
    componentCount: 83,           // the components of the kit that are a method of their name (kit.json: 85, less TapEffect and Toast)
    embedSize: "3.4\u00A0MB",     // basic.js and the components inside the gem (the files of lib/ozdenui/web: 3.43 MB)
    license: "Apache 2.0",

    // *** THE SECTIONS OF THE HEADER:
    navKeys: ["code", "why", "components", "examples", "start"],

    // *** LANGUAGE:
    defaultLanguage: "en", // "tr", "en"
    languageStorageKey: "bjsruby_lang",

    // *** SEO:
    // The published address of this page (the docs/ folder of the repository, GitHub Pages).
    siteURL: "https://bug7a.github.io/ozdenui-ruby/",
    ogImage: "assets/og-image.jpg", // the link preview: the first screen of the page at 1200 x 630 (test/screenshot.js --og)

    // *** BEHAVIOR:
    rebuildOnResizeDelay: 180, // ms: the page is built again when the width changes

};
