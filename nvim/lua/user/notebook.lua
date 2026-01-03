local M = {}

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'quarto',
    callback = function()
        -- reset https://github.com/neovim/neovim/blob/2276743cb8e134/runtime/ftplugin/rmd.vim#L24
        vim.cmd('setlocal iskeyword<')
    end,
})

local function get_kernel_name()
    return vim.api.nvim_buf_get_name(0):gsub('/', '_'):gsub('^_', '')
end

local function ensure_kernel(kernel_name)
    -- Kernels are installed in ~/Library/Jupyter/kernels
    vim.fn.system('python -m ipykernel install --user --name ' .. vim.fn.shellescape(kernel_name))
end

function M.run_all_cells()
    if require('molten.status').initialized() == '' then
        vim.api.nvim_create_autocmd('User', {
            pattern = 'MoltenKernelReady',
            once = true,
            callback = function()
                vim.cmd('QuartoSendAll')
            end,
        })

        local kernel_name = get_kernel_name()
        ensure_kernel(kernel_name)
        vim.cmd('MoltenInit ' .. kernel_name)
    else
        vim.cmd('QuartoSendAll')
    end
end

return {
    -- Allow sending code to juypter kernel, and display results
    --
    -- Run `quarto preview file.qmd` to render notebook in browser
    {
        'https://github.com/benlubas/molten-nvim',
        version = '^1.0.0',
        -- Plugin needs to be loaded for UpdateRemotePlugins to work
        build = ':UpdateRemotePlugins',
        ft = 'quarto',
        init = function()
            vim.g.molten_auto_open_output = false
            vim.g.molten_virt_text_output = true
            vim.g.molten_auto_open_html_in_browser = true
            vim.g.molten_enter_output_behavior = 'open_and_enter'
            vim.g.molten_virt_text_max_lines = 50
            vim.g.molten_image_provider = 'image.nvim'

            -- Don't highlight text in current cell
            vim.api.nvim_set_hl(0, 'MoltenCell', {})
        end,
    },

    -- Render inline images
    {
        'https://github.com/3rd/image.nvim',
        ft = 'quarto',
        opts = {
            backend = 'kitty',
            max_height_window_percentage = 80,
        },
    },

    -- Automatically define "cell"
    -- Via otter, make code in cells available to language servers
    {
        'https://github.com/quarto-dev/quarto-nvim',
        ft = 'quarto',
        dependencies = {
            'https://github.com/jmbuhr/otter.nvim',
            'https://github.com/nvim-treesitter/nvim-treesitter',
        },
        opts = {
            codeRunner = {
                default_method = 'molten',
            },
        },
    },
    M = M,
}
