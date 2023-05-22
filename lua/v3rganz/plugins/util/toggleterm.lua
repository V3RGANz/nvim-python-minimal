local M = {
    terminals = {}
}

function M.setup()
    local Terminal = require("toggleterm.terminal").Terminal
    M.terminals.lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = 'float'})
    M.terminals.python = Terminal:new({ cmd = 'python3', hidden = true, direction = 'float'})
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
