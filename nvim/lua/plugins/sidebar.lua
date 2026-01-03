local colors = require('user.colors')

local M = {}

local function get_available_width()
    local gutter_width = 6 -- numbers, signcolumn
    local textwidth = 121
    local two_separators = 2
    local taken_width = gutter_width + textwidth + two_separators

    return vim.o.columns - taken_width
end

function M.should_auto_open()
    return get_available_width() >= 20
end

function M.get_initial_width()
    local min_width = 20
    local max_width = 35
    return math.min(math.max(get_available_width(), min_width), max_width)
end

function M.update_state()
    require('sidebar-nvim.view').View.width = M.get_initial_width()

    if require('sidebar-nvim').is_open() then
        if M.should_auto_open() then
            require('sidebar-nvim.view').resize()
        else
            require('sidebar-nvim').close()
        end
    else
        vim.defer_fn(function()
            if M.should_auto_open() then
                require('sidebar-nvim').open()
            end
        end, 0)
    end
end

return {
    'https://github.com/sidebar-nvim/sidebar.nvim',
    dependencies = {
        'https://github.com/kyazdani42/nvim-web-devicons',
        opts = true,
    },
    config = function()
        require('sidebar-nvim.view').View.winopts.signcolumn = 'no' -- Save some horizontal space
        require('sidebar-nvim').setup({
            open = M.should_auto_open(),
            sections = { require('lib.sidebar_buffers') },
            update_interval = 0,
            initial_width = M.get_initial_width(),
        })
        vim.api.nvim_set_hl(0, 'SidebarNvimSectionTitle', { fg = colors.darkened_white })
        vim.api.nvim_set_hl(0, 'SidebarNvimNormal', { fg = colors.mid_grey_blue })
        vim.api.nvim_set_hl(0, 'SidebarNvimBuffersActive', { fg = colors.white, underline = true })
        vim.api.nvim_create_autocmd({ 'BufAdd', 'BufDelete', 'BufEnter' }, {
            callback = function()
                require('sidebar-nvim').update()
            end,
        })
    end,
    M = M,
}
