return {
    {
        'https://github.com/windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup({
                disable_in_visualblock = true,
            })

            local npairs = require('nvim-autopairs')
            local Rule = require('nvim-autopairs.rule')
            npairs.add_rules({ Rule('“', '”') })
        end,
        event = 'InsertEnter',
    },

    -- Auto-closes tags, and keeps closing tag in sync when using ciw
    {
        'https://github.com/windwp/nvim-ts-autotag',
        dependencies = {
            'https://github.com/nvim-treesitter/nvim-treesitter',
        },
        opts = {},
        ft = { 'html', 'javascriptreact', 'typescriptreact', 'tsx', 'jsx', 'xml', 'php' },
    },

    'https://github.com/tpope/vim-surround',

    -- Repeat more things, such as surround commands
    'https://github.com/tpope/vim-repeat',

    -- Sets it up so that telescope is used for vim.ui.select
    -- (e.g. LSP code actions).
    --
    -- Also, gives an popup input field, e.g. for rename.
    --
    -- Even keeps telescope lazy-loading intact.
    {
        'https://github.com/stevearc/dressing.nvim',
        event = 'VeryLazy',
    },

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

    {
        'https://github.com/MagicDuck/grug-far.nvim',
        opts = {},
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
