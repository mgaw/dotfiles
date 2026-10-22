local M = {}

-- True when nvim runs inside cmux. cmux embeds Ghostty and sets
-- TERM_PROGRAM=ghostty, so check for cmux's own environment instead.
-- CMUX_WORKSPACE_ID is also what `cmux new-surface` targets by default.
function M.is_host()
    return vim.env.CMUX_WORKSPACE_ID ~= nil
end

-- Opens a new surface (tab) in the current cmux pane and runs cmd.
-- Like Ghostty's initial input, the command is typed into a fresh shell that
-- stays open after cmd exits.
function M.new_tab(cmd)
    local cmux = vim.env.CMUX_BUNDLED_CLI_PATH or 'cmux'
    vim.fn.system({ cmux, 'new-surface', '--focus', 'true', '--command', cmd })
end

return M
