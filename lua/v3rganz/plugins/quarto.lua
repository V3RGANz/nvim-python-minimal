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
        diagnostics = {
            enabled = true,
            triggers = { 'BufWrite' }
        },
        completion = { enabled = true },
    },
    codeRunner = {
        enabled = true,
        default_method = 'molten',
    },
}

function M.config()
    local status_ok, quarto = pcall(require, "quarto")
    if not status_ok then return end
    quarto.setup(M.opts)
    require("v3rganz.keymaps").quarto_keymaps()
end

return M
