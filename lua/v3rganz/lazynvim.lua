local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- why?
vim.g.mapleader = " " -- make sure to set `mapleader` before lazy so your mappings are correct

require('lazy').setup({
    spec = LAZY_PLUGIN_SPEC,
    install= {colorscheme = {require('v3rganz.plugins.colorscheme').name}},
    defaults = {lazy = true},
    ui = {wrap = "true"},
    debug = false,
    performance = {
        rtp = {
            disabled_plugins = {
                -- "2html_plugin",
                -- "tohtml",
                -- "getscript",
                -- "getscriptPlugin",
                -- "gzip",
                -- "logipat",
                -- "netrw",
                -- "netrwPlugin",
                -- "netrwSettings",
                -- "netrwFileHandlers",
                -- "matchit",
                -- "tar",
                -- "tarPlugin",
                -- "rrhelper",
                -- "spellfile_plugin",
                -- "vimball",
                -- "vimballPlugin",
                -- "zip",
                -- "zipPlugin",
                -- "tutor",
                -- --"rplugin",
                -- "syntax",
                -- "synmenu",
                -- "optwin",
                -- "compiler",
                -- "bugreport",
                -- "ftplugin",
            }
        }
    }
})
