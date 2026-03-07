local M = {}

local config = {
    next = { boundary = 'first', buf_cmd = 'bnext' },
    prev = { boundary = 'last', buf_cmd = 'bprev' },
}

function M.nav_hunk(direction, opts)
    opts = opts or {}
    local cfg = config[direction]
    local center = function()
        if opts.center then
            vim.cmd.normal('zz')
        end
    end

    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    require('gitsigns.actions').nav_hunk(direction, { target = 'all', wrap = false }, function()
        local new_row, new_col = unpack(vim.api.nvim_win_get_cursor(0))
        if new_row == row and new_col == col then
            if opts.cross_buffer then
                vim.cmd[cfg.buf_cmd]()
                require('gitsigns.actions').nav_hunk(cfg.boundary, { target = 'all' }, center)
            end
        else
            center()
        end
    end)
end

return M
