local status_ok, git_signs = pcall(require, "gitsigns")
if not status_ok then
    return
end

git_signs.setup({
    current_line_blame = true,
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',
        delay = 0
    },
    current_line_blame_formatter = '<committer> <committer_time> - <summary>'
})
