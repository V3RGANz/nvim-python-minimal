local M = {}
local lspconfig = require("lspconfig")
local function parent_dir()
   local str = debug.getinfo(2, "S").source:sub(2)
   return str:match("(.*/)") or "./"
end

local pyright_config_path = parent_dir() .. 'pyrightconfig.json'

M.handlers = {
    function (server_name)
        lspconfig[server_name].setup{}
    end,
    -- ['pyright'] = function ()
    --     lspconfig.pyright.setup {
    --         root_dir = function (filename, bufnr)
    --             if string.find(filename, "build-") then
    --                 return nil
    --             end
    --             return require("lspconfig.server_configurations.pyright").default_config.root_dir(filename, bufnr)
    --         end
    --         -- cmd = { 'pyright-langserver', '--stdio', '-p ' .. pyright_config_path}
    --     }
    -- end
}

return M
