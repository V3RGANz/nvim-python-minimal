local M = {}

M.match_path = function(patterns, path)
    -- modules, at least in python, separated by dot, unlike paths
    path = path:gsub('%.', '/')
    -- normalize to always start with slash
    if path:sub(1, 1) ~= '/' then
        path = '/' .. path
    end
    for _, pattern in ipairs(patterns) do
        -- Convert glob-like pattern to Lua pattern
        pattern = pattern:gsub("%*", ".*"):gsub("%-", "%%-"):gsub("%/", "/")
        -- Add anchors to start and end
        pattern = "^" .. pattern .. "$"

        if string.match(path, pattern) then
            return true
        else
        end
      end
    return false
end

return M
