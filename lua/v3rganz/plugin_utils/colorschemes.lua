local M = {
}

function M.get_initial_table(plug_address, style)
    return {
        plug_address,
        name = style,
        lazy = false,
        priority = 1000
    }
end

function M.setup_colorscheme(name)
    local status_ok, _ = pcall(vim.cmd.colorscheme, name)
    if not status_ok then
        vim.notify('colorscheme ' .. name .. ' failed to load')
    end
end

return M
