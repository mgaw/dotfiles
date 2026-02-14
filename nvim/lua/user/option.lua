-- Use persistent undo
vim.o.undofile = true

-- Don't use swapfile:
--
-- - I've never used `vim -r` in 10 years
-- - Now that vim auto-reloads a changed-on-disk buffer, it should be OK
--   to open the same file in two vims.
vim.o.swapfile = false

-- Enable mouse support
vim.o.mouse = 'a'

-- Use system clipboard
vim.o.clipboard = 'unnamed'

-- Enable 24 bit colors
-- https://github.com/termstandard/colors
vim.o.termguicolors = true

-- Insert spaces when pressing Tab key
vim.o.expandtab = true
-- Use 4 spaces for a tab (this will usually be overriden by LSP)
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4

-- Show file name in terminal title.
vim.o.title = true

-- Always show sign column
-- Doing this to avoid jumps when signs appear
vim.o.signcolumn = 'yes'

-- Show line numbers
vim.o.number = true

-- Highlight the line number where cursor currently is
vim.o.cursorline = true
vim.o.cursorlineopt = 'number'

vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
-- zM to fold everything
vim.o.foldenable = false

-- Don't wrap in the middle of a word
vim.o.linebreak = true

vim.o.colorcolumn = '121'

-- Keep 7 lines distance between cursor and edge of window
vim.o.scrolloff = 7

-- Reducing noise
-- Insert mode is already discernable via the cursor shape.
-- Visual mode is already discernable via the Visual highlighting
-- (after moving the cursor anyway).
vim.o.showmode = false

-- Always show status line
vim.o.laststatus = 2
vim.o.statusline = '%F' -- full file name

-- Do case-sensitive search when uppercase letter present,
-- otherwise case-insensitive
vim.o.ignorecase = true
vim.o.smartcase = true

-- Don't add missing `\n` after last line, because it adds noise to diffs.
vim.o.fixendofline = false

-- For no lingering ^[
vim.o.ttimeoutlen = 0

vim.o.exrc = true

vim.filetype.add({
    filename = {
        ['.eslintrc.json'] = 'jsonc',
        ['tsconfig.json'] = 'jsonc',
    },
    pattern = {
        ['.*envrc.*'] = 'sh',
        ['.*/templates/.*%.ya?ml'] = 'helm',
        ['.*/%.vscode/.*%.json'] = 'jsonc',
    },
})

vim.g.maplocalleader = ','
