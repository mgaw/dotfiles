-- setting is a table
-- - keyed values are options for nvim_set_hl
-- - positional values starting with '#' are fg
-- - other positional values are links
local function set_highlight(group, setting)
    local hl = {}
    for key, value in pairs(setting) do
        if type(key) == 'number' then
            if vim.startswith(value, '#') then
                hl.fg = value
            else
                vim.api.nvim_set_hl(0, value, { link = group })
            end
        else
            hl[key] = value
        end
    end

    vim.api.nvim_set_hl(0, group, hl)
end

local function set_highlights(settings)
    vim.cmd('hi clear')
    for group, setting in pairs(settings) do
        if type(setting) == 'string' then
            -- Need to provide `fg` key because some colors don't start with "#"
            setting = { fg = setting }
        end

        set_highlight(group, setting)
    end
end

return set_highlights
