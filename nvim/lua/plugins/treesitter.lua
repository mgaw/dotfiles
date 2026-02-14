return {
    'https://github.com/nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    config = function()
        local nvim_treesitter = require('nvim-treesitter')

        vim.treesitter.language.register('scss', 'less')
        vim.treesitter.language.register('bash', 'zsh')

        -- Explicitly install parsers that are typically only injected
        nvim_treesitter.install({
            'comment',
            'promql',
            'diff',
        })

        local disable_treesitter = {
            'gitcommit', -- doesn't highlight diff
            'git_rebase', -- could avoid this one by defining the highlight groups
            'csv',
        }

        vim.api.nvim_create_autocmd('FileType', {
            pattern = '*',
            callback = function(args)
                local bufnr = args.buf
                local lang = vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)

                if vim.tbl_contains(disable_treesitter, lang) then
                    return
                end

                if vim.tbl_contains(nvim_treesitter.get_installed(), lang) then
                    vim.treesitter.start(bufnr, lang)
                    -- Force synchronous parsing on initial file load to avoid flashing on large file
                    vim.treesitter.get_parser(bufnr, lang):parse(true)
                    return
                end

                if vim.tbl_contains(nvim_treesitter.get_available(), lang) then
                    nvim_treesitter.install({ lang }):await(function()
                        vim.treesitter.start(bufnr, lang)
                    end)
                end
            end,
        })
    end,
}
