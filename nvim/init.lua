-- * Logs:
--   * ~/.cache/nvim
--   * ~/.local/state/nvim
--   * :LspLog
-- * Plugins: ~/.local/share/nvim/lazy
-- * Vim builtin functions (vim.fn.*):
--   * https://neovim.io/doc/user/usr_41.html#function-list
--   * https://neovim.io/doc/user/builtin.html
-- * Lua helpers (vim.*): https://neovim.io/doc/user/lua.html#lua-vim
-- * Lua reference manual: http://www.lua.org/manual/5.3/manual.html

require('user.autocmd')
require('user.command')
require('user.highlight')
require('user.keymap')
require('user.option')

require('user.lazy_bootstrap')

-- https://lazy.folke.io/spec
require('lazy').setup({
    require('plugins.aerial'),
    require('plugins.blink'),
    require('plugins.conform'),
    require('plugins.lspconfig'),
    require('plugins.sidebar'),
    require('plugins.snacks'),
    require('plugins.treesitter'),
    require('plugins.vim-test'),

    require('user.git'),
    require('user.misc_plugins'),
    require('user.notebook'),
    require('user.terminal'),
}, {
    rocks = { enabled = false },
})
