local M = {}

function M.match_path(patterns, path)
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

function M.str_startswith(str, start)
    return string.sub(str, 1, string.len(start)) == start
end

function M.str_join(str_array, sep)
    local res = str_array[1]
    for index, value in ipairs(str_array) do
        if index ~= 1 then
            res = res .. sep .. value
        end
    end
    return res
end

return M
