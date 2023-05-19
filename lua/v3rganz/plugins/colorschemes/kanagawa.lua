local plug_address = "rebelot/kanagawa.nvim"
local use_block_style_telescope_ui = false

local function block_style_ui_telescope()
    require('kanagawa').setup({
        overrides = function (colors)
            local theme = colors.theme
            return {
                TelescopeTitle = { fg = theme.ui.special, bold = true },
                TelescopePromptNormal = { bg = theme.ui.bg_p1 },
                TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
                TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
                TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
                TelescopePreviewNormal = { bg = theme.ui.bg_dim },
                TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
                Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },  -- add `blend = vim.o.pumblend` to enable transparency
                PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
                PmenuSbar = { bg = theme.ui.bg_m1 },
                PmenuThumb = { bg = theme.ui.bg_p2 },
            }
        end
    })
end
local scheme_util = require('v3rganz.plugin_utils.colorschemes')

local M = {}

function M.factory(style)
    local CS = scheme_util.get_initial_table(plug_address, style)
    function CS.config()
        if use_block_style_telescope_ui then
            pcall(block_style_ui_telescope)
        end
        scheme_util.setup_colorscheme(CS.name)
    end
    return CS
end

return M
