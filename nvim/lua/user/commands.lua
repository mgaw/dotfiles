vim.api.nvim_create_user_command('WQ', 'wq', {})
vim.api.nvim_create_user_command('Wq', 'wq', {})
vim.api.nvim_create_user_command('Q', 'q', {})

-- Write and create any missing parent directories
vim.api.nvim_create_user_command('W', function()
    vim.fn.mkdir(vim.fn.expand('%:p:h'), 'p')
    vim.cmd('write')
end, {})

vim.api.nvim_create_user_command('OpenFile', function()
    Snacks.picker.files({ hidden = true })
end, {})

vim.api.nvim_create_user_command('RenameFile', function()
    Snacks.rename.rename_file()
end, {})

vim.api.nvim_create_user_command('Review', function()
    local base_merge_base = require('lib.base').get_base_merge_base()
    if not base_merge_base then
        return
    end

    for _, file in ipairs(vim.fn.systemlist('git diff --name-only ' .. base_merge_base)) do
        vim.cmd('edit ' .. vim.fn.fnameescape(file))
    end

    vim.defer_fn(function()
        -- not sure why this needs to be deferred
        vim.cmd('Gitsigns change_base ' .. base_merge_base .. ' true')
    end, 100)
    vim.cmd('Gitsigns toggle_deleted') -- show deleted lines as virtual lines
end, {})
