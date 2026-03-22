local M = {}

-- Opens a new tab in the front Ghostty window and runs cmd.
function M.new_tab(cmd)
    vim.fn.system({
        'osascript',
        '-e',
        'tell application "Ghostty"',
        '-e',
        'set t to new tab in front window',
        '-e',
        'set term to focused terminal of t',
        '-e',
        string.format('input text "%s\n" to term', cmd:gsub('\\', '\\\\'):gsub('"', '\\"')),
        '-e',
        'end tell',
    })
end

return M
