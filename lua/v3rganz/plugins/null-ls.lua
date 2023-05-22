local M = {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        lazy = true
    },
    event = "BufReadPre"
}

function M.config()
    local null_ls = require("null-ls")
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    local formatting = null_ls.builtins.formatting
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
    local diagnostics = null_ls.builtins.diagnostics
    local helpers = require('null-ls.helpers')

    local flake8_severity_map = {
        D = helpers.diagnostics.severities['information'],
        F = helpers.diagnostics.severities['information'],
        E = helpers.diagnostics.severities['warning'],
        W = helpers.diagnostics.severities['warning'],
        R = helpers.diagnostics.severities['warning'],
        S = helpers.diagnostics.severities['warning'],
        I = helpers.diagnostics.severities['warning'],
        C = helpers.diagnostics.severities['warning'],
    }

    null_ls.setup({
        debug = false,
        sources = {
            formatting.black.with({ extra_args = { "--fast" } }),
            -- formatting.stylua,
        --     diagnostics.flake8.with({
        --         -- default max_line_length make 120, can be overrided in project
        --         -- tox.ini
        --         extra_args = { '--max_line_length=119' },
        --         diagnostics_postprocess = function(d)
        --             -- stylistics problems not considered as errors
        --             if d.severity == helpers.diagnostics.severities.error then
        --                 d.severity = helpers.diagnostics.severities.warning
        --             end
        --     end,
        -- }),
            diagnostics.mypy
        },
    })
end

return M
