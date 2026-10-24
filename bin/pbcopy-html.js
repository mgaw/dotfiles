#!/usr/bin/env -S usage exec osascript
//USAGE about "Copy HTML with a plain-text fallback."
//USAGE arg "<html>" help="HTML to copy"
//USAGE arg "<text>" help="Plain-text fallback to copy"

ObjC.import("AppKit");

function run() {
    const { usage_html, usage_text } = ObjC.deepUnwrap(
        $.NSProcessInfo.processInfo.environment,
    );
    const pb = $.NSPasteboard.generalPasteboard;
    pb.clearContents;
    if (
        !pb.setStringForType(usage_html, "public.html") ||
        !pb.setStringForType(usage_text, "public.utf8-plain-text")
    ) {
        throw new Error("Failed to write clipboard");
    }
}
