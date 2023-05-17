local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
    return
end

local M = {
    'akinsho/bufferline.nvim',
    event = { "BufReadPre", "BufAdd", "BufNew", "BufReadPost" },
    dependencies = {
        'moll/vim-bbye'
    }
}

function M.config()
    bufferline.setup {
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
