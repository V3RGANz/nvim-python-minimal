local M = {}
-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes#git-stage-unstage-files-and-directories-from-the-tree
function M.git_add_toggle()
    local api = require("nvim-tree.api")
    local node_status_ok, node = pcall(api.tree.get_node_under_cursor)
    if not node_status_ok then
        vim.notify("open nvim-tree to git add/unstage")
        return
    end
    local gs = node.git_status.file

    -- If the current node is a directory get children status
    if gs == nil then
    gs = (node.git_status.dir.direct ~= nil and node.git_status.dir.direct[1])
         or (node.git_status.dir.indirect ~= nil and node.git_status.dir.indirect[1])
    end

    -- If the file is untracked, unstaged or partially staged, we stage it
    if gs == "??" or gs == "MM" or gs == "AM" or gs == " M" then
        vim.cmd("silent !git add " .. node.absolute_path)
    -- If the file is staged, we unstage
    elseif gs == "M " or gs == "A " then
        vim.cmd("silent !git restore --staged " .. node.absolute_path)
    end

    api.tree.reload()
end

return M
