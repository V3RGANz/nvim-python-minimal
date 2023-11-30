local M = {
    terminals = {}
}

-- open floating window with daily note + append current timestamp
-- thx to https://www.youtube.com/watch?v=zB_3FIGRWRU&t=280s
-- TODO: rewrite as native neovim floating window
local obsidian_daily_cmd = require('v3rganz.util').str_join({
    'nvim',
    'ObsidianToday',
    '"norm Go"',
    '"norm Go## $(date +%H:%M)"',
    '"norm G2o"',
    '"norm zz"',
    'startinsert'
}, ' -c ')

function M.setup()
    local Terminal = require("toggleterm.terminal").Terminal
    M.terminals.lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = 'float'})
    M.terminals.python = Terminal:new({ cmd = 'python3', hidden = true, direction = 'float'})
    M.terminals.obsidian_daily = Terminal:new({ cmd = obsidian_daily_cmd, hidden = true, direction = 'float'})
end

M.lazygit = function ()
    if M.terminals.lazygit == nil then
        vim.notify('lazygit terminal not loaded')
        return
    end
    M.terminals.lazygit:toggle()
end

M.python = function ()
    if M.terminals.python == nil then
        vim.notify('python terminal not loaded')
        return
    end
    M.terminals.python:toggle()
end

M.obsidian_daily = function ()
    if M.terminals.obsidian_daily == nil then
        vim.notify('obsidian_daily terminal not loaded')
        return
    end
    M.terminals.obsidian_daily:toggle()
end

return M
