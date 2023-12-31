local M = {
    "neovim/nvim-lspconfig",
    lazy = true,
    dependencies = {
       "hrsh7th/cmp-nvim-lsp",
    }
}

function M.config()
    local config = {
        virtual_text = true,
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
    }
    vim.diagnostic.config(config)

    -- install custom server which is not come from lspinstall
    require("v3rganz.plugins.util.llm_lsp").setup()
end

return M
