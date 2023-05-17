local M = {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost"
}

M.opts = {
    current_line_blame = true,
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',
        delay = 0
    },
    current_line_blame_formatter = '<committer> <committer_time> - <summary>'
}

return M
