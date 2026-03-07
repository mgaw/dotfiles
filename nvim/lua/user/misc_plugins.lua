return {
    {
        'https://github.com/windwp/nvim-autopairs',
        opts = {
            disable_in_visualblock = true,
        },
        event = 'InsertEnter',
    },

    -- Auto-closes tags, and keeps closing tag in sync when using ciw
    'https://github.com/windwp/nvim-ts-autotag',

    'https://github.com/tpope/vim-surround',

    -- Repeat more things, such as surround commands
    'https://github.com/tpope/vim-repeat',

    {
        'https://github.com/nvim-lua/lsp-status.nvim',
        config = function()
            require('lsp-status').register_progress()
            vim.o.statusline = vim.o.statusline .. " %{v:lua.require('lsp-status').status_progress()}"
        end,
        event = 'LspAttach',
    },

    {
        'https://github.com/preservim/vim-markdown',
        config = function()
            -- https://github.com/preservim/vim-markdown/#options
            vim.g.vim_markdown_folding_disabled = 1
            vim.g.vim_markdown_new_list_item_indent = 2
        end,
        ft = 'markdown',
    },

    {
        'https://github.com/ThePrimeagen/refactoring.nvim',
        lazy = true,
        cmd = 'Refactor',
        dependencies = {
            'https://github.com/nvim-lua/plenary.nvim',
            'https://github.com/nvim-treesitter/nvim-treesitter',
        },
        opts = {},
    },

    {
        'https://github.com/nvim-treesitter/nvim-treesitter-context',
        opts = {
            multiline_threshold = 1,
            mode = 'topline',
        },
    },

    {
        'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
        branch = 'main',
    },

    -- scrollbar with cursor, window, gitsigns, diagnostics
    {
        'https://github.com/lewis6991/satellite.nvim',
        opts = {
            handlers = {
                cursor = { enable = false },
            },
        },
    },
}
