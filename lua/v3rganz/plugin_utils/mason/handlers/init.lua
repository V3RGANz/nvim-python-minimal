local M = {}

-- local function parent_dir()
--    local str = debug.getinfo(2, "S").source:sub(2)
--    return str:match("(.*/)") or "./"
-- end

-- local pyright_config_path = parent_dir() .. 'pyrightconfig.json'

local function get_base_opts()
    local opts = {
        on_attach = function(clinet, bufnr)
            require('v3rganz.keymaps').lsp_keymaps(bufnr)
            local illuminate_ok, illuminate = pcall(require, 'illuminate')
            if illuminate_ok then
                illuminate.on_attach(clinet)
            end
        end
    }

    local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if status_ok then
        opts.capabilities = cmp_nvim_lsp.default_capabilities()
    end
    return opts
end

-- add custom settings for language-servers
M.handlers = {
    function (server_name)
        require("lspconfig")[server_name].setup(get_base_opts())
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
    ['lua_ls'] = function ()
        local server_opts = {
            settings = {
                Lua = {
                    diagnostics = {
                        globals = {'vim'}
                    },
                    workspace = {
                        library = {
                            -- vim.api.nvim_get_runtime_file("", true)
                            [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                            [vim.fn.stdpath('config') .. '/lua'] = true
                        }
                    }
                }
            }
        }
        server_opts = vim.tbl_deep_extend('force', get_base_opts(), server_opts)
        require("lspconfig").lua_ls.setup(server_opts)
    end
}

return M
