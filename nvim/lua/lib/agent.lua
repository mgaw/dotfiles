local utils = require('lib.utils')

-- 'claude' or 'codex', selected via $NVIM_AGENT
local function get_agent()
    return vim.env.NVIM_AGENT or 'codex'
end

local M = {}

-- Opens a new terminal tab, edits the prompt in nvim,
-- then runs the configured agent with the selected lines as context.
-- opts.plan_mode: use Claude's plan mode; unsupported for Codex.
function M.send_selection_to_agent(opts)
    opts = opts or {}
    local agent = get_agent()
    if agent == 'codex' and opts.plan_mode then
        return utils.not_implemented('Codex plan mode')
    end

    local start_line = vim.fn.line('v')
    local end_line = vim.fn.line('.')
    if start_line > end_line then
        start_line, end_line = end_line, start_line
    end
    local file = vim.fn.resolve(vim.api.nvim_buf_get_name(0))
    local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

    local prompt =
        string.format('`%s` lines %d-%d:\n\n```\n%s\n```', file, start_line, end_line, table.concat(lines, '\n'))
    local tmpfile = vim.fn.tempname() .. '.md'
    vim.fn.writefile(vim.split(prompt, '\n'), tmpfile)

    local agent_cmd
    if agent == 'claude' then
        agent_cmd = 'claude' .. (opts.plan_mode and ' --permission-mode=plan' or '') .. ' <"$file"'
    elseif agent == 'codex' then
        agent_cmd = 'codex -- "$(cat "$file")"'
    else
        error('Unsupported agent: ' .. agent)
    end

    local cmd = string.format('file=%s; nvim "$file" && %s', vim.fn.shellescape(tmpfile), agent_cmd)
    vim.fn.system({ 'terminal-tab', cmd })
    utils.feed_keycodes_noremap('<Esc>')
end

return M
