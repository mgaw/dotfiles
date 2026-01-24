local utils = require('lib.utils')

local M = {}

M.insert_line_if_modifiable = {
    function()
        -- Adapted from https://stackoverflow.com/a/37211445
        if vim.o.modifiable then
            vim.cmd('normal o')
        else
            -- Avoid messing with plugins that use <CR> to trigger some action
            vim.cmd('normal <CR>')
        end
    end,
    desc = 'Insert line if modifiable',
}

M.replace_word_under_cursor = {
    ":%s/<C-r>=expand('<cword>')<CR>//g<Left><Left>",
    silent = false,
    desc = 'Replace word under cursor',
}

M.add_section = {
    function()
        if vim.o.filetype == 'text' then
            vim.api.nvim_input('Go<C-o>0<CR>--- ' .. vim.fn.strftime('%c') .. '<CR><CR>')
        elseif vim.o.filetype == 'markdown' then
            vim.api.nvim_input('Go<C-o>0<CR># ' .. vim.fn.strftime('%c') .. '<CR><CR>')
        else
            utils.not_implemented('add_section')
        end
    end,
    desc = 'Add section',
}

local function is_cursor_on_url()
    return vim.startswith(vim.fn.expand('<cfile>'), 'https://')
end

M.definitions = {
    function()
        if is_cursor_on_url() then
            vim.api.nvim_feedkeys('gx', '', true)
            return
        end

        if vim.o.filetype == 'help' then
            utils.feed_keycodes_noremap('<C-]>')
            return
        end

        if vim.o.filetype == 'less' then
            -- less doesn't work across files
            -- https://code.visualstudio.com/docs/languages/css#_go-to-declaration-and-find-references
            local word_under_cursor = vim.fn.expand('<cword>')
            if vim.startswith(word_under_cursor, '@') or vim.startswith(word_under_cursor, '--') then
                -- looks like less or css variable
                Snacks.picker.grep({ search = word_under_cursor .. ':' })
            elseif vim.startswith(word_under_cursor, '.') then
                -- looks like less macro
                Snacks.picker.grep({ search = word_under_cursor .. '.*\\{' })
            else
                -- not sure what to do, maybe LSP knows something
                Snacks.picker.lsp_definitions()
            end
            return
        end

        Snacks.picker.lsp_definitions()
    end,
    desc = 'Go to definition',
}

M.references = {
    function()
        if vim.o.filetype == 'less' then
            Snacks.picker.grep_word({ hidden = true })
        else
            Snacks.picker.lsp_references({ include_current = true })
        end
    end,
    desc = 'References',
}

return M
