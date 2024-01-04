local M = {
    'akinsho/toggleterm.nvim',
    event = "VeryLazy"
}

function M.config()
    require('toggleterm').setup {
        size = 30,
        open_mapping = require("v3rganz.keymaps").toggleterm,
    }
    require('v3rganz.plugins.util.toggleterm').setup { use_quarto = true }
end

return M
