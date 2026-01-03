-- https://github.com/LuaLS/lua-language-server
return {
    settings = {
        -- https://github.com/LuaLS/lua-language-server/blob/master/script/config/template.lua
        Lua = {
            telemetry = { enable = false },
            completion = {
                -- The friendly-snippets snippets are better.
                keywordSnippet = 'Disable',

                -- Don't include parameters when completing function names
                --
                -- * It's annoying for optional parameters
                -- * It messes with yank registers
                callSnippet = 'Disable',
            },
            format = {
                -- Formatting should be handled by stylua.
                enable = false,
            },
        },
    },
}
