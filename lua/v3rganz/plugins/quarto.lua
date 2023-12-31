local M = {
    "quarto-dev/quarto-nvim",
    event = {"VeryLazy", "BufRead"},
    dev = false,
    dependencies = {
        {
            "jmbuhr/otter.nvim",
            dev = false,
            dependencies = {
                {"neovim/nvim-lspconfig"}
            },
            opts = {
                buffers = {
                    set_filetype = true,
                }
            }
        }
    }
}

M.opts = {
    lspFeatures = {
        enabled = true,
        languages = { 'python', 'bash' },
        codeRunner = {
            enabled = true,
            default_method = 'molten'
        },
        diagnostics = {
            enabled = true,
            triggers = { 'BufWrite' }
        },
        completion = { enabled = true },
    }
}

return M
