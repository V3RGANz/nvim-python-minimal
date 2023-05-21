local M = {
    "terrortylor/nvim-comment",
    event = "BufReadPre"
}

M.opts = {
    operator_mapping = require("v3rganz.keymaps").comment_operator
}

function M.config()
    require("nvim_comment").setup(M.opts)
end

return M
