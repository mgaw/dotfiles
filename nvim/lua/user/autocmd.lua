local aerial = require('plugins.aerial').M
local sidebar = require('plugins.sidebar').M

vim.api.nvim_create_autocmd('VimResized', {
    callback = function()
        sidebar.update_state()
        aerial.update_state()
    end,
})

local function should_quit_on_win_closed()
    local aerial_found = false
    local standalone_buffer_found = false

    for _, win in ipairs(vim.api.nvim_list_wins()) do
        -- Assume a 1-width window is the scrollbar satellite.nvim
        if vim.api.nvim_win_get_width(win) > 5 then
            local bufnr = vim.api.nvim_win_get_buf(win)
            local ft = vim.api.nvim_buf_get_option(bufnr, 'filetype')
            if ft == 'aerial' then
                -- for some reason, when only sidebar.nvim is open, the extra :qa will
                -- trigger a "press enter or command to continue" prompt
                aerial_found = true
            end
            if ft ~= 'SidebarNvim' and ft ~= 'aerial' then
                standalone_buffer_found = true
            end
        end
    end

    return aerial_found and not standalone_buffer_found
end

vim.api.nvim_create_autocmd('WinClosed', {
    group = vim.api.nvim_create_augroup('ExitIfLastRealBuffer', { clear = true }),
    callback = function()
        vim.schedule(function()
            if should_quit_on_win_closed() then
                vim.cmd('qa')
            end
        end)
    end,
    desc = 'Exit Neovim when only sidebar/aerial buffers remain',
})

-- https://github.com/gopasspw/gopass/blob/master/docs/setup.md#securing-your-editor
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
    pattern = { '/dev/shm/gopass*', '/private/**/gopass**' },
    callback = function()
        vim.opt_local.swapfile = false
        vim.opt_local.backup = false
        vim.opt_local.undofile = false
        vim.opt.shada = ''
    end,
    desc = 'Disable swap, backup, undo, and shada for gopass files',
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'less',
    callback = function()
        vim.opt_local.iskeyword = '@,48-57,_,192-255,-,@-@,.'
    end,
    desc = 'Set iskeyword for less files',
})
