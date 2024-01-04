local function create_opts_factory(opts)
    local desc_prefix = opts.desc_prefix or ""
    opts.desc_prefix = nil
    local default_opts = {noremap = true, silent = true}

    local function factory(desc)
        local final_opts = vim.tbl_extend("force", default_opts, opts)
        if desc then final_opts.desc = desc_prefix .. desc end
        return final_opts
    end
    return factory
end

-- local opts = {noremap = true, silent = true}
local basic_opts = create_opts_factory({})
-- local term_opts = {silent = true}

local keymap = vim.keymap.set

keymap("", "<Space>", "<Nop>", basic_opts())
vim.g.mapleader = " "
vim.g.maplocalleader = " " -- ? 

-- Normal mode --
-- Window navigation shorter
keymap("n", "<C-h>", "<C-w>h", basic_opts("Window navigation (left)"))
keymap("n", "<C-j>", "<C-w>j", basic_opts("Window navigation (down)"))
keymap("n", "<C-k>", "<C-w>k", basic_opts("Window navigation (up)"))
keymap("n", "<C-l>", "<C-w>l", basic_opts("Window navigation (right)"))

-- horizontal scroll faster
keymap("n", "zh", "20zh", basic_opts("Faster horizontal scroll (left)"))
keymap("n", "zl", "20zl", basic_opts("Faster horizontal scroll (right)"))

-- explorer
-- keymap("n", "<leader>e", ":Lex 30<cr>", opts)
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", basic_opts("Toggle [E]xplorer"))

-- splits
keymap("n", "<leader>v", ":vsplit<CR>", basic_opts("[V]ertical split"))
keymap("n", "<leader>h", ":split<CR>", basic_opts("[H]orizontal split"))

-- resize 'panes' with arrows
keymap("n", "<S-M-k>", ":resize +2<CR>", basic_opts("Resize window horizontally (+)"))
keymap("n", "<S-M-j>", ":resize -2<CR>", basic_opts("Resize window horizontally (-)"))
keymap("n", "<S-M-h>", ":vertical resize +2<CR>", basic_opts("Resize window vertically (+)"))
keymap("n", "<S-M-l>", ":vertical resize -2<CR>", basic_opts("Resize window vertically (-)"))


-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", basic_opts("Next buffer"))
keymap("n", "<S-h>", ":bprevious<CR>", basic_opts("Previous buffer"))

-- Insert mode --
-- jk fast to enter normal mode ?
keymap("i", "jk", "<ESC>", basic_opts("Enter Normal mode"))

-- Visual mode --
-- Stay in indent mode
keymap("v", "<", "<gv", basic_opts("Indent left"))
keymap("v", ">", ">gv", basic_opts("Indent right"))

-- Move text up and down
keymap("v", "<J>", ":m .+1<CR>==", basic_opts("Move selection down"))
keymap("v", "<K>", ":m .-1<CR>==", basic_opts("Move selection up"))

-- Paste without yanking
keymap("v", "p", '"_dP', basic_opts())

-- Visula block mode--
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", basic_opts("Move selection down"))
keymap("x", "K", ":move '<-2<CR>gv-gv", basic_opts("Move selection up"))
-- keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
-- keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)


-- Telescope --

-- we dont want to `require` anything external in this module,
-- as it may load before something was installed or 
-- call non-existing dependencies,
-- so we need to wrap it in another function
local telescope_factories = require('v3rganz.plugins.util.telescope').factories
keymap('n', '<leader>f', telescope_factories.current_buffer_fuzzy_find, { desc = '[F] Fuzzily search in current buffer' })
keymap("n", "<leader>?", telescope_factories.oldfiles, {desc = "[?] Find recently opened files"})
keymap("n", "<leader><space>", telescope_factories.buffers, {desc = "[ ] Find existing buffers"})
keymap('n', '<leader>p', telescope_factories.find_files, { desc = '[P] Search files' })
keymap('n', '<M-p>', telescope_factories.find_files_a, { desc = '[P] Search files (including ignored and hidden)' })
keymap('n', '<leader>sh', telescope_factories.help_tags, { desc = '[S]earch [H]elp' })
keymap('n', '<leader>sw', telescope_factories.grep_string, { desc = '[S]earch current [W]ord' })
keymap('n', '<leader>sg', telescope_factories.live_grep, { desc = '[S]earch by [G]rep' })
keymap('n', '<leader>sd', telescope_factories.diagnostics, { desc = '[S]earch [D]iagnostics' })

keymap('n', 'ga', require('v3rganz.plugins.util.nvim-tree.git-commands').git_add_toggle, { desc = 'Git add this node'})


-- toggleterm key bindings
keymap('n', '<leader>g', require('v3rganz.plugins.util.toggleterm').lazygit, basic_opts("Toggle [G]it"))
keymap('n', '<C-p>', require('v3rganz.plugins.util.toggleterm').python, basic_opts("Toggle [P]ython"))
keymap('t', '<C-p>', function ()
    vim.cmd 'stopinsert'
    require('v3rganz.plugins.util.toggleterm').python()
end, { noremap = true, silent = true })
keymap('n', '<M-o>b', require('v3rganz.plugins.util.toggleterm').obsidian_daily, basic_opts("Toggle [O]bsidian [D]aily"))


-- closes window but not quit vim
keymap("n", "<leader>w", ":close<CR>", basic_opts("Close window"))
-- close buffer
if vim.fn.executable(':Bdelete') then
    keymap("n", "<leader>b", ":Bdelete<CR>", basic_opts("Close buffer"))
else
    keymap("n", "<leader>b", ":bdelete", basic_opts("Close buffer"))
end


-- keymaps to be imported separately by plugins
-- decision to define them here was made in order to fast access
-- and to be able to easily see what keymaps are defined by this config
return {
    lsp_keymaps = function(bufnr)
        local opts = create_opts_factory({})
        ---@diagnostic disable-next-line: redefined-local
        local keymap = function (mode, map_from, map_to, _opts)
            vim.api.nvim_buf_set_keymap(bufnr, mode, map_from, map_to, _opts)
        end

        keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts("[G]o to [D]eclaration"))
        keymap("n", "gd", "<cmd>:Telescope lsp_definitions<CR>", opts("[G]o to [D]efinition"))
        keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts("Show hover"))
        keymap("n", "gi", "<cmd>:Telescope lsp_implementations<CR>", opts("[G]o to [I]mplementation"))
        -- <C-k> may conflict with keymaps for switching panes ?
        keymap("n", "<M-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts("Show signature help"))
        keymap("i", "<M-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts("Show signature help"))
        -- keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
        keymap("n", "gr", "<cmd>:Telescope lsp_references<CR>", opts("[G]o to [R]eferences"))
        keymap("n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts("[D]iagnostic Previous"))
        keymap("n", "gl", '<cmd>lua vim.diagnostic.open_float()<CR>', opts("Diagnostic [L]ist"))
        keymap("n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts("[D]iagnostic Next"))
        keymap("n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts("[Q]uickfix"))
        keymap("n", "<leader>a", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts("Code [A]ction"))
        keymap("v", "<leader>a", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts("Code [A]ction"))
        vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
    end,

    ---@diagnostic disable-next-line: unused-local
    cmp_keymaps = function (cmp, luasnip)
        -- local cmp_utils = require("v3rganz.plugins.util.cmp")
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

            -- This supertab is actually bothers me sometimes
            -- ["<Tab>"] = cmp_utils.supertab(cmp, luasnip),
            -- ["<S-Tab>"] = cmp_utils.s_supertab(cmp, luasnip),
      })
    end,

    nvim_tree_keymaps = function(bufnr)
        local api = require('nvim-tree.api')
        local opts = create_opts_factory({ desc_prefix = 'nvim-tree: ', buffer = bufnr, nowait = true })
        api.config.mappings.default_on_attach(bufnr)
        keymap('n', 'l', api.node.open.edit, opts('Open'))
        keymap('n', 'h', api.node.navigate.parent_close, opts('Close node'))
        keymap('n', 'v', api.node.open.vertical, opts('Open: Vertical split'))
    end,

    comment_operator = "<leader>/",

    autopairs_fast_wrap = '<M-e>',

    toggleterm = [[<c-\>]],

    molten_keymaps = function ()
        local opts = create_opts_factory({desc_prefix = "Molten: "})
        keymap("n", "<leader>r", ":MoltenEvaluateOperator<CR>", opts("[R] Evaluate Operator"))
        keymap("n", "<leader>l", ":MoltenEvaluateLine<CR>", opts("[L] Evaluate Line"))
        keymap("n", "<leader>so", ":noautocmd MoltenEnterOutput<CR>", opts("[S]how [O]utput"))
        keymap("n", "<leader>rr", ":MoltenReevaluateCell<CR>", opts("[RR]eevaluate Cell"))
    end,

    quarto_keymaps = function ()
        local status_ok, runner = pcall(require, "quarto.runner")
        if not status_ok then return end

        local opts = create_opts_factory({desc_prefix = "Quarto: "})

        local function create_cell()
            if vim.bo.filetype ~= 'quarto' then return end
            vim.api.nvim_feedkeys("o```{python}\n\n```\x1bk", "n", false)
        end

        keymap("n", "<leader>rc", runner.run_cell, opts("[R]un [C]ell"))
        keymap("n", "<leader>cc", create_cell, opts("[C]reate [C]ell"))
    end
}
