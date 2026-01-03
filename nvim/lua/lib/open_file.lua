local utils = require('lib.utils')

local M = {}

local function remove_two_extensions()
    return vim.fn.expand('%:r:r')
end

M.config = {
    python = {
        stemmer = function()
            return vim.fn.expand('%:r'):gsub('_unit_test', ''):gsub('_test', '')
        end,
        main = '.py',
        test = '_test.py',
        other = '_unit_test.py',
    },
    typescript = {
        stemmer = remove_two_extensions,
        main = '.ts',
        test = '.test.ts',
    },
    typescriptreact = {
        stemmer = remove_two_extensions,
        main = '.tsx',
        test = '.test.tsx',
        other = '.less',
    },
    less = {
        stemmer = remove_two_extensions,
        main = '.tsx',
        test = '.test.tsx',
        other = '.less',
    },
    lua = {
        stemmer = function()
            return vim.fn.expand('%:r'):gsub('_spec', '')
        end,
        main = '.lua',
        test = '_spec.lua',
    },
}

local function open_file(kind)
    local config = M.config[vim.o.filetype]
    if not config then
        utils.not_implemented('open_' .. kind .. '_file')
        return
    end
    local suffix = config[kind]
    if not suffix then
        utils.not_implemented('open_' .. kind .. '_file')
        return
    end
    vim.cmd('silent edit ' .. config.stemmer() .. suffix)
end

M.open_main_file = {
    function()
        open_file('main')
    end,
    desc = 'Open main file',
}

M.open_test_file = {
    function()
        open_file('test')
    end,
    desc = 'Open test file',
}

M.open_other_file = {
    function()
        open_file('other')
    end,
    desc = 'Open other file',
}

return M
