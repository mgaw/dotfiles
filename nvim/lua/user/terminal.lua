local M = {}

function M.scratch_terminal(cmd, opts)
    opts = opts or {}
    require('FTerm').scratch({
        cmd = cmd,
        env = opts.env,
        on_exit = function(_, code)
            if opts.quit_on_exit or (opts.quit_on_success and code == 0) then
                vim.cmd('quit')
            end
        end,
    })
end

function M.term(cmd, opts)
    opts = opts or {}
    if opts.quit_on_success == nil then
        opts.quit_on_success = true
    end
    return {
        function()
            M.scratch_terminal(cmd, opts)
        end,
        desc = cmd,
    }
end

return {
    'https://github.com/numToStr/FTerm.nvim',
    lazy = true,
    M = M,
}
