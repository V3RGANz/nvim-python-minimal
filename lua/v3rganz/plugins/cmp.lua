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
        {"hrsh7th/cmp-nvim-lua"}
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

    local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

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
      mapping = cmp.mapping.preset.insert({
        ['<C-j'] = cmp.mapping.select_next_item(),
        ['<C-k>'] = cmp.mapping.select_prev_item(),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        -- ['<C-y>'] = cmp.config.disable,
        ['<C-e>'] = cmp.mapping {
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        },

        -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items. }),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),

        -- SuperTab taken from:
        -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable() 
          -- they way you will only jump inside the snippet region
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = {
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
      }
    })
end

return M
