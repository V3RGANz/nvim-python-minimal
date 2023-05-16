local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
    vim.notify('lualine plugin failed to load')
end


local config = {
    sections = {
        lualine_a = {'mode'},
        lualine_b = {
            {'branch', icon = ''},
            'diff',
            {
                'diagnostics',
                symbols = {
                    error = 'E',
                    warn = 'W',
                    info = 'I',
                    hint = 'H'
                },
                colored = true
            },
            {
                -- modified version of lualine.examples.evilline
                -- Lsp server name .
                function()
                    local client_names = {}
                    local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
                    local clients = vim.lsp.get_active_clients()
                    if next(clients) == nil then
                        return 'No Active Lsp'
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
                    return '[' .. msg .. ']'
                end,
                icon = ' LSP:',
                -- color = { fg = '#ffffff', gui = 'bold' },
            },
        },
        lualine_c = {'filename'},
        lualine_x = {},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    }
}

lualine.setup(config)
