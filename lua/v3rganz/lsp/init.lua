local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
    vim.notify("lspconfig plugin failed to load")
    return
end

require("v3rganz.lsp.mason")
require("v3rganz.lsp.handlers").setup()
require("v3rganz.lsp.null-ls")
