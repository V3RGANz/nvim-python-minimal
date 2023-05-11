local status_ok, ts_config = pcall(require, "nvim-treesitter.configs")
if not status_ok then
    vim.notify("treesitter plugin failed to load")
end

ts_config.setup {
    ensure_installed = {"python", "lua", "c", "vim", "javascript", "typescript"},
    highlight = {
        enable = true
    }
}
