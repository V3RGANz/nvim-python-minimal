vim.opt.backup = false
vim.opt.clipboard = "unnamedplus"
vim.opt.cmdheight = 2
vim.opt.completeopt = {"menuone", "noselect"}
vim.opt.conceallevel = 0
vim.opt.fileencoding = "utf-8"
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.mouse = "a" -- maybe change this later
vim.opt.pumheight = 10 -- maybe too big ?
vim.opt.showmode = false -- not sure if I need this
vim.opt.showtabline = 2
vim.opt.smartcase = true -- need ?
vim.opt.smartindent = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false -- not sure
vim.opt.termguicolors = true
vim.opt.timeoutlen = 300
vim.opt.undofile = true
vim.opt.updatetime = 300
vim.opt.writebackup = false -- may be this is not good? read WARNING
-- tabbing
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.cursorline = true -- I dont need this
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 4
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.linebreak = true -- good if wrap is turned off
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
-- vim.opt.guifont -- need to be determined
vim.opt.shortmess:append "c"
vim.opt.whichwrap = "bs<>[]hl" -- travel prev/next line
vim.opt.formatoptions:remove({ "c", "r", "o" })
-- commented this, because bwe ge keys are also interpreted hyphenated
-- words as single word
-- vim.opt.iskeyword:append "-" -- hyphenated-words recognizerd by search
