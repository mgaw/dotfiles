-- Maybe try https://github.com/debugloop/telescope-undo.nvim

return {
    -- Breaking changes: https://github.com/nvim-telescope/telescope.nvim/issues/1470
    'https://github.com/nvim-telescope/telescope.nvim',
    dependencies = {
        'https://github.com/nvim-lua/popup.nvim',
        'https://github.com/nvim-lua/plenary.nvim',
        'https://github.com/kyazdani42/nvim-web-devicons',
        {
            'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
            build = 'make',
        },
        'https://github.com/jmacadie/telescope-hierarchy.nvim',
    },
    opts = {
        defaults = {
            layout_strategy = 'vertical',
            layout_config = {
                vertical = { mirror = true, prompt_position = 'top', height = 100 },
                horizontal = { height = 100, width = 0.95, preview_width = 0.5 },
            },
            sorting_strategy = 'ascending',
            cache_picker = {
                num_pickers = -1, -- cache all pickers
            },
            mappings = {
                -- FYI <C-q> sends results to quickfix list
                i = {
                    ['<Esc>'] = function(...)
                        require('telescope.actions').close(...)
                    end,
                },
            },
        },
    },
    config = function(_, opts)
        require('telescope').setup(opts)
        require('telescope').load_extension('fzf')
        require('telescope').load_extension('hierarchy')
    end,
    lazy = true,
    cmd = 'Telescope',
}
