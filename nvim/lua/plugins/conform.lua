return {
    'https://github.com/stevearc/conform.nvim',
    version = '*',
    event = 'VeryLazy',
    opts = {
        default_format_opts = { lsp_format = 'last', timeout_ms = 3000 },
        format_on_save = function(bufnr)
            -- TODO apply code action fixes on save
            local denylist = vim.fn.split(vim.env.NO_FORMAT_ON_SAVE or '', ',')
            if not vim.tbl_contains(denylist, vim.bo[bufnr].filetype) then
                return {}
            end
        end,

        formatters = {
            treefmt = {
                -- Keep temporary files beside the buffer so formatters find local style settings.
                args = { '$FILENAME' },
                stdin = false,
                require_cwd = true,
                cwd = function(self, ctx)
                    return require('conform.util').root_file({ 'treefmt.toml', '.treefmt.toml' })(self, ctx)
                end,
            },
            injected = {
                options = {
                    ignore_errors = true,
                    lang_to_formatters = {
                        python = { 'treefmt' },
                        sh = { 'shfmt_injected' },
                        less = { 'treefmt' },
                        html = { 'treefmt' },
                        yaml = { 'treefmt' },
                        xml = { 'treefmt' },
                        json = { 'treefmt' },
                        lua = { 'treefmt' },
                        nix = { 'treefmt' },
                        toml = { 'treefmt' },
                    },
                },
            },
            shfmt_injected = {
                command = 'shfmt',
                args = { '-i', '2', '-filename', '$FILENAME', '-' }, -- consistent indentation in nix files
            },
        },

        formatters_by_ft = {
            ['*'] = function(bufnr)
                if #vim.lsp.get_clients({ bufnr = bufnr, method = 'textDocument/formatting' }) > 0 then
                    return { 'injected' }
                end
                return { 'injected', 'treefmt' }
            end,
        },
    },
}
