local opts = {noremap = true, silent = true}
local term_opts = {silent = true}

--alias
local keymap = vim.api.nvim_set_keymap

keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " " -- ? 

-- Normal mode --
-- Window navigation shorter
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- explorer
-- keymap("n", "<leader>e", ":Lex 30<cr>", opts)
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts)

-- splits
keymap("n", "<leader>v", ":vsplit<CR>", opts)
keymap("n", "<leader>h", ":split<CR>", opts)

-- resize 'panes' with arrows
keymap("n", "<S-M-k>", ":resize +2<CR>", opts)
keymap("n", "<S-M-j>", ":resize -2<CR>", opts)
keymap("n", "<S-M-h>", ":vertical resize +2<CR>", opts)
keymap("n", "<S-M-l>", ":vertical resize -2<CR>", opts)


-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Insert mode --
-- jk fast to enter normal mode ?
keymap("i", "jk", "<ESC>", opts)

-- Visual mode --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<J>", ":m .+1<CR>==", opts)
keymap("v", "<K>", ":m .-1<CR>==", opts)

keymap("v", "p", '"_dP', opts)

-- Visula block mode--
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
-- keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
-- keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)


-- Telescope --

-- we dont want to `require` anything external in this module,
-- as it may load before something was installed or 
-- call non-existing dependencies,
-- so we need to wrap it in another function
local telescope_factories = require('v3rganz.plugin_utils.telescope').factories
vim.keymap.set('n', '<leader>f', telescope_factories.current_buffer_fuzzy_find, { desc = '[/] Fuzzily search in current buffer' })
vim.keymap.set("n", "<leader>?", telescope_factories.oldfiles, {desc = "[?] Find recently opened files"})
vim.keymap.set("n", "<leader><space>", telescope_factories.oldfiles, {desc = "[ ] Find existing buffers"})
vim.keymap.set('n', '<leader>p', telescope_factories.find_files, { desc = '[p] Search files' })
vim.keymap.set('n', '<M-p>', telescope_factories.find_files_a, { desc = '[p] Search files (including ignored and hidden)' })
vim.keymap.set('n', '<leader>sh', telescope_factories.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', telescope_factories.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', telescope_factories.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', telescope_factories.diagnostics, { desc = '[S]earch [D]iagnostics' })

vim.keymap.set('n', 'ga', require('v3rganz.plugin_utils.nvim-tree.git-commands').git_add_toggle, { desc = 'Git add this node'})


-- toggleterm key bindings
vim.keymap.set('n', '<leader>g', require('v3rganz.plugin_utils.toggleterm').lazygit, {})
vim.keymap.set('n', '<C-p>', require('v3rganz.plugin_utils.toggleterm').python, {})

if vim.fn.executable(':Bdelete') then
    keymap("n", "<leader>b", ":Bdelete<CR>", opts)
else
    keymap("n", "<leader>b", ":bdelete")
end


-- keymaps to be imported separately by plugins
-- decision to define them here was made in order to fast access
-- and to be able to easily see what keymaps are defined by this config
return {
    lsp_keymaps = function(bufnr)
        local opts = { noremap = true, silent = true }
        local keymap = function (mode, map_from, map_to, opts)
            vim.api.nvim_buf_set_keymap(bufnr, mode, map_from, map_to, opts)
        end

        keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
        keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
        keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
        keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
        -- <C-k> may conflict with keymaps for switching panes ?
        keymap("n", "<M-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
        keymap("i", "<M-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
        -- keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
        keymap("n", "gr", "<cmd>:Telescope lsp_references<CR>", opts)
        keymap("n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts)
        keymap(
            "n",
            "gl",
            '<cmd>lua vim.diagnostic.open_float()<CR>',
            opts
        )
        keymap("n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts)
        keymap("n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
        keymap("n", "ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
        vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
    end,

    cmp_keymaps = function (cmp, luasnip)
        local cmp_utils = require("v3rganz.plugin_utils.cmp")
        return cmp.mapping.preset.insert({
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
            -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            ['<CR>'] = cmp.mapping.confirm({ select = false }),
            ["<Tab>"] = cmp_utils.supertab(cmp, luasnip),
            ["<S-Tab>"] = cmp_utils.s_supertab(cmp, luasnip),
      })
    end,

    nvim_tree_keymaps = function(bufnr)
        local api = require('nvim-tree.api')
        local function opts(desc)
            return {
                desc = 'nvim-tree: ' .. desc,
                buffer = bufnr,
                noremap = true,
                silent = true,
                nowait = true
            }
        end
        api.config.mappings.default_on_attach(bufnr)
        vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
        vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close node'))
        vim.keymap.set('n', 'v', api.node.open.vertical, opts('Open: Vertical split'))
    end,

    comment_operator = "<leader>/",

    autopairs_fast_wrap = '<M-e>',

    toggleterm = [[<c-\>]],
}
