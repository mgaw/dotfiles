local base = require('lib.base')
local git = require('user.git').M

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

vim.api.nvim_create_user_command('Approve', function()
    vim.fn.system({ 'gh', 'pr', 'review', '--approve' })
    vim.cmd.quit()
end, {})

vim.api.nvim_create_user_command('Review', function()
    local base_merge_base = base.get_base_merge_base()
    if not base_merge_base then
        return
    end

    require('gitsigns').change_base(base_merge_base, true)
    git.configure_gitsigns({ show_deleted = true })

    for file in vim.iter(vim.fn.systemlist({ 'git', 'diff', '--name-only', base_merge_base })) do
        vim.cmd.badd(file)
        local bufnr = vim.fn.bufnr(file)

        for line in vim.iter(vim.fn.systemlist({ 'git', 'diff', '--unified=0', base_merge_base, '--', file })) do
            local start_line = line:match('^@@ .* %+(%d+)')
            if start_line then
                vim.b[bufnr].set_cursor_line = tonumber(start_line)
                break
            end
        end
    end

    -- Delete empty initial buffer
    if vim.api.nvim_buf_get_name(0) == '' and vim.api.nvim_buf_line_count(0) <= 1 then
        vim.api.nvim_buf_delete(0, {})
    end
end, {})
