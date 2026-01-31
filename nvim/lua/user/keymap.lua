local alt = require('lib.alt')
local git = require('user.git').M
local helpers = require('lib.keymap-helpers')
local notebook = require('user.notebook').M
local open_file = require('lib.open_file')
local picker = require('lib.picker')
local run_file = require('lib.run_file')
local terminal = require('user.terminal').M
local utils = require('lib.utils')

require('lib.set_keymaps')({
    s = '<Cmd>write<CR>',
    q = '<Cmd>quit<CR>',
    ['<C-d>'] = '<Cmd>quit<CR>',

    ['<CR>'] = helpers.insert_line_if_modifiable,
    ['<BS>'] = 'daw',
    ['<Space>'] = '"_ciw',
    ['<Esc>'] = { n = '<Cmd>nohlsearch<CR>' },

    -- Don't overwrite 0 register on change or put
    c = { nx = '"_c' },
    C = { nx = '"_C' },
    p = { x = '"_dP' },

    -- Use screen lines for up/down
    j = { nx = 'gj' },
    k = { nx = 'gk' },

    -- Emacs-like movements
    ['<C-f>'] = { i = '<Right>', c = { '<Right>', silent = false } },
    ['<C-b>'] = { i = '<Left>', c = { '<Left>', silent = false } },
    ['<C-a>'] = { nx = 'g^', s = '<Esc>I', i = '<C-o>g^', c = { '<C-b>', silent = false } },
    ['<C-e>'] = { nx = 'g$', s = '<Esc>A', i = '<c-o>g$' },

    -- [alt.f]
    -- [alt.b]

    ['<C-j>'] = { nx = '}', i = '<CR>' },
    ['<C-k>'] = { nx = '{' },
    [alt.j] = 'd}', -- delete paragraph below
    [alt.k] = 'd{', -- delete paragraph above
    -- Alternatively, use <A-S-o>, j/k, <CR>
    [alt.shift.j] = '<Cmd>AerialNext<CR>',
    [alt.shift.k] = '<Cmd>AerialPrev<CR>',

    ['<C-h>'] = '<Cmd>bp<CR>',
    ['<C-l>'] = '<Cmd>bn<CR>',

    [alt.o] = 'o<c-o>O', -- "open new paragraph" from empty line
    [alt.shift.o] = {
        n = '<cmd>AerialOpen<CR>',
        i = '<C-o>O', -- open line above
    },

    [';'] = {
        n = { ':%s///g<Left><Left><Left>', silent = false },
        x = { ':s///g<Left><Left><Left>', silent = false },
    },
    [alt[';']] = helpers.replace_word_under_cursor,

    [',,'] = helpers.add_section,

    J = {
        x = 'j', -- allow movement (and avoid join) in visual-line mode if shift is still pressed
    },
    K = {
        n = 'i<CR><Esc>', -- split line (opposite of join)
        x = 'k', -- allow movement in visual-line mode if shift is still pressed
    },

    ['-'] = { nx = '~' }, -- change case

    [alt.shift.m] = open_file.open_main_file,
    [alt.shift.t] = {
        n = open_file.open_test_file,
        i = function()
            local branch = vim.trim(vim.fn.system('git rev-parse --abbrev-ref HEAD 2>/dev/null'))
            local ticket = branch:match('(%w+-%d+)')
            if ticket then
                vim.api.nvim_put({ ticket }, 'c', true, true)
            end
        end,
    },
    [alt.shift.z] = open_file.open_other_file,

    [alt.w] = terminal.term('git show', { env = git.PAGED }),
    [alt.p] = terminal.term('git add --patch && git commit --verbose'),
    [alt.a] = '<Cmd>Git add %<CR>',

    -- [alt.d]
    [alt.shift.d] = function()
        require('gitsigns.actions').preview_hunk_inline()
    end,

    [alt.shift.a] = function()
        require('gitsigns.actions').stage_hunk()
    end,
    [alt.shift.u] = function()
        require('gitsigns.actions').reset_hunk()
    end,
    [alt.shift.n] = function()
        require('gitsigns.actions').nav_hunk('next', { target = 'all' })
    end,
    [alt.shift.p] = function()
        require('gitsigns.actions').nav_hunk('prev', { target = 'all' })
    end,
    gb = '<Cmd>Git blame<CR>',

    L = {
        function()
            terminal.scratch_terminal(
                { 'git', 'log', '--patch', '--', vim.api.nvim_buf_get_name(0) },
                { env = git.PAGED, quit_on_exit = true }
            )
        end,
        desc = 'Show history of current file',
    },
    [alt.shift.l] = {
        function()
            terminal.scratch_terminal(
                { 'git', 'log', '--patch', git.other_head(), '--', vim.api.nvim_buf_get_name(0) },
                { env = git.PAGED, quit_on_exit = true }
            )
        end,
        desc = 'Show history of current file (other head)',
    },

    [alt['.']] = {
        function()
            local merge_base = vim.trim(vim.fn.system({ 'git', 'merge-base', 'HEAD', git.other_head() }))
            terminal.scratch_terminal(
                { 'git', 'diff', merge_base, 'HEAD', '--', vim.api.nvim_buf_get_name(0) },
                { env = git.PAGED, quit_on_exit = true }
            )
        end,
        desc = 'Diff merge base against HEAD',
    },
    [alt.shift['.']] = {
        function()
            local other_head = git.other_head()
            local merge_base = vim.trim(vim.fn.system({ 'git', 'merge-base', 'HEAD', other_head }))
            terminal.scratch_terminal(
                { 'git', 'diff', merge_base, other_head, '--', vim.api.nvim_buf_get_name(0) },
                { env = git.PAGED, quit_on_exit = true }
            )
        end,
        desc = 'Diff merge base against other head',
    },

    ['<C-q>'] = vim.lsp.buf.code_action,

    [alt.s] = {
        n = picker.git_status,
        i = vim.lsp.buf.signature_help,
    },
    -- [alt.shift.s]

    [alt.shift.f] = function()
        vim.lsp.buf.code_action({ context = { only = { 'source.fixAll' } }, apply = true })
        require('conform').format({ lsp_fallback = 'always' })
    end,
    -- replace
    [alt.r] = { nx = ':GrugFar<CR>' },
    -- rename
    [alt.shift.r] = {
        n = function()
            vim.lsp.buf.rename()
        end,
    },

    -- e is for execute
    [alt.e] = function()
        run_file.run_file()
    end,
    [alt.shift.e] = function()
        if vim.bo.filetype == 'quarto' then
            notebook.run_all_cells()
        end
    end,

    ['<C-p>'] = vim.diagnostic.goto_prev,
    ['<C-n>'] = vim.diagnostic.goto_next,
    [alt.shift.w] = function()
        Snacks.picker.diagnostics()
    end,

    ['ö'] = helpers.definitions,
    ['Ö'] = vim.lsp.buf.hover,
    [alt['ö']] = function()
        Snacks.picker.grep_word({
            hidden = true,
            live = true,
            exclude = { '*.test.tsx', '*.test.ts', '*_test.py', '__init__.py' },
        })
    end,
    [alt.shift['ö']] = {
        nx = function()
            Snacks.picker.grep_word({ hidden = true, live = true })
        end,
    },
    [alt.t] = function()
        Snacks.picker.lsp_type_definitions()
    end,

    ['ä'] = helpers.references,
    [alt['ä']] = {
        function()
            Snacks.picker.resume('lsp_references')
        end,
        desc = 'Resume references',
    },
    ['Ä'] = '<Cmd>Telescope hierarchy incoming_calls<CR>',
    -- should resume incoming calls picker
    -- [alt.shift['ä']]

    -- [alt['/']]

    ['ü'] = {
        n = function()
            Snacks.picker.grep({ hidden = true })
        end,
        x = function()
            Snacks.picker.grep_word({ hidden = true, live = true })
        end,
    },
    [alt['ü']] = {
        function()
            Snacks.picker.resume('grep')
        end,
        desc = 'Resume grep',
    },

    -- ['Ü']
    -- [alt.shift['ü']]

    ['+'] = function()
        Snacks.picker.files({ hidden = true })
    end,
    [alt['+']] = {
        function()
            Snacks.picker.resume('files')
        end,
        desc = 'Resume find files',
    },
    [alt.shift['+']] = { i = '•' },

    ['<2-LeftMouse>'] = helpers.definitions,
    ['<MiddleMouse>'] = function()
        utils.feed_keycodes_noremap('<LeftMouse>')
        helpers.definitions[1]()
    end,
    ['<2-MiddleMouse>'] = function()
        utils.feed_keycodes_noremap('<LeftMouse>')
        helpers.references[1]()
    end,

    gre = { nx = ':Refactor extract_var<CR>' },
    gri = { nx = ':Refactor inline_var<CR>' },
    grI = { nx = ':Refactor inline_func<CR>' },
    grp = {
        nx = function()
            require('refactoring').debug.print_var()
        end,
    },
    grf = {
        nx = function()
            require('refactoring').debug.printf()
        end,
    },
    grc = function()
        require('refactoring').debug.cleanup({})
    end,

    gp = '<Plug>(git-conflict-prev-conflict)',
    gn = '<Plug>(git-conflict-next-conflict)',
    cn = '<Plug>(git-conflict-next-conflict)',
    cp = '<Plug>(git-conflict-next-conflict)',

    -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects#built-in-textobjects
    af = {
        xo = function()
            require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects')
        end,
    },
    ['if'] = {
        xo = function()
            require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects')
        end,
    },
    ac = {
        xo = function()
            require('nvim-treesitter-textobjects.select').select_textobject('@class.outer', 'textobjects')
        end,
    },
    ic = {
        xo = function()
            require('nvim-treesitter-textobjects.select').select_textobject('@class.inner', 'textobjects')
        end,
    },
    ['a,'] = {
        xo = function()
            require('nvim-treesitter-textobjects.select').select_textobject('@parameter.outer', 'textobjects')
        end,
    },
    ['i,'] = {
        xo = function()
            require('nvim-treesitter-textobjects.select').select_textobject('@parameter.inner', 'textobjects')
        end,
    },
})
