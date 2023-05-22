local plug_address = "marko-cerovac/material.nvim"
local lualine_style = 'stealth'
local scheme_util = require('v3rganz.plugins.util.colorschemes')

local M = {}

function M.factory(style)
    local CS = scheme_util.get_initial_table(plug_address, 'material')
    function CS.config()
        vim.g.material_style = style
        require('material').setup({
            lualine_style = lualine_style
        })
        scheme_util.setup_colorscheme(CS.name)
    end

    return CS
end

return M
