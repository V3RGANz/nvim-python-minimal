local plug_address = "marko-cerovac/material.nvim"
local scheme_util = require('v3rganz.plugin_utils.colorschemes')

local M = {}

function M.factory(style)
    local CS = scheme_util.get_initial_table(plug_address, 'material')
    function CS.config()
        vim.g.material_style = style
        scheme_util.setup_colorscheme(CS.name)
    end

    return CS
end

return M
