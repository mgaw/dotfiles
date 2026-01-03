vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        if vim.bo.filetype == 'quarto' then
            -- otter-ls does not support textDocument/documentHighlight
            return
        end

        -- This is not documented, but it seems needed to avoid flicker with LSP highlighting
        require('illuminate').on_attach(vim.lsp.get_client_by_id(args.data.client_id))

        -- Like https://github.com/RRethy/vim-illuminate/blob/c82e6d04f27/lua/illuminate.lua#L97
        -- but without CursorMovedI. g:Illuminate_insert_mode_highlight and modes_allowlist exist
        -- but they aren't respected for LSP-highlighting.
        vim.api.nvim_create_autocmd('CursorMoved', {
            buffer = args.buf,
            group = vim.api.nvim_create_augroup('vim_illuminate_lsp' .. args.buf, {}),
            callback = function()
                require('illuminate').on_cursor_moved(args.buf)
            end,
        })
    end,
})

return {
    -- Highlight the word under cursor, without flicker or delay!
    'https://github.com/RRethy/vim-illuminate',
    lazy = true,
    config = function()
        require('illuminate').configure({
            -- Set providers to empty list to not get highlights in buffers without LSP.
            -- This way, we don't need a filetypes_denylist.
            -- LSP highlighting is activated by calling on_attach above.
            providers = {},
            delay = 0,
        })
        vim.api.nvim_set_hl(0, 'IlluminatedWordText', { link = 'Visual' })
        vim.api.nvim_set_hl(0, 'IlluminatedWordRead', { link = 'Visual' })
        vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', { link = 'Visual' })
    end,
}
