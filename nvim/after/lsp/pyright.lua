local IGNORED_CODES = {}

-- https://github.com/microsoft/pyright
-- https://github.com/microsoft/pyright/blob/main/docs/configuration.md
return {
    on_attach = function()
        ---@diagnostic disable-next-line: duplicate-set-field
        vim.lsp.handlers['textDocument/publishDiagnostics'] = function(err, result, ctx, config)
            result.diagnostics = vim.tbl_filter(function(item)
                if item.source == 'Pyright' then
                    if vim.endswith(item.message, 'is not accessed') or IGNORED_CODES[item.code] then
                        return false
                    end
                end
                return true
            end, result.diagnostics)
            vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
        end
    end,
    settings = {
        python = {
            analysis = {
                diagnosticMode = 'openFilesOnly', -- Avoid getting stuck
            },
        },
    },
}
