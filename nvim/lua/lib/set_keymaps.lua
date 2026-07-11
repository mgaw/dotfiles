local function resolve_table_mapping(rhs)
    -- Examples:
    --
    -- { ':%s///g<Left><Left><Left>', silent = false }
    -- { '<Plug>Commentary', noremap = false }
    local opts = {}
    for k, v in pairs(rhs) do
        if k ~= 1 then
            opts[k] = v
        end
    end
    return rhs[1], opts
end

local function set_keymap(mode, lhs, rhs)
    local opts = {}
    if type(rhs) == 'table' then
        rhs, opts = resolve_table_mapping(rhs)
    end

    vim.keymap.set(mode, lhs, rhs, opts)
end

local function is_implicit_normal_mode(rhs)
    if type(rhs) == 'string' or type(rhs) == 'function' then
        return true
    end

    if type(rhs) == 'table' and rhs[1] then
        -- Examples:
        --
        -- { ':%s///g<Left><Left><Left>', silent = false }
        -- { '<Plug>Commentary', noremap = false }
        return true
    end

    return false
end

local function unpack_modes(mode)
    if mode == 'nx' then
        return { 'n', 'x' }
    end
    if mode == 'xo' then
        return { 'x', 'o' }
    end
    return mode
end

local function set_keymaps(mappings)
    for lhs, rhs in pairs(mappings) do
        if is_implicit_normal_mode(rhs) then
            set_keymap('n', lhs, rhs)
        else
            for mode, mode_rhs in pairs(rhs) do
                set_keymap(unpack_modes(mode), lhs, mode_rhs)
            end
        end
    end
end

return set_keymaps
