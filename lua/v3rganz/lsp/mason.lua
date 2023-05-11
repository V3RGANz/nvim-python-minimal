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
    }
}

mason.setup(mason_settings)

mason_lspconfig.setup({
	ensure_installed = servers,
    automatic_installation = true
})

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
	return
end

for _, server in pairs(servers) do
	local opts = {
		on_attach = require("v3rganz.lsp.handlers").on_attach,
		capabilities = require("v3rganz.lsp.handlers").capabilities,
	}
	local has_custom_opts, server_custom_opts = pcall(require, "v3rganz.lsp.settings." .. server)
	if has_custom_opts then
		opts = vim.tbl_deep_extend("force", opts, server_custom_opts)
	end
	lspconfig[server].setup(opts)
end

