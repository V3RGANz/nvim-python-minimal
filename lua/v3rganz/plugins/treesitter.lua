local M = {
    "nvim-treesitter/nvim-treesitter",
    event = "BufReadPost",
}

M.opts = {
    ensure_installed = {"python", "lua", "c", "vim", "javascript", "typescript", "tsx", "markdown", "markdown_inline"},
    highlight = {
        enable = true
    }
}

function M.config()
    local ts_config = require("nvim-treesitter.configs")
    ts_config.setup(M.opts)
end

return M
