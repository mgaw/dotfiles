return {
    -- Breaking changes: https://github.com/hrsh7th/nvim-cmp/issues/231
    'https://github.com/hrsh7th/nvim-cmp',
    dependencies = {
        'https://github.com/hrsh7th/cmp-nvim-lsp',
        'https://github.com/hrsh7th/cmp-nvim-lsp-signature-help',
        'https://github.com/hrsh7th/cmp-path',
        {
            'https://github.com/saadparwaiz1/cmp_luasnip',
            dependencies = {
                'https://github.com/L3MON4D3/LuaSnip',
            },
        },
    },
    event = 'InsertEnter',
    config = function()
        local cmp = require('cmp')
        local luasnip = require('luasnip')
        cmp.setup({
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'nvim_lsp_signature_help' },
                { name = 'path' },
                { name = 'luasnip' },
            }),

            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },

            -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings
            mapping = {
                ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
                ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),

                ['<CR>'] = function(fallback)
                    -- Only confirm when an entry was manually selected, as often I just want to get a line
                    -- break even when the completion menu still has other ideas. This happens less often
                    -- since disabling completion in comments but still.
                    if cmp.visible() and cmp.get_selected_entry() then
                        cmp.confirm()
                    else
                        fallback()
                    end
                end,

                ['<C-e>'] = function(fallback)
                    -- Confirm only if cursor is at end of line, i.e. when ghost text is there.
                    if cmp.visible() and vim.fn.col('.') == vim.fn.col('$') then
                        cmp.confirm({ select = true })
                    else
                        fallback()
                    end
                end,

                ['<Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.confirm({ select = true })
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { 'i', 's' }),

                ['<S-Tab>'] = cmp.mapping(function()
                    if luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    end
                end, { 'i', 's' }),
            },

            enabled = function()
                if vim.api.nvim_get_mode().mode == 'c' then
                    -- keep command mode completion enabled when cursor is in a comment
                    return true
                end
                return not require('cmp.config.context').in_treesitter_capture('comment')
                    and not require('cmp.config.context').in_syntax_group('Comment')
            end,

            experimental = {
                -- This is nice as a preview, and also to make it clear that it's possible
                -- to complete the first item by <Tab> even without selecting it first.
                ghost_text = true,
            },
        })
    end,
}
