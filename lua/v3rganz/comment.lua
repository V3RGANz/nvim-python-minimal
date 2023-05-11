local status_ok, comment = pcall(require, "nvim_comment")
if not status_ok then
    vim.notify("comment plugin failed to load")
    return
end

comment.setup {
    operator_mapping = "<leader>/"
}
