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

local function get_current_buffer_filename()
    local bufname = vim.api.nvim_buf_get_name(0)
    return bufname ~= '' and vim.fn.fnamemodify(bufname, ':.') or ''
end

function M.config()
    local separators = available_separators.bubbles
    local config = {
        options = {
            section_separators = separators.section_separators,
            component_separators = { left = " ", right = " " },
        },
        sections = {
            lualine_a = {
                {
                    'mode',
                    -- separator only for bubbles
                    separator = {left = separators.section_separators.right, right = separators.section_separators.left},
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
                    icon = '',
                    -- color = { fg = '#ffffff', gui = 'bold' },
                },
            },
            lualine_c = {get_current_buffer_filename},
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
