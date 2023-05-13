local M = {}
local lspconfig = require("lspconfig")
-- local function parent_dir()
--    local str = debug.getinfo(2, "S").source:sub(2)
--    return str:match("(.*/)") or "./"
-- end

-- local pyright_config_path = parent_dir() .. 'pyrightconfig.json'

local opts = {  -- should not be modified, reused in all servers
    on_attach = require("v3rganz.lsp.handlers").on_attach,
    capabilities = require("v3rganz.lsp.handlers").capabilities,
}

-- add custom settings for language-servers
M.handlers = {
    function (server_name)
        lspconfig[server_name].setup(opts)
    end,
    -- ['pyright'] = function ()
    --     vim.notify('custom opts for pyright')
    --     local server_opts = {
    --         root_dir = function (filename, bufnr)
    --             if string.find(filename, "build-") then
    --                 return nil
    --             end
    --             return require("lspconfig.server_configurations.pyright").default_config.root_dir(filename, bufnr)
    --         end
    --         -- cmd = { 'pyright-langserver', '--stdio', '-p ' .. pyright_config_path}
    --     }
    --     server_opts = vim.tbl_deep_extend("force", opts, server_opts)
    --
    --     lspconfig.pyright.setup(server_opts)
    -- end
}

return M
