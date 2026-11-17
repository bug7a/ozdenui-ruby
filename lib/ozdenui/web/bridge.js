/* Bismillah */

/*

bridge.js - ozdenui v0.1 (OzdenUI: basic.js for Ruby)
The page side of ozdenui: it runs the commands of the Ruby program on basic.js.

The program sends messages over the event stream "commands" (Server-Sent Events); the page answers and tells its
events with POST "emit", one request at a time, so everything reaches the program in the order it happened.

Messages of the program: { kind, n, ... }; the page answers each one with { reply: n, value } or { reply: n, error }.
  { kind: "apply", commands: [...] }   every command makes, changes or removes a basic.js object (below)
  { kind: "read", id, key }            the value of a property as basic.js reads it
  { kind: "ask", id, method, args }    a method of an object and its result
  { kind: "eval", script }             JavaScript of the program
  { kind: "accent", name, color, colorDark }   the packages of the accent color, also for components loaded later

Commands:
  { op: "create", id, type: "Box" | a component ("CheckBox"), args: [left, top, width, height], props: {...},
    parent: id or "page", state: { value: "value" }, src: "app.rb:12" }
  { op: "set", id, props: {...} }
  { op: "call", id, method, args: [...], refresh: 1 }   refresh: the state goes back to the program after the call
  { op: "static", target: "Toast", method: "show", args: [...], answer: callback id (for a Promise), keep: id (what it
    returned becomes an object of the program: a bubble) }
  { op: "part", id, of: id, path: ["panels", 0] }    a box inside a component, to put objects into
  { op: "placeBubble", id, target: id, side: "top" }  a popover is placed again when its objects are in it
  { op: "listen", id, event: "click" }
  { op: "remove", id }

A component that is not on the page yet is loaded with what it needs (components.js) before the commands that name it run.

Values from the program: { __bpCallback: id } becomes a function that tells the program (wholeArgs: [1]: the values at
these places are JSON data that goes whole, as { __bpJson: text }); { __bpObject: id } the object;
{ __bpNoop: 1 } an empty function; { __bpFormat: { prefix, suffix, thousands, decimals, percent } } a function that gives
the text of a number at once (the answer of a function of the program comes too late for a page that draws).

Started Date: November 2026
Webpage: https://bug7a.github.io/ozdenui-ruby/

Copyright 2020-2026 Bugra Ozden <bugra.ozden@gmail.com> (https://bug7a.github.io/)
Licensed under the Apache License, Version 2.0
SPDX-License-Identifier: Apache-2.0

*/

"use strict";

window.__bp = (function () {

    // *** PRIVATE VARIABLES:
    const MAKERS = { Box: Box, Label: Label, Button: Button, Input: Input, Icon: Icon, VGroup: VGroup, HGroup: HGroup };
    const GROUP_TYPES = ["VGroup", "HGroup", "GridGroup", "ScrollArea"]; // ScrollArea leaves its content started
    const PAGE_ID = "page";
    const MAX_VALUE_DEPTH = 64; // only a guard: a value that holds itself is cut by toJson() where it comes again
    const MAX_FRACTION_DIGITS = 20;
    const SWEEP_INTERVAL_MS = 1000; // at most this often apply() looks for the objects the page removed itself
    const MAX_FRAME_PX = 120; // a title bar and the edges of a window are smaller than this
    const FIT_WAIT_MS = 300;
    const RETRY_MS = 300;
    // WHY: the program gives its messages to the page that said "ready" last, by this name (a page loaded again is new)
    const PAGE_NAME = String(Date.now()) + "-" + String(Math.random()).slice(2); // a message that could not be sent is tried again after this
    const GLOBAL_NAME = /^[A-Za-z_$][A-Za-z0-9_$]*$/;
    const objects = new Map(); // id -> basic.js object
    let lastSweepAt = 0;
    let isProgramTold = false;
    const earlyMessages = []; // the messages of the page before the program was told that it is ready
    const outbox = []; // what waits to go to the program, in order
    let isSending = false;
    let accent = null; // { name, color, colorDark }: the packages of the accent color (run: accent)

    // *** PRIVATE FUNCTIONS:

    const objectOf = function (id) {
        if (id === PAGE_ID) return page;
        const obj = objects.get(id);
        if (!obj) throw new Error("There is no object " + id + " (removed?)");
        return obj;
    };

    const isBasicObject = function (value) {
        return !!(value && value.elem instanceof Element);
    };

    // A function or object of the page by its name: a basic.js object maker or a component (CheckBox, Toast).
    // WHY Function(): the components are top-level "const" (const CheckBox = function...), so they are not on
    //      window; the name is checked first, so only a name can go in.
    const resolveGlobal = function (name) {
        if (MAKERS[name]) return MAKERS[name];
        if (!GLOBAL_NAME.test(name)) return undefined;
        return Function("return (typeof " + name + " !== \"undefined\") ? " + name + " : undefined;")();
    };

    // A value of the page as it goes to the program (JSON): an object of basic.js becomes its id. ancestors: the objects
    // the value is inside of; one of them again (an object of a component that holds another one that holds it) is null.
    // WHY not a small depth: it cut the data of the program too, without a word: data.owner.address of an item of an
    //      ItemList, a node of a TreeView or a row came to the program as nil.
    const toJson = function (value, depth = 0, ancestors = []) {
        if (value === null || value === undefined) return null;
        if (typeof value === "function") return null;
        if (typeof value !== "object") return value;
        if (isBasicObject(value)) return objectToJson(value, depth, ancestors);
        if (value instanceof Date) return value.toISOString();
        if (value instanceof Node || value instanceof Event) return null;
        if (depth >= MAX_VALUE_DEPTH || ancestors.includes(value)) return null;
        const inside = ancestors.concat([value]);
        if (Array.isArray(value)) {
            return value.map(function (item) { return toJson(item, depth + 1, inside); });
        }
        const json = {};
        Object.keys(value).forEach(function (key) {
            json[key] = toJson(value[key], depth + 1, inside);
        });
        return json;
    };

    // A basic.js object: its id. WHY id and data: a part of a component (a row of a list) has no id of
    // the program, but its own id and data say which one it is.
    const objectToJson = function (obj, depth, ancestors) {
        if (obj.__bpId) return { __bpObject: obj.__bpId };
        const json = { __bpObject: null };
        if (obj.id !== undefined && obj.id !== "" && typeof obj.id !== "object") json.id = obj.id;
        if (obj.data !== undefined) json.data = toJson(obj.data, depth + 1, ancestors);
        return json;
    };

    // "checked" reads a property, "getSelectedKeys()" calls a method.
    const readAccessor = function (obj, accessor) {
        if (!accessor.endsWith("()")) return obj[accessor];
        const method = obj[accessor.slice(0, -2)];
        return (typeof method === "function") ? method.call(obj) : undefined;
    };

    // The values the program keeps: the state of a component ({ checked: "checked", selectedKeys: "getSelectedKeys()" })
    const stateOf = function (obj) {
        const spec = obj && obj.__bpState;
        if (!spec) return null;
        const keys = Object.keys(spec);
        if (!keys.length) return null;
        const state = {};
        keys.forEach(function (key) {
            state[key] = toJson(readAccessor(obj, spec[key]));
        });
        return state;
    };

    // WHY one request at a time: two requests can reach the program in another order; the events of the page and its
    //      answers must come as they happened (a Dialog tells its answer, then it is told as removed).
    const pump = function () {
        if (isSending || !outbox.length) return;
        isSending = true;
        const batch = outbox.splice(0, outbox.length);
        const sendBatch = function () {
            fetch("emit", { method: "POST", body: JSON.stringify(batch) }).then(function (response) {
                if (!response.ok) throw new Error("emit " + response.status);
                isSending = false;
                pump();
            }).catch(function () {
                setTimeout(sendBatch, RETRY_MS); // the program is busy or gone: the same batch again, so nothing is lost
            });
        };
        sendBatch();
    };

    const post = function (message) {
        outbox.push(message);
        pump();
    };

    const send = function (targetId, eventName, data) {
        post({ target: targetId, event: eventName, data: data });
    };

    // The values of a callback as they go to the program. The places of wholeArgs are JSON data that goes whole, as a JSON text.
    // WHY: the value of a JsonEditor may be any JSON, also deeper than MAX_VALUE_DEPTH, and a big one: JSON.stringify
    //      writes it exactly, faster than toJson() walks it.
    const argsToJson = function (args, wholeArgs) {
        return args.map(function (arg, place) {
            const isWhole = (wholeArgs && wholeArgs.includes(place) && arg !== undefined);
            if (!isWhole) return toJson(arg, 1);
            try {
                return { __bpJson: JSON.stringify(arg) };
            } catch (error) {
                return toJson(arg, 1); // WHY: a value that holds itself has no JSON text
            }
        });
    };

    const makeCallback = function (callbackId, ownerId, wholeArgs) {
        return function (...args) {
            const owner = (ownerId) ? objects.get(ownerId) : null;
            send(callbackId, "callback", { args: argsToJson(args, wholeArgs), state: stateOf(owner) });
        };
    };

    // The text of a number, as the format of the program writes it ("{:,.1f} TL", as in OzdenUI for Python). WHY en-US: the format writes 1,234.5.
    const makeNumberFormat = function (format) {
        const options = { useGrouping: (format.thousands === 1) };
        if (format.decimals === null) {
            options.maximumFractionDigits = MAX_FRACTION_DIGITS;
        } else {
            options.minimumFractionDigits = format.decimals;
            options.maximumFractionDigits = format.decimals;
        }
        const isPercent = (format.percent === 1);
        const percentSign = isPercent ? "%" : ""; // WHY: {:.1%} of 0.123 is 12.3%, with its sign
        return function (value) {
            if (typeof value !== "number") return String(value);
            const number = isPercent ? value * 100 : value;
            return format.prefix + number.toLocaleString("en-US", options) + percentSign + format.suffix;
        };
    };

    // A value from the program as the page takes it: the markers become functions and objects.
    const revive = function (value, ownerId) {
        if (value === null || typeof value !== "object") return value;
        if (Array.isArray(value)) {
            return value.map(function (item) { return revive(item, ownerId); });
        }
        if (value.__bpCallback) return makeCallback(value.__bpCallback, ownerId, value.wholeArgs);
        if (value.__bpObject) return objectOf(value.__bpObject);
        if (value.__bpNoop) return function () {};
        if (value.__bpFormat) return makeNumberFormat(value.__bpFormat);
        const revived = {};
        Object.keys(value).forEach(function (key) {
            revived[key] = revive(value[key], ownerId);
        });
        return revived;
    };

    const makeObject = function (command, props) {
        const make = resolveGlobal(command.type);
        if (typeof make !== "function") {
            throw new Error(command.type + " is not a component of the kit");
        }
        const obj = make(...command.args, props);
        // WHY: A group starts as the container of the next objects. The program gives the parent of every object
        //      itself, so a group is closed at once (the function of a group in the program only names the parent).
        if (GROUP_TYPES.includes(command.type)) endGroup();
        return obj;
    };

    const create = function (command) {
        const parent = objectOf(command.parent || PAGE_ID);
        const props = revive(command.props, command.id);
        const obj = createIn(parent, function () {
            return makeObject(command, props);
        });
        obj.__bpId = command.id;
        obj.__bpState = command.state || null;
        objects.set(command.id, obj);
    };

    const set = function (command) {
        const obj = objectOf(command.id);
        const props = revive(command.props, command.id);
        // WHY: page (a MainBox) has no props(): its values go one by one (Object.assign calls the setters).
        if (typeof obj.props !== "function") {
            Object.assign(obj, props);
            return;
        }
        obj.props(props);
    };

    const call = function (command) {
        const obj = objectOf(command.id);
        if (typeof obj[command.method] !== "function") throw new Error("There is no method " + command.method);
        obj[command.method](...revive(command.args, command.id));
        // WHY: a silent change (setValue(v, 1)) tells nobody, and the component may change the value (a slider keeps
        //      it inside min..max): the program gets the state as the page has it.
        if (command.refresh) send(command.id, "__state", { state: stateOf(obj) });
    };

    const keepObject = function (id, obj) {
        obj.__bpId = id;
        objects.set(id, obj);
    };

    const callStatic = function (command) {
        const target = resolveGlobal(command.target);
        if (!target || typeof target[command.method] !== "function") {
            throw new Error(command.target + "." + command.method + " is not loaded");
        }
        const result = target[command.method](...revive(command.args, null));
        if (command.keep) keepObject(command.keep, result);
        if (!command.answer) return;
        const tellAnswer = function (value) {
            send(command.answer, "callback", { args: [toJson(value)], state: null });
        };
        Promise.resolve(result).then(tellAnswer, function () { tellAnswer(null); });
    };

    const stepInto = function (obj, step, ownerId) {
        if (obj === undefined || obj === null) return obj;
        if (step && typeof step === "object" && step.call) {
            const method = obj[step.call];
            return (typeof method === "function") ? method.apply(obj, revive(step.args || [], ownerId)) : undefined;
        }
        return obj[step];
    };

    const part = function (command) {
        let obj = objectOf(command.of);
        command.path.forEach(function (step) {
            obj = stepInto(obj, step, command.of);
        });
        if (!isBasicObject(obj)) throw new Error("There is no box at " + JSON.stringify(command.path));
        obj.__bpId = obj.__bpId || command.id;
        objects.set(command.id, obj);
    };

    // WHY: the objects of a popover come after it was placed, and it grew from where it stood.
    const placeBubble = function (command) {
        const bubble = objectOf(command.id);
        Tooltip.place(bubble, Tooltip.toPageRect(objectOf(command.target)), command.side);
    };

    // What an event tells the program. An Input sends its text with every event: the program keeps it, so reading
    // its text in the program needs no question to the page.
    const dataOf = function (id, obj, event) {
        const data = {};
        if (obj.inputElement) data.text = obj.text;
        if (event && event.key !== undefined) {
            data.key = event.key;
            data.code = event.code;
            data.shift = event.shiftKey;
            data.ctrl = event.ctrlKey;
            data.alt = event.altKey;
            data.meta = event.metaKey;
        }
        if (event && event.clientX !== undefined) {
            data.x = event.clientX;
            data.y = event.clientY;
        }
        if (event && event.detail && typeof event.detail === "object") data.detail = toJson(event.detail); // a CustomEvent
        data.state = (id === PAGE_ID) ? { width: page.width, height: page.height } : stateOf(obj);
        return data;
    };

    const listen = function (command) {
        const obj = objectOf(command.id);
        obj.on(command.event, function (self, event) {
            send(command.id, command.event, dataOf(command.id, obj, event));
        });
    };

    // The objects that are not on the page any more leave the list, and the program is told (it forgets their callbacks).
    // WHY not only after remove: a component removes objects itself too (a closed Dialog, the panel of a removed tab).
    const sweepRemoved = function () {
        lastSweepAt = performance.now();
        const removedIds = [];
        objects.forEach(function (obj, id) {
            if (obj.elem.isConnected) return;
            removedIds.push(id);
            objects.delete(id);
        });
        return removedIds;
    };

    // basic.js removes the objects inside the removed one too.
    const remove = function (command) {
        objectOf(command.id).remove();
        return sweepRemoved();
    };

    const HANDLERS = { create: create, set: set, call: call, static: callStatic, part: part, placeBubble: placeBubble, listen: listen, remove: remove };

    // *** COMPONENTS THAT ARE NOT LOADED BY index.html (window.__bpComponents: name -> { file, needs })

    const loadScript = function (file) {
        return new Promise(function (resolve, reject) {
            const script = document.createElement("script");
            script.src = file;
            script.onload = resolve;
            script.onerror = function () { reject(new Error("could not load " + file)); };
            document.head.appendChild(script);
        });
    };

    // The files of the components and of what they need, each once, the needed ones first.
    const filesInOrder = function (names, errors) {
        const files = [];
        const seen = new Set(); // WHY: two components may need each other
        const addFile = function (name) {
            if (seen.has(name)) return;
            seen.add(name);
            const entry = (window.__bpComponents || {})[name];
            if (!entry) {
                errors.push("unknown component " + name);
                return;
            }
            (entry.needs || []).forEach(addFile);
            const isLoaded = (resolveGlobal(name) !== undefined);
            if (!isLoaded && !files.includes(entry.file)) files.push(entry.file);
        };
        names.forEach(addFile);
        return files;
    };

    // *** PUBLIC FUNCTIONS:

    // Applies the commands in order. A failed command does not stop the others: its error goes back to the program
    // with the line of the program that sent it.
    const apply = function (commands) {
        const startedAt = performance.now();
        const answer = { errors: [], removed: [] };
        commands.forEach(function (command) {
            try {
                const removedIds = HANDLERS[command.op](command);
                if (removedIds) answer.removed.push(...removedIds);
            } catch (error) {
                // WHY String(): a thrown text or object has no message; the program reads the message
                const message = (error && error.message) ? error.message : String(error);
                answer.errors.push({ op: command.op, id: command.id || command.target, src: command.src || "", message: message });
                // WHY: the program waits for the answer of a dialog; a call that failed never gave one, so it waited for ever
                if (command.op === "static" && command.answer) send(command.answer, "callback", { args: [null], state: null });
            }
        });
        if (performance.now() - lastSweepAt > SWEEP_INTERVAL_MS) answer.removed.push(...sweepRemoved());
        answer.ms = performance.now() - startedAt;
        return answer;
    };

    // The value of a property as basic.js reads it (obj.measure(:width))
    const read = function (id, key) {
        return toJson(objectOf(id)[key]);
    };

    // A method of an object and its result (obj.ask(:get_value))
    const ask = function (id, method, args) {
        const obj = objectOf(id);
        if (typeof obj[method] !== "function") throw new Error("There is no method " + method);
        return toJson(obj[method](...revive(args, id)));
    };

    const loadComponents = async function (names) {
        const errors = [];
        for (const file of filesInOrder(names, errors)) {
            try {
                await loadScript(file);
            } catch (error) {
                errors.push(error.message);
            }
        }
        if (accent) addAccentPackages();
        return { errors: errors };
    };

    // WHY again after a load: MinimalAccent gives its packages to the components that are on the page.
    const addAccentPackages = function () {
        if (typeof MinimalAccent === "undefined") return;
        MinimalAccent.addPackages(accent.name, accent.color, accent.colorDark);
    };

    // The components the commands name (a type to make, the target of a static call) that are not on the page yet.
    const namesToLoad = function (commands) {
        const names = [];
        commands.forEach(function (command) {
            const name = (command.op === "create") ? command.type : (command.op === "static") ? command.target : "";
            if (!name || names.includes(name) || MAKERS[name]) return;
            if ((window.__bpComponents || {})[name] && resolveGlobal(name) === undefined) names.push(name);
        });
        return names;
    };

    // *** THE MESSAGES OF THE PROGRAM, one after the other.

    const KINDS = {
        apply: async function (message) {
            const names = namesToLoad(message.commands);
            const loaded = (names.length) ? await loadComponents(names) : { errors: [] };
            const answer = apply(message.commands);
            loaded.errors.forEach(function (text) { answer.errors.push({ op: "load", id: "", src: "", message: text }); });
            return answer;
        },
        read: async function (message) { return read(message.id, message.key); },
        ask: async function (message) { return ask(message.id, message.method, message.args); },
        eval: async function (message) { return toJson(await (0, eval)(message.script)); },
        accent: async function (message) {
            accent = { name: message.name, color: message.color, colorDark: message.colorDark };
            await loadComponents(["MinimalAccent"]);
        },
    };

    let lastMessage = Promise.resolve();

    const takeMessage = function (message) {
        lastMessage = lastMessage.then(async function () {
            try {
                post({ reply: message.n, value: await KINDS[message.kind](message) });
            } catch (error) {
                post({ reply: message.n, error: (error && error.message) ? error.message : String(error) });
            }
        });
    };

    // *** THE MESSAGES OF THE PAGE go to the terminal of the program (a warning of a component, an error).

    const tellProgramMessage = function (kind, text) {
        if (!isProgramTold) {
            earlyMessages.push([kind, text]);
            return;
        }
        send(PAGE_ID, "__message", { kind: kind, text: text });
    };

    ["error", "warn"].forEach(function (kind) {
        const original = console[kind].bind(console);
        console[kind] = function (...args) {
            original(...args);
            tellProgramMessage(kind, args.map(String).join(" "));
        };
    });
    window.addEventListener("error", function (event) {
        tellProgramMessage("error", event.message + " (" + event.filename + ":" + event.lineno + ")");
    });
    window.addEventListener("unhandledrejection", function (event) {
        tellProgramMessage("error", "Promise: " + String(event.reason));
    });

    // WHY: a file dropped on the window opened in it, in the place of the program. (A FilePicker takes its own drop;
    //      a text dragged into a field goes on as usual.)
    const keepFileOutOfThePage = function (event) {
        const isFile = event.dataTransfer && Array.from(event.dataTransfer.types).includes("Files");
        if (isFile) event.preventDefault();
    };
    window.addEventListener("dragover", keepFileOutOfThePage);
    window.addEventListener("drop", keepFileOutOfThePage);

    // *** READY: the program starts when basic.js made the page.

    const tellProgramWhenReady = function () {
        isProgramTold = true;
        const prefersDark = !!(window.matchMedia && window.matchMedia("(prefers-color-scheme: dark)").matches);
        post({ ready: { page: PAGE_NAME, basicVersion: basic.version, width: page.width, height: page.height, prefersDark: prefersDark } });
        earlyMessages.forEach(function (message) { tellProgramMessage(message[0], message[1]); });
        // WHY after ready: the program sends nothing to a page that did not say it is there
        const stream = new EventSource("commands?page=" + PAGE_NAME);
        stream.onmessage = function (event) { takeMessage(JSON.parse(event.data)); };
    };

    // The ground of a page loaded again for another theme (set_theme): the program leaves it in window.name, which
    // stays over the load. WHY: the new page was light for a moment before the program drew it dark.
    const EARLY_PAGE_COLOR_PREFIX = "ozdenui-page-color:";
    const takeEarlyPageColor = function () {
        const name = String(window.name || "");
        if (name.indexOf(EARLY_PAGE_COLOR_PREFIX) !== 0) return;
        const color = name.slice(EARLY_PAGE_COLOR_PREFIX.length);
        if (color) page.color = color;
    };

    // A window of a browser is as large as the program asked with its title bar, so its page is smaller: the window
    // grows by the difference before the program starts (the web view of macOS is fitted by the program itself).
    // WHY only a small difference: a tab of a browser has the size of its window, and can not be resized.
    // A window of a browser opens in a corner of the screen (Edge on Windows: at 10, 10); the web view of macOS is
    // centered by the program itself.
    const centerWindow = function () {
        const screenLeft = screen.availLeft || 0;
        const screenTop = screen.availTop || 0;
        const left = screenLeft + Math.round((screen.availWidth - window.outerWidth) / 2);
        const top = screenTop + Math.round((screen.availHeight - window.outerHeight) / 2);
        window.moveTo(Math.max(left, screenLeft), Math.max(top, screenTop));
    };

    const fitWindowToPage = function (onDone) {
        const meta = document.querySelector("meta[name=ozdenui-size]");
        const wanted = (meta) ? meta.content.split("x").map(Number) : [];
        const extraWidth = wanted[0] - window.innerWidth;
        const extraHeight = wanted[1] - window.innerHeight;
        const isTitleBar = (extraWidth >= 0 && extraWidth <= MAX_FRAME_PX && extraHeight > 0 && extraHeight <= MAX_FRAME_PX);
        if (!isTitleBar) {
            onDone();
            return;
        }
        let isDone = false;
        const finish = function () {
            if (isDone) return;
            isDone = true;
            window.removeEventListener("resize", finish);
            centerWindow();
            onDone();
        };
        window.addEventListener("resize", finish);
        setTimeout(finish, FIT_WAIT_MS); // a window that does not let itself be resized
        window.resizeBy(extraWidth, extraHeight);
    };

    // basic.js calls start() when page is created.
    window.start = function () {
        takeEarlyPageColor();
        fitWindowToPage(tellProgramWhenReady);
    };

    return { apply: apply, read: read, ask: ask, objectOf: objectOf, loadComponents: loadComponents };

})();
