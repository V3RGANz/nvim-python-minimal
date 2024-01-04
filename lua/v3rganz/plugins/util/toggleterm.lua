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

local function markdown_codeblock(language, content)
    return '\\`\\`\\`{' .. language .. '}\n' .. content .. '\n\\`\\`\\`'
end

local quarto_notebook_cmd = require('v3rganz.util').str_join({
    'nvim',
    'enew',
    '"set filetype=quarto"',
    '"norm GO## IPython\nThis is Quarto IPython notebook. Syntax is the same as in markdown\n\n' .. markdown_codeblock('python', '# enter code here\n') .. '"',
    '"norm Gkk"',

    -- This line needed because QuartoActivate and MoltenInit commands must be accessible; should be adjusted depending on plugin manager
    "\"lua require('lazy.core.loader').load({'molten-nvim', 'quarto-nvim'}, {cmd = 'Lazy load'})\"",
    '"MoltenInit python3"',
    'QuartoActivate',

    'startinsert'
}, ' -c ')

---setup toggleterm
---@param opts {use_quarto: boolean}
function M.setup(opts)
    local python_cmd = 'python3'
    if opts.use_quarto then
        python_cmd = quarto_notebook_cmd
    end
    -- print(python_cmd)

    local Terminal = require("toggleterm.terminal").Terminal
    M.terminals.lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = 'float'})
    M.terminals.python = Terminal:new({ cmd = python_cmd, hidden = true, direction = 'float'})
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
