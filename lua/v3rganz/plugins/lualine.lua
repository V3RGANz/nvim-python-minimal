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

local available_separators = {
    bubbles = {
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' }
    },
    powerline = {
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
    }
}

function M.config()
    local separators = available_separators.bubbles
    local config = {
        options = {
            section_separators = separators.section_separators,
            component_separators = separators.component_separators
        },
        sections = {
            lualine_a = {
                {
                    'mode',
                    -- separator only for bubbles
                    separator = {left = separators.section_separators.right},
                }
            },
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
                    require("v3rganz.plugins.util.lualine").lsp_bar,
                    icon = ' LSP:',
                    -- color = { fg = '#ffffff', gui = 'bold' },
                },
            },
            lualine_c = {'filename'},
            lualine_x = {},
            lualine_y = {'progress'},
            lualine_z = {{
                'location',
                separator = {right = separators.section_separators.left},
            }}
        }
    }
    require('lualine').setup(config)
end

return M
