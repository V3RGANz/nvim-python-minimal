local M = {
    "neovim/nvim-lspconfig",
    lazy = true,
    dependencies = {
       "hrsh7th/cmp-nvim-lsp",
    }
}

function M.config()
    local config = {
        virtual_text = true,
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

    local lspconfig = require("lspconfig")
    local configs = require('lspconfig.configs')

    -- install custom server which is not come from lspinstall
    if not configs.llm_lsp then
        configs.llm_lsp = {
            default_config = {
                cmd = {'/Users/Evgeny.Dedov/development/rust/llm-lsp/target/release/llm-lsp'},
                -- just add bunch of acceptable filetypes
                filetypes = {"rust", "python", "lua", "javascript", "typescript", "sh", "cpp", "c", "go"},
                root_dir = function(fname)
                   return lspconfig.util.find_git_ancestor(fname)
               end
                -- capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
            },
        }
    end
    lspconfig.llm_lsp.setup{
        handlers = {
            ["workspace/executeCommand"] = function (err, result, ctx, cfg)
                if err ~= nil then
                    vim.notify("Error executing command: " .. err.message, vim.log.levels.ERROR)
                    return
                end
                if result.command == 'llm-lsp.explainCodeChunk' then
                    local explanation = result.arguments[1]
                    if #explanation == 0 then
                        vim.notify("Nothing to show in explanation window", vim.log.levels.WARN)
                        return
                    end
                    vim.notify("Showing explanation window", vim.log.levels.INFO)
                    local lines = vim.split(explanation, '\n')
                    local max_width = math.min(40, vim.api.nvim_win_get_width(0))
                    vim.notify("Max width: " .. max_width, vim.log.levels.INFO)
                    local opts = {
                        wrap = true,
                        max_width = max_width,
                    }
                    vim.lsp.util.open_floating_preview(lines, "markdown", opts)
                else
                    vim.lsp.handlers["workspace/executeCommand"](err, result, ctx, cfg)
                end
            end,
        },
    }
end

return M
