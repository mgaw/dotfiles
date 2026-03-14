local utils = require('lib.utils')

return {
    'https://github.com/saghen/blink.cmp',
    version = '*',
    opts = {
        keymap = {
            preset = 'super-tab',
            ['<C-n>'] = { 'show_and_insert', 'select_next', 'fallback' },
        },
        completion = {
            list = {
                selection = {
                    preselect = false,
                },
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 0,
            },
            ghost_text = {
                enabled = true,
                show_without_selection = true,
            },
            menu = {
                max_height = 25,
            },
        },
        signature = {
            enabled = true,
        },
        sources = {
            providers = {
                buffer = {
                    should_show_items = function(ctx)
                        return ctx.trigger.kind == 'manual'
                    end,
                },
                lsp = {
                    should_show_items = function()
                        -- Most LSPs anyway don't list items in comments,
                        -- but some do (e.g. taplo)
                        return not utils.cursor_in_comment()
                    end,
                },
            },
        },
    },
}
