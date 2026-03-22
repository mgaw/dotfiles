local ghostty = require('lib.ghostty')
local utils = require('lib.utils')

local M = {}

-- Opens a new Ghostty tab, optionally editing the prompt in nvim first, then
-- runs claude with the selected lines as context.
-- opts.plan_mode: if true, passes --permission-mode=plan to claude
function M.send_selection_to_claude(opts)
    opts = opts or {}
    local start_line = vim.fn.line('v')
    local end_line = vim.fn.line('.')
    if start_line > end_line then
        start_line, end_line = end_line, start_line
    end
    local file = vim.api.nvim_buf_get_name(0)
    local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

    local prompt =
        string.format('`%s` lines %d-%d:\n\n```\n%s\n```', file, start_line, end_line, table.concat(lines, '\n'))
    local tmpfile = vim.fn.tempname() .. '.md'
    vim.fn.writefile(vim.split(prompt, '\n'), tmpfile)

    local claude_cmd = 'claude'
    if opts.plan_mode then
        claude_cmd = claude_cmd .. ' --permission-mode=plan'
    end

    local cmd = string.format('file=%s; nvim "$file" && %s <"$file"', vim.fn.shellescape(tmpfile), claude_cmd)
    ghostty.new_tab(cmd)
    utils.feed_keycodes_noremap('<Esc>')
end

return M
