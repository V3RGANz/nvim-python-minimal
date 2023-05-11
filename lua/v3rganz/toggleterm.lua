local M = {}
local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
    return M
end

toggleterm.setup({
    size = 30,
    open_mapping = [[<c-\>]],
})

local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = 'float'})
local python = Terminal:new({ cmd = 'python', hidden = true, direction = 'float'})

M.lazygit = function ()
    lazygit:toggle()
end

M.python = function ()
    python:toggle()
end

return M
