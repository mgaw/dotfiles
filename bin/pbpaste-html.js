#!/usr/bin/env -S usage exec osascript
//USAGE about "Print clipboard HTML, failing if no HTML is available."

ObjC.import("AppKit");

function run() {
    const html = ObjC.unwrap(
        $.NSPasteboard.generalPasteboard.stringForType("public.html"),
    );
    if (html === undefined) throw new Error("No HTML on clipboard");
    return html;
}
