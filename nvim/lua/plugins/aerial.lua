local sidebar = require('plugins.sidebar').M

local M = {}

local function get_available_width()
    local gutter_width = 6 -- numbers, signcolumn
    local textwidth = 121
    local two_separators = 2
    local taken_width = gutter_width + textwidth + two_separators

    local sidebar_nvim_ok, sidebar_nvim = pcall(require, 'sidebar-nvim')
    if sidebar_nvim_ok then
        if sidebar_nvim.is_open() then
            taken_width = taken_width + sidebar_nvim.get_width()
        end
    else
        if sidebar.should_auto_open() then
            taken_width = taken_width + sidebar.get_initial_width()
        end
    end

    return vim.o.columns - taken_width
end

local function should_auto_open()
    return get_available_width() >= 25
end

-- Ensure get_available_width and should_auto_open are applied
function M.update_state()
    require('aerial').close()
    require('aerial.config').layout.width = get_available_width()

    vim.defer_fn(function()
        if should_auto_open() then
            require('aerial').open({ focus = false })
        end
    end, 0)
end

return {
    'https://github.com/stevearc/aerial.nvim',
    version = '*',
    lazy = not should_auto_open(),
    cmd = 'AerialOpen',
    opts = {
        layout = {
            width = get_available_width(),
            max_width = 45, -- more or less take up available space on 3/4 window
            min_width = 25,
            default_direction = 'right',
            placement = 'edge',
        },
        autojump = true,

        attach_mode = 'global',

        open_automatic = should_auto_open,
        close_on_select = function()
            return not should_auto_open()
        end,

        filter_kind = {
            'Array',
            'Boolean',
            'Class',
            'Constant',
            'Constructor',
            -- 'Enum', -- arrays (!) in YAML files
            -- 'EnumMember',
            'Event',
            'Field',
            'File',
            'Function',
            'Interface',
            'Key',
            'Method',
            -- 'Module', -- less media queries (!)
            'Namespace',
            'Null',
            'Number',
            'Object',
            'Operator',
            'Package',
            'Property',
            'String',
            -- 'Struct', -- don't show components in tsx
            'TypeParameter',
            -- 'Variable',
        },
    },
    M = M,
}
