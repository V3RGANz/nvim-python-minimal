local M = {
    'nvim-lualine/lualine.nvim',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
        event = "VeryLazy"
    },
    event = {
        "VimEnter",
        "InsertEnter",
        "BufReadPre",
        "BufAdd",
        "BufNew",
        "BufReadPost"
    }
}

function M.config()
    local config = {
        sections = {
            lualine_a = {'mode'},
            lualine_b = {
                {'branch', icon = ''},
                'diff',
                {
                    'diagnostics',
                    symbols = {
                        error = 'E',
                        warn = 'W',
                        info = 'I',
                        hint = 'H'
                    },
                    colored = true
                },
                {
                    require("v3rganz.plugin_utils.lualine").lsp_bar,
                    icon = ' LSP:',
                    -- color = { fg = '#ffffff', gui = 'bold' },
                },
            },
            lualine_c = {'filename'},
            lualine_x = {},
            lualine_y = {'progress'},
            lualine_z = {'location'}
        }
    }
    require('lualine').setup(config)
end

return M
