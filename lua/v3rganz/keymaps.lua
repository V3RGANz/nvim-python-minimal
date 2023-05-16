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
keymap("n", "<S-C-k>", ":resize +2<CR>", opts)
keymap("n", "<S-C-j>", ":resize -2<CR>", opts)
keymap("n", "<S-C-h>", ":vertical resize +2<CR>", opts)
keymap("n", "<S-C-l>", ":vertical resize -2<CR>", opts)


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
vim.keymap.set('n', '<leader>f', function()
	require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
		winblend = 10,
  		previewer = false,
    })
end, { desc = '[/] Fuzzily search in current buffer' })
vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, {desc = "[?] Find recently opened files"})
vim.keymap.set("n", "<leader><space>", require("telescope.builtin").oldfiles, {desc = "[ ] Find existing buffers"})
vim.keymap.set('n', '<leader>p', require('telescope.builtin').find_files, { desc = '[p] Search files' })
vim.keymap.set('n', '<M-p>', function ()
    require('telescope.builtin').find_files({
        hidden = true,
        no_ignore = true
    })
end, { desc = '[p] Search files (including ignored and hidden)' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

vim.keymap.set('n', 'ga', require('v3rganz.nvim-tree.git-commands').git_add_toggle, { desc = 'Git add this node'})


-- toggleterm key bindings
vim.keymap.set('n', '<leader>g', require('v3rganz.toggleterm').lazygit, {})
vim.keymap.set('n', '<C-p>', require('v3rganz.toggleterm').python, {})

if vim.fn.executable(':Bdelete') then
    keymap("n", "<leader>b", ":Bdelete<CR>", opts)
else
    keymap("n", "<leader>b", ":bdelete")
end

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
        keymap("n", "<C-K>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
        keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
        keymap("n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts)
        keymap(
            "n",
            "gl",
            '<cmd>lua vim.diagnostic.open_float()<CR>',
            opts
        )
        keymap("n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts)
        keymap("n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
        vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
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
    end

}
