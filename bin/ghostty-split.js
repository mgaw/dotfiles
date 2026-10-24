#!/usr/bin/env -S usage exec osascript
//USAGE about "Run a command in a right split, keeping the original terminal focused."
//USAGE arg "<command>" help="Command to run in the new split"

ObjC.import("Foundation");

function run() {
    const { usage_command } = ObjC.deepUnwrap(
        $.NSProcessInfo.processInfo.environment,
    );
    const ghostty = Application("Ghostty");

    const tab = ghostty.frontWindow().selectedTab();
    const terminal = tab.focusedTerminal();
    const cfg = ghostty.newSurfaceConfiguration();
    cfg.initialInput = `${usage_command}\n`;
    const newTerminal = ghostty.split(terminal, {
        direction: "right",
        withConfiguration: cfg,
    });

    // Ghostty focuses the new split on the next run-loop tick, which would
    // undo an immediate focus change, so wait for it before focusing back.
    for (let i = 0; i < 20; i++) {
        if (tab.focusedTerminal().id() === newTerminal.id()) break;
        delay(0.02);
    }
    ghostty.focus(terminal);
}
