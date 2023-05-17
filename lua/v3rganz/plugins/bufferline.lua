local M = {
    'akinsho/bufferline.nvim',
    event = { "BufReadPre", "BufAdd", "BufNew", "BufReadPost" },
    dependencies = {
        'moll/vim-bbye'
    }
}

function M.config()
    require('bufferline').setup {
        options = {
            show_buffer_close_icons = false,
            show_buffer_icons = false,
            offsets = {
                {
                    filetype = "NvimTree"
                }
            }
        },
    }
end

return M
