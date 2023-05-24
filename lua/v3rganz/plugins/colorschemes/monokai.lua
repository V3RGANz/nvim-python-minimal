local plug_address = "loctvl842/monokai-pro.nvim"
local scheme_util = require('v3rganz.plugins.util.colorschemes')

local M = {}

function M.factory(style)
    style = style or "pro"
    local CS = scheme_util.get_initial_table(plug_address, "monokai-pro")
    function CS.config()
        require('monokai-pro').setup({
            filter = style,
        })
        scheme_util.setup_colorscheme(CS.name)
        scheme_util.setup_nvimtree_colors()
    end

    return CS
end

return M
