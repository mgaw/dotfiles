local M = {}

-- *Inline are word_diff highlight groups.
--
-- {Add,Change}Inline work in preview. In buffer, they only work if not linehl.
-- (That seems to be a bug because the original TermCursor highlight also works
-- with linehl.)
-- DeleteInline also works in virtual text.
function M.configure(opts)
    vim.api.nvim_set_hl(0, 'GitSignsAdd', { fg = 'green' })
    vim.api.nvim_set_hl(0, 'GitSignsAddLn', { bg = '#0b1506' })
    vim.api.nvim_set_hl(0, 'GitSignsAddInline', { bg = '#004000' })

    vim.api.nvim_set_hl(0, 'GitSignsDelete', { fg = 'red' })
    vim.api.nvim_set_hl(0, 'GitSignsDeleteVirtLn', { bg = '#141111', fg = '#665555', italic = true })
    vim.api.nvim_set_hl(0, 'GitSignsDeleteInline', { bg = '#220909', fg = '#997777' })

    -- Whether to show deleted lines as virtual lines
    require('gitsigns').toggle_deleted(opts.show_deleted)
    -- When showing the virtual lines, add line highlights for better readability
    require('gitsigns').toggle_linehl(opts.show_deleted)
    if opts.show_deleted then
        vim.api.nvim_set_hl(0, 'GitSignsChangeLn', { bg = '#0b1506' })
        vim.api.nvim_set_hl(0, 'GitSignsChangeInline', { bg = '#004000' })

        -- If showing deleted, show the "changed" lines as "added"
        vim.api.nvim_set_hl(0, 'GitSignsChange', { fg = 'green' })
    else
        vim.api.nvim_set_hl(0, 'GitSignsChange', { fg = 'yellow' })
    end
end

return {
    'https://github.com/lewis6991/gitsigns.nvim',
    version = '*',
    config = function()
        require('gitsigns').setup()
        M.configure({ show_deleted = false })
    end,
    M = M,
}
