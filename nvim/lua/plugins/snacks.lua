vim.api.nvim_set_hl(0, 'DiffChange', { bg = nil })

return {
    'https://github.com/folke/snacks.nvim',
    opts = {
        -- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md#%EF%B8%8F-config
        picker = {
            previewers = {
                diff = {
                    style = 'syntax',
                },
            },

            layout = {
                -- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md#vertical
                layout = {
                    backdrop = false,
                    width = 0.8,
                    height = 0.99,
                    min_height = 30,
                    box = 'vertical',
                    border = 'rounded',
                    title = '{title} {live} {flags}',
                    title_pos = 'center',
                    { win = 'input', height = 1, border = 'bottom' },
                    { win = 'list', border = 'none' },
                    { win = 'preview', title = '{preview}', height = 0.5, border = 'top' },
                },
            },
            win = {
                input = {
                    keys = {
                        ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
                        ['<C-a>'] = false,
                    },
                },
            },
            formatters = {
                file = {
                    truncate = 120,
                },
            },
            sources = {
                git_diff = {
                    sort = { fields = { 'text' } },
                },
            },
        },
    },
}
