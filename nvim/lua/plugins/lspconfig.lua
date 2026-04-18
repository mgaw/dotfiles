return {
    'https://github.com/neovim/nvim-lspconfig',
    version = '*',
    config = function()
        vim.lsp.config('*', {
            on_attach = function(client)
                client.server_capabilities.semanticTokensProvider = nil
            end,
        })

        -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
        vim.lsp.enable({
            'ast_grep',
            'bashls',
            'biome',
            'cssls',
            'html',
            'lua_ls',
            'nil_ls',
            'ruff',
            'stylua',
            'taplo',
            'ty',
            'vtsls',
        })
    end,
}
