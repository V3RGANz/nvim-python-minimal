local M = {
    "neovim/nvim-lspconfig",
    lazy = true,
    dependencies = {
       "hrsh7th/cmp-nvim-lsp",
    }
}

local function open_floating_preview(content, opts)
    local lines = vim.split(content, '\n')
    local preview_width = math.min(40, vim.api.nvim_win_get_width(0))
    opts = vim.tbl_deep_extend("force", opts or {}, {
        relative = "cursor",
        border = false,
        wrap = true,
        wrap_at = preview_width,
        max_width = preview_width + 1,
        focusable = true
    })
    vim.lsp.util.open_floating_preview(lines, "markdown", opts)
end

function M.config()
    local config = {
        virtual_text = true,
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
    }
    vim.diagnostic.config(config)

    local lspconfig = require("lspconfig")
    local configs = require('lspconfig.configs')

    -- install custom server which is not come from lspinstall
    if not configs.llm_lsp then
        configs.llm_lsp = {
            default_config = {
                cmd = {'/Users/Evgeny.Dedov/development/rust/llm-lsp/target/release/llm-lsp'},
                -- just add bunch of acceptable filetypes
                filetypes = {"rust", "python", "lua", "javascript", "typescript", "sh", "cpp", "c", "go"},
                root_dir = function(fname)
                    local git_root = lspconfig.util.find_git_ancestor(fname)
                    if git_root ~= nil then
                        return git_root
                    end
                    local root_pattern = lspconfig.util.root_pattern("Cargo.toml", "pyproject.toml", "package.json", "go.mod")(fname)
                    if root_pattern ~= nil then
                        return root_pattern
                    end
                    return lspconfig.util.path.dirname(fname)
               end
                -- capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
            },
        }
    end
    lspconfig.llm_lsp.setup{
        handlers = {
            ["workspace/executeCommand"] = function (err, result, ctx, cfg)
                if err ~= nil then
                    vim.notify("Error executing command: " .. err.message, vim.log.levels.ERROR)
                    return
                end
                vim.notify(vim.inspect(result))
                if result == nil then
                    vim.notify("No result from command", vim.log.levels.WARN)
                    return
                end
                if result.command == 'llm-lsp.explainCodeChunk' then
                    local explanation = result.arguments[1]
                    if #explanation == 0 then
                        vim.notify("Nothing to show in explanation window", vim.log.levels.WARN)
                        return
                    end
                    open_floating_preview(explanation)
                elseif result.command == 'llm-lsp.refactorFunction' then
                    local content = result.arguments[1]
                    if #content == 0 then
                        vim.notify("Nothing to show in explanation window", vim.log.levels.WARN)
                        return
                    end
                    open_floating_preview(content, {wrap_at = 80, max_width = 81})
                else
                    vim.lsp.handlers["workspace/executeCommand"](err, result, ctx, cfg)
                end
            end,
            ["window/showMessage"] = function (err, result, ctx, cfg)
                if err ~= nil then
                    vim.notify("Error executing command: " .. err.message, vim.log.levels.ERROR)
                    return
                end

                local level_lookup = {
                    [4] = vim.log.levels.DEBUG,
                    [3] = vim.log.levels.INFO,
                    [2] = vim.log.levels.WARN,
                    [1] = vim.log.levels.ERROR,
                }

                vim.notify(result.message, level_lookup[result.type])
                vim.lsp.handlers["window/showMessage"](err, result, ctx, cfg)
            end,
            ["window/showMessageRequest"] = function (err, result, ctx, cfg)
                if err ~= nil then
                    vim.notify("Message request error: " .. err.message, vim.log.levels.ERROR)
                    return
                end

                local height = math.min(10, #result.message)
                vim.cmd("belowright " .. height .. "new")

                local buf = vim.api.nvim_get_current_buf()

                vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
                vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
                vim.api.nvim_buf_set_option(buf, "swapfile", false)
                vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
                vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(result.message, '\n'))

                return { result = { title = result.message } }
            end,
            ["window/requestUserInput"] = function (err, result, ctx, cfg)
                if err then
                    vim.notify("Error executing requestUserInput command: " .. err.message, vim.log.levels.ERROR)
                    return
                end

                -- create a new buffer
                local buf = vim.api.nvim_create_buf(false, true)

                local col = math.floor((vim.o.columns - 50) / 2)
                local row = math.floor((vim.o.lines - 10) / 2)
                -- create a floating window
                local win = vim.api.nvim_open_win(buf, true, {
                    relative = "editor",
                    width = 50,
                    height = 1,
                    style = "minimal",
                    border = "rounded",
                    row = row,
                    col = col,
                    focusable = true,
                })

                -- set buffer to be a prompt
                vim.api.nvim_buf_set_option(buf, "buftype", "prompt")

                -- set prompt prefix
                local prefix = 'Enter command: '
                vim.fn.prompt_setprompt(buf, prefix)

                -- define callback function for when Enter is pressed.
                local function on_enter()
                    -- get text from the buffer
                    local text = vim.fn.getline(1, '$')[1]
                    text = string.sub(text, #prefix + 1, #text)

                    if #text > 0 then
                        local client = vim.lsp.get_client_by_id(ctx.client_id)
                        local user_input_command_params = {
                            command = result.command,
                            command_params = result.command_params,
                            prompt = text
                        }
                        client.request("window/userInputResponse", user_input_command_params, function(_err, _result, _ctx, _cfg)
                            if _err then
                                vim.notify("Error sending user input to server: " .. _err.message, vim.log.levels.ERROR)
                                return
                            end
                        end)
                    else
                        vim.notify("No input provided", vim.log.levels.WARN)
                    end
                    -- close the window and delete the buffer
                    vim.api.nvim_win_close(win, true)
                    vim.api.nvim_buf_delete(buf, { force = true })
                end

                -- window starts in insert mode
                vim.api.nvim_command("startinsert!")

                -- set callback funciton for Enter key
                vim.fn.prompt_setcallback(buf, on_enter)
                vim.api.nvim_set_current_win(win)

                return { result = { title = result.message } }
            end
        },
    }
end

return M
