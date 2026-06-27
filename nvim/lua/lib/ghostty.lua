local M = {}

local new_tab_script = [[
tell application "Ghostty"
    set cfg to new surface configuration
    set initial input of cfg to "%s" & linefeed
    set t to new tab in front window with configuration cfg
end tell
]]

-- Opens a new tab in the front Ghostty window and runs cmd.
function M.new_tab(cmd)
    local escaped = cmd:gsub('\\', '\\\\'):gsub('"', '\\"')
    local script = string.format(new_tab_script, escaped)
    vim.fn.system({ 'osascript', '-e', script })
end

return M
