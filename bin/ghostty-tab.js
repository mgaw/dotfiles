#!/usr/bin/env -S usage exec osascript
//USAGE about "Open a Ghostty tab, optionally with a second command in a right split."
//USAGE arg "<command>" help="Command to run in the new tab"
//USAGE arg "<second-command>" help="Command to run in a right split, or an empty string for no split"
//USAGE arg "<background>" help="Set to true to keep the current tab focused"

ObjC.import("Foundation");

function run() {
    const { usage_command, usage_second_command, usage_background } =
        ObjC.deepUnwrap($.NSProcessInfo.processInfo.environment);
    const ghostty = Application("Ghostty");

    const window = ghostty.frontWindow();
    const prevTab = window.selectedTab();
    const cfg1 = ghostty.newSurfaceConfiguration();
    cfg1.initialInput = `${usage_command}\n`;
    const tab = ghostty.newTab({ in: window, withConfiguration: cfg1 });

    if (usage_second_command !== "") {
        const terminal = tab.focusedTerminal();
        const cfg2 = ghostty.newSurfaceConfiguration();
        cfg2.initialInput = `${usage_second_command}\n`;
        ghostty.split(terminal, {
            direction: "right",
            withConfiguration: cfg2,
        });
    }

    if (usage_background === "true") {
        // `newTab` returns before Ghostty selects the new tab (on the next
        // run-loop tick). Wait for it so that deferred focus change doesn't
        // steal focus back after selecting prevTab.
        for (let i = 0; i < 20; i++) {
            if (tab.selected()) break;
            delay(0.02);
        }
        ghostty.selectTab(prevTab);
    }
}
