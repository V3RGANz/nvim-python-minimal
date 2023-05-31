local plug_address = "rebelot/kanagawa.nvim"
local use_block_style_telescope_ui = false

local function block_style_ui_telescope(colors)
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

local scheme_util = require('v3rganz.plugins.util.colorschemes')

local M = {}

function M.factory(style)
    style = style or "kanagawa-dragon"
    local CS = scheme_util.get_initial_table(plug_address, 'kanagawa')
    function CS.config()
        local config = {
            theme = style,
        }
        if use_block_style_telescope_ui then
            config.overrides = block_style_ui_telescope
        end
        require('kanagawa').setup(config)
        scheme_util.setup_colorscheme(CS.name)
    end
    return CS
end

return M
