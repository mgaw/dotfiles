local terminal = require('user.terminal').M

return {
    'https://github.com/vim-test/vim-test',
    version = '*',
    config = function()
        vim.g['test#custom_strategies'] = {
            scratch = function(cmd)
                terminal.scratch_terminal(cmd, { quit_on_success = true })
            end,
        }
        vim.g['test#python#pytest#options'] = '-svv'
    end,
    event = 'VeryLazy',
}
