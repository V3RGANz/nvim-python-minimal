local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Install plugins
return packer.startup(function(use)
    -- list plugins
    use "wbthomason/packer.nvim" -- packer manager
    use "nvim-lua/popup.nvim" -- implementation of the Popup API
    use "nvim-lua/plenary.nvim" -- useful lua functions

    -- colorschemes
    use "catppuccin/nvim"
    use "ellisonleao/gruvbox.nvim"
    use "folke/tokyonight.nvim"
    use "rebelot/kanagawa.nvim"

    -- completion
    -- nvim-cmp
    use "hrsh7th/nvim-cmp" -- cmp plugin itself
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-path"
    use "hrsh7th/cmp-cmdline"
    use "saadparwaiz1/cmp_luasnip"
    use "hrsh7th/cmp-nvim-lsp"

    -- snippets
    -- use "L3MON4D3/LuaSnip" -- snippet engine
    use { "L3MON4D3/LuaSnip", commit = "8f8d493e7836f2697df878ef9c128337cbf2bb84" }
    use "rafamadriz/friendly-snippets"

    -- LSP
    use "neovim/nvim-lspconfig" -- enable LSP
    use "williamboman/mason.nvim" -- lsp installer
    use "williamboman/mason-lspconfig.nvim"
    use "jose-elias-alvarez/null-ls.nvim"-- null-ls

    -- Telescope
    use "nvim-telescope/telescope.nvim"
    -- treesitter
    use "nvim-treesitter/nvim-treesitter"

    -- Editor --
    use "windwp/nvim-autopairs" -- autopairs
    -- Alternative comments plugins [DISABLED]
    -- use "numToStr/Comment.nvim" -- Easily comment stuff
    -- use "JoosepAlviste/nvim-ts-context-commentstring" -- ts comments
    -- simple comment plugin
    use "terrortylor/nvim-comment"
    -- git sign
    use "lewis6991/gitsigns.nvim"
    -- explorer tree
    use "nvim-tree/nvim-tree.lua"
    -- buffer line
    use 'akinsho/bufferline.nvim'
    -- highlighting symbols
    use "RRethy/vim-illuminate"
    use 'moll/vim-bbye' -- for :Bdelete stuff, optional bcz :bdelete
    use 'akinsho/toggleterm.nvim'

    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
