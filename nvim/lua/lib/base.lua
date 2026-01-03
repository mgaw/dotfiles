local M = {}

local function get_merge_base(other_branch)
    return vim.trim(vim.fn.system('git merge-base HEAD ' .. other_branch))
end

function M.get_base_merge_base()
    local base_branch = vim.trim(vim.fn.system('git get-base'))
    if base_branch == '' then
        base_branch = vim.trim(vim.fn.system('gh pr view --json baseRefName -q .baseRefName'))
    end
    if base_branch == '' then
        vim.notify('Could not determine base branch', vim.log.levels.WARN)
        return nil
    end
    return get_merge_base('origin/' .. base_branch)
end

return M
