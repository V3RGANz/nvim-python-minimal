local M = {
    "hrsh7th/nvim-cmp",
    dependencies = {
        {"hrsh7th/cmp-nvim-lsp"},
        {"hrsh7th/cmp-buffer"},
        {"hrsh7th/cmp-path"},
        {"hrsh7th/cmp-cmdline"},
        {"saadparwaiz1/cmp_luasnip"},

        -- snippets
        {
            "L3MON4D3/LuaSnip",
            commit = "8f8d493e7836f2697df878ef9c128337cbf2bb84",
            event = "InsertEnter",
            dependencies = {
                "rafamadriz/friendly-snippets"
            }
        },
        {"hrsh7th/cmp-nvim-lua"},

        -- copilot 
        {
            "zbirenbaum/copilot-cmp",
            dependencies = {
                "zbirenbaum/copilot.lua",
                cmd = "Copilot",
                enabled = true, -- disable it by default
                event = "BufReadPost",
                config = function()
                    require("copilot").setup({
                        filetypes = {
                            markdown = true,
                        }
                    })
                end
                },
            config = function ()
                require('copilot_cmp').setup()
            end,
            event = "BufReadPost"
        }
    },
    event = {
        "InsertEnter",
        "CmdlineEnter"
    }
}

function M.config()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    -- TODO figure out wtf is this
    require("luasnip/loaders/from_vscode").lazy_load()

    local disallowed_paths = {'*/bazel-*/*', '*/venv/*', '*/.venv/*'}

    local function get_referenced_item_path(completion_item)
        local path = nil
        if completion_item.labelDetails then
          if completion_item.labelDetails.description then
            path = completion_item.labelDetails.description
          end
        end
        return path
    end

    local util = require('v3rganz.util')

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = require("v3rganz.keymaps").cmp_keymaps(cmp, luasnip),
      sources = {
        { name = "otter" },
        { name = "copilot" },
        {
            name = "nvim_lsp",
            entry_filter = function (entry, ctx)
                local path = get_referenced_item_path(entry.completion_item)
                if path ~= nil then
                    if util.match_path(disallowed_paths, path) then
                        return false
                    end
                end
                return true
            end
        },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
        { name = "spell" }
      }
    })
end

return M
