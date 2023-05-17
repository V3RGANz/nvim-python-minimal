-- not load them, just list good stuff here
local schemes = {
    "catppuccin/nvim",
    "ellisonleao/gruvbox.nvim",
    "folke/tokyonight.nvim",
    "rebelot/kanagawa.nvim",
}

local use_block_style_telescope_ui = false

local M = {
    "rebelot/kanagawa.nvim",
    name = "kanagawa-dragon",
    lazy = false,
    priority = 1000
}

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

function M.config()
    if require('v3rganz.util').str_startswith(M.name, 'kanagawa') and use_block_style_telescope_ui then
        pcall(block_style_ui_telescope)
    end

    local status_ok, _ = pcall(vim.cmd.colorscheme, M.name)
    if not status_ok then
        vim.notify("colorscheme " .. M.name .. " not loaded")
        return
    end
end

return M
