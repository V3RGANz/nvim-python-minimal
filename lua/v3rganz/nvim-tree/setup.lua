local status_ok, tree = pcall(require, "nvim-tree")
if not status_ok then
    return
end


local function key_mappings_on_attach(bufnr)
    local api = require('nvim-tree.api')
    local function opts(desc)
        return {
            desc = 'nvim-tree: ' .. desc,
            buffer = bufnr,
            noremap = true,
            silent = true,
            nowait = true
        }
    end
    api.config.mappings.default_on_attach(bufnr)
    vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
    vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close node'))
    vim.keymap.set('n', 'v', api.node.open.vertical, opts('Open: Vertical split'))
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
    on_attach = key_mappings_on_attach,
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
