-- This is plugin needed for ipython notebooks support (with images)
-- however, it may become tricky to get it working on macOS. For other OS it may not need dependencies on lua rocks

local M = {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    build = ":UpdateRemotePlugins",
    event = "BufRead",
    init = function()
        vim.g.molten_image_provider = "image.nvim"
        vim.g.molten_virt_text_output = true
	    vim.g.molten_auto_open_output = false
        vim.g.molten_enter_output_behavior = "open_and_enter"
        require("v3rganz.keymaps").molten_keymaps()
    end
}

return M
