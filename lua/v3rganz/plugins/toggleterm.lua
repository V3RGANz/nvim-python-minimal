local M = {
    'akinsho/toggleterm.nvim',
    event = "VeryLazy"
}

M.terminals = {}

function M.config()
    require('toggleterm').setup {
        size = 30,
        open_mapping = [[<c-\>]],
    }
    local Terminal = require("toggleterm.terminal").Terminal
    M.terminals.lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = 'float'})
    M.terminals.python = Terminal:new({ cmd = 'python', hidden = true, direction = 'float'})
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

return M
