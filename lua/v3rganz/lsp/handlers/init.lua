local M = {}

M.setup = function()
    local config = {
        virtual_text = false,
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
    }
    vim.diagnostic.config(config)
end

local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_ok then
    vim.notify('lspconfig failed to load')
    return
end
-- local function parent_dir()
--    local str = debug.getinfo(2, "S").source:sub(2)
--    return str:match("(.*/)") or "./"
-- end

-- local pyright_config_path = parent_dir() .. 'pyrightconfig.json'

local function lsp_highlight_document(client)
  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.documentHighlight then
    vim.api.nvim_exec(
      [[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]],
      false
    )
  end
end

-- should not be modified, reused in all servers
local opts = {
    on_attach = function(clinet, bufnr)
        require('v3rganz.keymaps').lsp_keymaps(bufnr)
        lsp_highlight_document(clinet)
    end
}

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if status_ok then
    opts.capabilities = cmp_nvim_lsp.default_capabilities()
end

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
