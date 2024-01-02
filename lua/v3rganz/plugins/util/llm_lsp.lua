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
    local _, winnr = vim.lsp.util.open_floating_preview(lines, "markdown", opts)
    vim.api.nvim_set_current_win(winnr)
end

local function executeCommand(err, result, ctx, cfg)
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
end

local function showMessage(err, result, ctx, cfg)
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
end

local function showMessageRequest(err, result, ctx, cfg)
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
end

local function requestUserInput(err, result, ctx, cfg)
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
            if client == nil then
                vim.notify("No client found", vim.log.levels.ERROR)
            else
                client.request("window/userInputResponse", user_input_command_params, function(_err, _result, _ctx, _cfg)
                    if _err then
                        vim.notify("Error sending user input to server: " .. _err.message, vim.log.levels.ERROR)
                        return
                    end
                end, 0)
            end
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

local M = {}

M.handlers = {
    ["workspace/executeCommand"] = executeCommand,
    ["window/showMessage"] = showMessage,
    ["window/showMessageRequest"] = showMessageRequest,
    ["window/requestUserInput"] = requestUserInput,
}

local cmd = '/Users/Evgeny.Dedov/development/rust/llm-lsp/target/release/llm-lsp'

function M.setup()
    if not require("v3rganz.util").path_is_file(cmd) then
        vim.api.nvim_err_writeln('llm-lsp executable not found')
        return
    end
    local lsp_ok, lspconfig = pcall(require, "lspconfig")
    local configs_ok, configs = pcall(require, "lspconfig.configs")

    if not (lsp_ok and configs_ok) then return end

    local default_config = {
        cmd = {cmd},
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
    }
    if not configs.llm_lsp then configs.llm_lsp = {default_config = default_config} end
    lspconfig.llm_lsp.setup {handlers = M.handlers}
    vim.api.nvim_notify("llm-lsp configured", vim.log.levels.INFO, {})
end

return M
