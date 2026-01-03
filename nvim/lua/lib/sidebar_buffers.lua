-- Adapted from https://github.com/sidebar-nvim/sidebar.nvim/blob/main/lua/sidebar-nvim/builtin/buffers.lua

local Loclist = require('sidebar-nvim.components.loclist')
local has_devicons, devicons = pcall(require, 'nvim-web-devicons')
local filename_disambiguation = require('lib.filename_disambiguation')

local loclist = Loclist:new({ omit_single_group = true })

local function get_fileicon(filename)
    if has_devicons and devicons.has_loaded() then
        local extension = filename:match('^.+%.(.+)$')
        local icon, highlight = devicons.get_icon(filename, extension)

        return {
            text = (icon or '') .. ' ',
            hl = highlight or 'SidebarNvimNormal',
        }
    else
        return { text = ' ' }
    end
end

local function get_buffers(ctx)
    local buffer_paths = {}
    local valid_buffers = {}

    for _, buf in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
        buffer_paths[buf.bufnr] = buf.name
        table.insert(valid_buffers, buf.bufnr)
    end

    local disambiguated_names = filename_disambiguation.disambiguate_filenames(buffer_paths)

    local loclist_items = {}
    for _, buffer in ipairs(valid_buffers) do
        local bufname = buffer_paths[buffer]
        local modified = vim.api.nvim_buf_get_option(buffer, 'modified') and ' *' or ''
        local name_hl = buffer == vim.api.nvim_get_current_buf() and 'SidebarNvimBuffersActive' or 'SidebarNvimNormal'

        loclist_items[#loclist_items + 1] = {
            group = 'buffers',
            left = {
                get_fileicon(bufname),
                {
                    text = disambiguated_names[buffer] .. modified,
                    hl = name_hl,
                },
            },
            data = { buffer = buffer, filepath = bufname },
            order = buffer,
        }
    end
    loclist:set_items(loclist_items, { remove_groups = false })

    local lines = {}
    local hl = {}
    loclist:draw(ctx, lines, hl)
    return { lines = lines, hl = hl }
end

local function edit_file(line)
    local location = loclist:get_location_at(line)
    if location == nil then
        return
    end

    vim.cmd('wincmd p')
    vim.cmd('e ' .. location.data.filepath)
end

return {
    title = 'Buffers',
    icon = '',
    draw = function(ctx)
        return get_buffers(ctx)
    end,
    bindings = {
        ['<CR>'] = edit_file,
        ['<2-LeftMouse>'] = edit_file,
    },
}
