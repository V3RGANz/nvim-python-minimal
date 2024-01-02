return {
    {
        -- implementation of the Popup API
        "nvim-lua/popup.nvim",
        lazy = true
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        event = "VimEnter",
    },
    {
        "RRethy/vim-illuminate",
        event = "BufReadPost"
    },
    {
        'moll/vim-bbye',
        event = "BufRead"
    }
}
