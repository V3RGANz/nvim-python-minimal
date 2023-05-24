local M = {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    dependencies = { "telescope-fzf-native.nvim" },
    cmd = "Telescope",
}

M.opts = {
    defaults = {
        layout_strategy = "horizontal",
        layout_config = {
            horizontal = {
                prompt_position = "top",
                preview_width = 0.55,
                results_width = 0.8,
            },
            width = 0.99,
            preview_cutoff = 120,
        },
        file_ignore_patterns = { "node_modules", ".git", "bazel-*" },
        -- borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
        borders = false,
        path_display = { "truncate" },
    }
}

return M
