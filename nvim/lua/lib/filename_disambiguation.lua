-- This code is written by Claude based on the tests.

local M = {}

-- Split a path into components
local function split_path(path)
    local components = {}
    for part in path:gmatch('[^/]+') do
        table.insert(components, part)
    end
    return components
end

-- Find the length of the common prefix among split paths
local function common_prefix_length(split_paths)
    if #split_paths == 0 then
        return 0
    end

    local min_len = #split_paths[1]
    for _, sp in ipairs(split_paths) do
        if #sp < min_len then
            min_len = #sp
        end
    end

    local prefix_len = 0
    for i = 1, min_len do
        local val = split_paths[1][i]
        local all_same = true
        for j = 2, #split_paths do
            if split_paths[j][i] ~= val then
                all_same = false
                break
            end
        end
        if all_same then
            prefix_len = i
        else
            break
        end
    end

    return prefix_len
end

function M.disambiguate_filenames(paths)
    local result = {}

    if not paths then
        return result
    end

    -- Group paths by basename
    local by_basename = {}
    for idx, path in pairs(paths) do
        local basename = path:match('([^/]+)$') or path
        by_basename[basename] = by_basename[basename] or {}
        table.insert(by_basename[basename], { idx = idx, path = path, basename = basename })
    end

    for basename, group in pairs(by_basename) do
        if #group == 1 then
            -- Unique basename, just use it
            result[group[1].idx] = basename
        else
            -- Split paths and find common prefix
            local split_paths = {}
            for i, item in ipairs(group) do
                item.components = split_path(item.path)
                split_paths[i] = item.components
            end

            local prefix_len = common_prefix_length(split_paths)

            -- Compute suffix for each path (components after common prefix)
            for _, item in ipairs(group) do
                item.suffix = {}
                for k = prefix_len + 1, #item.components do
                    table.insert(item.suffix, item.components[k])
                end
            end

            -- For each path, determine which directory levels are necessary for disambiguation
            -- Level 1 = immediate parent, Level 2 = grandparent, etc.
            for i, item in ipairs(group) do
                item.necessary = {}

                for j, other in ipairs(group) do
                    if i ~= j then
                        -- Find the highest level where paths first differ
                        local max_depth = math.max(#item.suffix, #other.suffix) - 1

                        for level = max_depth, 1, -1 do
                            local my_idx = #item.suffix - level
                            local their_idx = #other.suffix - level

                            local my_comp = my_idx >= 1 and item.suffix[my_idx] or nil
                            local their_comp = their_idx >= 1 and other.suffix[their_idx] or nil

                            if my_comp ~= their_comp then
                                item.necessary[level] = true
                                break
                            end
                        end
                    end
                end
            end

            -- Build display names
            for _, item in ipairs(group) do
                local max_necessary = 0
                for level in pairs(item.necessary) do
                    if level > max_necessary then
                        max_necessary = level
                    end
                end

                if max_necessary == 0 then
                    result[item.idx] = basename
                else
                    local parts = {}
                    local prev_level = max_necessary + 1

                    for level = max_necessary, 1, -1 do
                        local comp_idx = #item.suffix - level
                        if comp_idx >= 1 and item.necessary[level] then
                            if prev_level - level > 1 then
                                table.insert(parts, '-')
                            end
                            table.insert(parts, item.suffix[comp_idx])
                            prev_level = level
                        end
                    end

                    -- Only add abbreviation marker if we actually added some directory components
                    -- and there are skipped levels before filename
                    if #parts > 0 and prev_level > 1 then
                        table.insert(parts, '-')
                    end

                    table.insert(parts, basename)
                    result[item.idx] = table.concat(parts, '/')
                end
            end
        end
    end

    return result
end

return M
