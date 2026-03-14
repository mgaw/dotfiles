local M = {}

function M.feed_keycodes_noremap(keys)
    if type(keys) == 'table' then
        -- Allow using list for easier commenting if individual keys
        keys = table.concat(keys)
    end
    vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes(
            keys,
            true, -- "as usual"
            false, -- don't replace <lt>
            true -- replace keycodes
        ),
        'n', -- don't remap
        false -- nvim_replace_termcodes was used
    )
end

function M.not_implemented(name)
    vim.notify(name .. ' not implemented for ft=' .. vim.o.filetype, vim.log.levels.WARN)
end

function M.cursor_in_comment()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local captures = vim.treesitter.get_captures_at_pos(0, row - 1, math.max(0, col - 1))
    for _, capture in ipairs(captures) do
        if capture.capture == 'comment' then
            return true
        end
    end
    return false
end

function _G.log(value)
    print(vim.inspect(value))
    return value
end

return M
