local terminal = require('user.terminal').M
local utils = require('lib.utils')

local M = {}

local function is_test_file()
    local name = vim.api.nvim_buf_get_name(0)
    for _, tail in ipairs({ '.test.ts', '.test.tsx', '_test.py', '_spec.lua' }) do
        if vim.endswith(name, tail) then
            return true
        end
    end
    return false
end

local run_by_ft = {
    javascript = function()
        terminal.scratch_terminal({ 'node', vim.fn.expand('%') })
    end,
    python = function()
        terminal.scratch_terminal({ 'python', vim.fn.expand('%') })
    end,
    sh = function()
        terminal.scratch_terminal({ 'bash', vim.fn.expand('%') })
    end,
    yaml = function()
        terminal.scratch_terminal({ 'ast-grep', 'scan', '--rule', vim.fn.expand('%') })
    end,
    quarto = function()
        require('quarto.runner').run_cell()
    end,
}

function M.run_file()
    if is_test_file() then
        vim.cmd('TestNearest -strategy=scratch')
        return
    end

    local run = run_by_ft[vim.o.filetype]
    if run then
        run()
        return
    end

    utils.not_implemented('run')
end

return M
