local M = {
    "terrortylor/nvim-comment",
    event = "BufReadPre"
}

M.opts = {
    operator_mapping = "<leader>/"
}

function M.config()
    require("nvim_comment").setup(M.opts)
end

return M
