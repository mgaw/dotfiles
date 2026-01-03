return {
    'https://github.com/pmizio/typescript-tools.nvim',
    dependencies = {
        'https://github.com/nvim-lua/plenary.nvim',
        'https://github.com/neovim/nvim-lspconfig',
    },
    opts = {
        on_init = function(client)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false

            -- Turn off semantic syntax highlighting because it's too slow compared to treesitter.
            client.server_capabilities.semanticTokensProvider = nil
        end,

        on_attach = function()
            local ignored_codes = {
                -- [6133] = true, -- 'x' is declared but its value is never read.
                [80006] = true, -- This may be converted to an async function.
            }

            ---@diagnostic disable-next-line: duplicate-set-field
            vim.lsp.handlers['textDocument/publishDiagnostics'] = function(err, result, ctx, config)
                result.diagnostics = vim.tbl_filter(function(item)
                    return item.source ~= 'tsserver' or not ignored_codes[item.code]
                end, result.diagnostics)
                vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
            end
        end,
    },
}
