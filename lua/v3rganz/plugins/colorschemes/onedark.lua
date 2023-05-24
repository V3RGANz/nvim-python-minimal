local plug_address = "navarasu/onedark.nvim"
local scheme_util = require('v3rganz.plugins.util.colorschemes')

local M = {}

function M.factory(style)
    local CS = scheme_util.get_initial_table(plug_address, "onedark")
    function CS.config()
        local onedark = require("onedark")
        if style == "light" then
            vim.o.background = "light"
        end
        onedark.setup({
            style = style,
            term_colors = false,
        })
        onedark.load()
    end

    return CS
end

return M
