-- image rendering support (Markdown & IPython)

-- This is macOS specific
-- LuaJIT didn't compile on my macOS and found some env needs to be defined
-- foun solution here https://www.cnblogs.com/helios-fz/p/15697785.html but generalized it with sw_vers
local env = "export MACOSX_DEPLOYMENT_TARGET=$(sw_vers -productVersion) && "


local M = {
    "3rd/image.nvim",
    event = "BufRead",
    config = function ()
        require("image").setup {
            backend = "kitty",
            integrations = {
                markdown = {
                    enabled = true,
                    clear_in_insert_mode = false,
                    download_remote_images = true,
                    only_render_image_at_cursor = false,
                    filetypes = { "markdown", "vimwiki", "quarto" }, -- markdown extensions (ie. quarto) can go here
                },
            },
            max_width = 1024,
            max_height = 1024,
            max_width_window_percentage = math.huge,
            max_height_window_percentage = math.huge,
            window_overlap_clear_enabled = true,
            window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "noice", "" },
        }
    end,
    dependencies = {
        -- need for image magick lua support
        {
            "theHamsta/nvim_rocks",
            event = "VeryLazy",
            build = env .. "pip3 install --user hererocks && python3 -mhererocks . -j2.1.0-beta3 -r3.0.0 && cp nvim_rocks.lua lua",
            config = function()
                require("nvim_rocks").ensure_installed({ "magick" })
            end
        }
    }
}

return M
