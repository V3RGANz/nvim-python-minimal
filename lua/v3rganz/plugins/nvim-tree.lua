local M = {
    "nvim-tree/nvim-tree.lua",
    event = "VimEnter"
}

M.opts = {
    diagnostics = {
        enable = true,
        icons = {
            hint = 'H',
            info = 'I',
            warning = 'W',
            error = 'E',
        }
    },
    update_focused_file = {
        enable = true
    },
    git = {
        enable = true,
        ignore = true,
        timeout = 500
    },
    filters = {
        custom = {
            '\\.null-ls*'
        }
    },
    on_attach = require('v3rganz.keymaps').nvim_tree_keymaps,
    renderer = {
        highlight_git = true,
        icons = {
            show = {
                file = false,
                folder_arrow = false,
                folder = false,
                git = true
            },
            glyphs = {
                git = {
                    unstaged = 'X',
                    staged = 'U',  -- [U]pdated
                    renamed = '>',
                    untracked = '*',
                    deleted = '-',
                    ignored = '.'
                }
            }
        }
    }
}

return M
