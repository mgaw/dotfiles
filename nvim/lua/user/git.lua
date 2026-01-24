local colors = require('user.colors')

local M = {}

-- -+F to ensure that pager is always used to ensure that diff is visible
-- if it fits to one screen
M.PAGED = { GIT_PAGER = 'less -+F' }

function M.other_head()
    return vim.fn.trim(vim.fn.system('ls .git | grep -e MERGE_HEAD -e REBASE_HEAD -e CHERRY_PICK_HEAD'))
end

-- *Inline are word_diff highlight groups.
--
-- {Add,Change}Inline work in preview. In buffer, they only work if not linehl.
-- (That seems to be a bug because the original TermCursor highlight also works
-- with linehl.)
-- DeleteInline also works in virtual text.
function M.configure_gitsigns(opts)
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
    {
        'https://github.com/lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup()
            M.configure_gitsigns({ show_deleted = false })
        end,
    },

    {
        'https://github.com/tpope/vim-fugitive',
        dependencies = {
            -- Extend vim-fugitive to preview commit message in blame view
            'https://github.com/tommcdo/vim-fugitive-blame-ext',
            -- Extend vim-fugitive to support Github for :GBrowse
            'https://github.com/tpope/vim-rhubarb',
        },
        cmd = { 'Git', 'GBrowse' },
    },

    -- co :GitConflictChooseOurs — Select the current changes.
    -- ct :GitConflictChooseTheirs — Select the incoming changes.
    -- bt :GitConflictChooseBoth — Select both changes.
    -- c0 :GitConflictChooseNone — Select none of the changes.
    -- :GitConflictNextConflict — Move to the next conflict.
    -- :GitConflictPrevConflict — Move to the previous conflict.
    {
        'https://github.com/akinsho/git-conflict.nvim',
        version = '*',
        config = function()
            require('git-conflict').setup()
            vim.api.nvim_set_hl(0, 'GitConflictCurrentLabel', { bg = '#7f0000' })
            vim.api.nvim_set_hl(0, 'GitConflictCurrent', { bg = '#650000' })
            vim.api.nvim_set_hl(0, 'GitConflictAncestorLabel', { bg = colors.almost_black })
            vim.api.nvim_set_hl(0, 'GitConflictAncestor', { bg = colors.practically_black })
        end,
    },
    M = M,
}
