local plug_address = "folke/tokyonight.nvim"
local scheme_util = require('v3rganz.plugins.util.colorschemes')

local M = {}

function M.factory(style)
    style = style or "night"
    local CS = scheme_util.get_initial_table(plug_address, "tokyonight")
    function CS.config()
        local tokyonight = require("tokyonight")
        tokyonight.setup({
            style = style,
            transparent = false,
            terminal_colors = true,
            day_brightness = 0.1,
        })
	scheme_util.setup_colorscheme(CS.name)
    end
    return CS
end

return M
