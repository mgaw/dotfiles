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

---@param cmd string[]
---@return string
function M.system(cmd)
    return vim.trim(vim.system(cmd):wait().stdout)
end

--- @param cmd string[]
function M.systemlist(cmd)
    local stdout = vim.system(cmd, { text = true }):wait().stdout
    return vim.split(stdout, '\n', { plain = true, trimempty = true })
end

function _G.log(value)
    print(vim.inspect(value))
    return value
end

return M
