local status_ok, autopairs = pcall(require, "nvim-autopairs")
if not status_ok then
    vim.notify("autopairs failed to load")
    return
end

autopairs.setup {
    disable_filetype = { "TelescopePrompt", "spectre_panel" },
    check_ts = true,
    ts_config = {
        lua = { "string", "source" },
        javascript = { "string", "template_string" },
        java = false, -- ??
    },

    fast_wrap = {
        map = '<M-e>',
        chars = { '{', '[', '(', '"', "'" },
        pattern = [=[[%'%"%>%]%)%}%,]]=],
        end_key = '$',
        keys = 'qwertyuiopzxcvbnmasdfghjkl',
        check_comma = true,
        highlight = 'Search',
        highlight_grey='Comment'
    },
}
