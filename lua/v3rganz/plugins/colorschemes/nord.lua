local scheme_util = require('v3rganz.plugins.util.colorschemes')
local plug_address = 'shaunsingh/nord.nvim'

local M = {}

function M.factory()
    local CS = scheme_util.get_initial_table(plug_address, 'nord')
    function CS.config()
        scheme_util.setup_colorscheme(CS.name)
    end
    return CS
end

return M
