return {
    'https://github.com/neovim/nvim-lspconfig',
    config = function()
        vim.lsp.config('*', {
            on_attach = function(client)
                client.server_capabilities.semanticTokensProvider = nil
            end,
            capabilities = require('cmp_nvim_lsp').default_capabilities(),
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
            'pyright',
            'ruff',
            'taplo',
            'vtsls',
        })
    end,
}
