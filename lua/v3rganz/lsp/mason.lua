local status_ok, mason = pcall(require, "mason")
if not status_ok then
    vim.notify("mason plugin failed to load")
	return
end

local status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_ok then
    vim.notify("mason-lspconfig plugin failed to load")
    return
end

local servers = { "jsonls", "lua_ls", "pyright" }

local mason_settings = {
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    },
}

mason.setup(mason_settings)

mason_lspconfig.setup({
	ensure_installed = servers,
    automatic_installation = true,
    handlers = require('v3rganz.lsp.mason-handlers').handlers
})

