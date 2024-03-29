local M = {}

-- modified version of lualine.examples.evilline
-- Lsp server name .
function M.lsp_bar()
    local client_names = {}
    local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then
        return 'no active lsp'
    end
    for _, client in ipairs(clients) do
        local filetypes = client.config.filetypes
        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
            -- handle null-ls sources
            if client.name == 'null-ls' then
                local sources = require("null-ls.sources")
                for _, source in ipairs(sources.get_available(buf_ft)) do
                    table.insert(client_names, source.name)
                end
            else
                table.insert(client_names, client.name)
            end
        end
    end
    local msg = require('v3rganz.util').str_join(client_names, ', ')
    return msg
end

-- python virtual environment name
M.virtualenv_bar = {
    icon = function()
        local venv = vim.env.VIRTUAL_ENV
        if venv ~= nil then
            return '🐍'
        else
            return ''
        end
    end,
    --- @return string
    name = function()
        local venv = vim.env.VIRTUAL_ENV
        if venv ~= nil then
            return venv:match("([^/]+)$")
        else
            return ''
        end
    end,
}

return M
