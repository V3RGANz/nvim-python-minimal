local status_ok, tree = pcall(require, "nvim-tree")
if not status_ok then
    return
end

tree.setup {
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
            '.null-ls*'
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
