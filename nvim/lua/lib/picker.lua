local M = {}

local fullscreen_layout = {
    -- based on https://github.com/folke/snacks.nvim/blob/main/docs/picker.md#default
    layout = {
        box = 'horizontal',
        fullscreen = true,
        { win = 'list', border = 'hpad', width = 50 },
        { win = 'preview', width = 121 },
    },
}

function M.git_status()
    Snacks.picker.git_status({
        layout = fullscreen_layout,
    })
end

function M.base_diff()
    Snacks.picker.git_diff({
        base = require('lib.base').get_base_merge_base(),
        group = true,
        layout = fullscreen_layout,
    })
end

return M
