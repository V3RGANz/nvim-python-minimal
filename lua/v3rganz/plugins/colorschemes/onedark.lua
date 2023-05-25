local plug_address = "navarasu/onedark.nvim"
local scheme_util = require('v3rganz.plugins.util.colorschemes')

local M = {}

function M.factory(style)
    style = style or "dark"
    local CS = scheme_util.get_initial_table(plug_address, "onedark")
    function CS.config()
        local onedark = require("onedark")
        if style == "light" then
            -- onedark depends on this for determining colors (which is probably derived from terminal)
            -- so we have to explicitly set it
            vim.o.background = "light"
        else
            vim.o.background = "dark"
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
