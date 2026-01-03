return {
    'https://github.com/stevearc/conform.nvim',
    version = '*',
    event = 'VeryLazy',
    opts = {
        format_on_save = function()
            -- TODO apply code action fixes on save
            local denylist = vim.fn.split(vim.env.NO_FORMAT_ON_SAVE or '', ',')
            if not vim.tbl_contains(denylist, vim.o.filetype) then
                return { lsp_fallback = 'always' }
            end
        end,

        formatters = {
            injected = {
                options = {
                    ignore_errors = true,
                    lang_to_formatters = {
                        python = {
                            'ruff_organize_imports',
                            'ruff_format', -- for non-injected, ruff lsp does formatting
                        },
                        sh = { 'shfmt_injected' },
                    },
                },
            },
            shfmt_injected = {
                command = 'shfmt',
                args = { '-i', '2', '-filename', '$FILENAME', '-' }, -- consistent indentation in nix files
            },
        },

        -- List available with :h conform-formatters
        formatters_by_ft = {
            python = { 'ruff_organize_imports', 'injected' },
            sh = { 'shfmt', 'injected' }, -- shfmt configured in .editorconfig
            zsh = { 'shfmt' }, -- shfmt configured in .editorconfig
            lua = { 'stylua' },
            php = { 'php_cs_fixer' },
            less = { 'stylelint', 'prettier' },
            html = { 'prettier' },
            yaml = { 'prettier' },
            xml = { 'xmllint' },
            nix = { 'injected' },
            markdown = { 'injected' },
            quarto = { 'injected' },
        },
    },
}
