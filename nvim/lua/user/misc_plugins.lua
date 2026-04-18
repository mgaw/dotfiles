local colors = require('user.colors')

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

    {
        'https://github.com/tpope/vim-fugitive',
        dependencies = {
            -- Extend vim-fugitive to preview commit message in blame view
            'https://github.com/tommcdo/vim-fugitive-blame-ext',
            -- Extend vim-fugitive to support Github for :GBrowse
            'https://github.com/tpope/vim-rhubarb',
        },
        cmd = { 'Git', 'GBrowse' },
    },

    -- co :GitConflictChooseOurs — Select the current changes.
    -- ct :GitConflictChooseTheirs — Select the incoming changes.
    -- bt :GitConflictChooseBoth — Select both changes.
    -- c0 :GitConflictChooseNone — Select none of the changes.
    -- :GitConflictNextConflict — Move to the next conflict.
    -- :GitConflictPrevConflict — Move to the previous conflict.
    {
        'https://github.com/akinsho/git-conflict.nvim',
        version = '*',
        config = function()
            require('git-conflict').setup()
            vim.api.nvim_set_hl(0, 'GitConflictCurrentLabel', { bg = '#7f0000' })
            vim.api.nvim_set_hl(0, 'GitConflictCurrent', { bg = '#650000' })
            vim.api.nvim_set_hl(0, 'GitConflictAncestorLabel', { bg = colors.almost_black })
            vim.api.nvim_set_hl(0, 'GitConflictAncestor', { bg = colors.practically_black })
        end,
    },
}
