local M = {
    "williamboman/mason.nvim",
    cmd = "Mason",
    event = "BufReadPre",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        lazy = true
    }
}


local servers = { "jsonls", "lua_ls", "pyright", "tsserver" }

local mason_settings = {
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    },
}

function M.config()
    require("mason").setup(mason_settings)
    require("mason-lspconfig").setup({
        ensure_installed = servers,
        automatic_installation = true,
        handlers = require('v3rganz.plugin_utils.mason.handlers').handlers
    })
end

return M
