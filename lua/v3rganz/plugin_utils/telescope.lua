local M = {
    -- wrappers to avoid call `require` before we actually need
    factories = {}
}

function M.factories.current_buffer_fuzzy_find()
    require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
    })
end

function M.factories.oldfiles()
    return require("telescope.builtin").oldfiles()
end

function M.factories.find_files()
    return require('telescope.builtin').find_files()
end

function M.factories.find_files_a()
    require('telescope.builtin').find_files({
        hidden = true,
        no_ignore = true
    })
end

function M.factories.help_tags()
    return require('telescope.builtin').help_tags()
end

function M.factories.grep_string()
    return require('telescope.builtin').grep_string()
end

function M.factories.live_grep()
    return require('telescope.builtin').live_grep()
end

function M.factories.diagnostics()
    return require("telescope.builtin").diagnostics()
end


return M
