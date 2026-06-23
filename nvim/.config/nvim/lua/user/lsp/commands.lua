-- Custom LSP commands for native Neovim LSP
local M = {}

-- Get all active LSP clients for the current buffer
local function get_buffer_clients(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
    return clients
end

-- Get all active LSP clients globally
local function get_all_clients()
    return vim.lsp.get_active_clients()
end

-- Format client info for display
local function format_client_info(client, bufnr)
    local lines = {}
    
    table.insert(lines, string.format("  %s", client.name))
    table.insert(lines, string.format("    ID: %d", client.id))
    
    if client.config.root_dir then
        table.insert(lines, string.format("    Root: %s", client.config.root_dir))
    else
        table.insert(lines, "    Root: Not set")
    end
    
    -- Count attached buffers
    local attached_buffers = vim.lsp.get_buffers_by_client_id(client.id)
    table.insert(lines, string.format("    Buffers: %d attached", #attached_buffers))
    
    -- Show key capabilities
    local caps = {}
    if client.server_capabilities.hoverProvider then
        table.insert(caps, "hover")
    end
    if client.server_capabilities.completionProvider then
        table.insert(caps, "completion")
    end
    if client.server_capabilities.definitionProvider then
        table.insert(caps, "definition")
    end
    if client.server_capabilities.referencesProvider then
        table.insert(caps, "references")
    end
    if client.server_capabilities.documentFormattingProvider then
        table.insert(caps, "formatting")
    end
    
    if #caps > 0 then
        table.insert(lines, string.format("    Capabilities: %s", table.concat(caps, ", ")))
    end
    
    return lines
end

-- LspInfo: Display information about active LSP clients
function M.lsp_info()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = get_buffer_clients(bufnr)
    
    local lines = {}
    table.insert(lines, "LSP Client Information")
    table.insert(lines, string.rep("─", 50))
    table.insert(lines, "")
    
    if #clients == 0 then
        table.insert(lines, "  No LSP clients attached to this buffer")
        table.insert(lines, "")
        table.insert(lines, "  Buffer: " .. bufnr)
        table.insert(lines, "  Filetype: " .. vim.bo[bufnr].filetype)
    else
        table.insert(lines, string.format("Active clients for buffer %d:", bufnr))
        table.insert(lines, "")
        
        for _, client in ipairs(clients) do
            local client_lines = format_client_info(client, bufnr)
            for _, line in ipairs(client_lines) do
                table.insert(lines, line)
            end
            table.insert(lines, "")
        end
    end
    
    -- Show all active clients globally
    local all_clients = get_all_clients()
    if #all_clients > #clients then
        table.insert(lines, string.rep("─", 50))
        table.insert(lines, string.format("Other active clients (%d):", #all_clients - #clients))
        table.insert(lines, "")
        
        for _, client in ipairs(all_clients) do
            local is_current_buffer = false
            for _, buf_client in ipairs(clients) do
                if buf_client.id == client.id then
                    is_current_buffer = true
                    break
                end
            end
            
            if is_current_buffer == false then
                local client_lines = format_client_info(client, nil)
                for _, line in ipairs(client_lines) do
                    table.insert(lines, line)
                end
                table.insert(lines, "")
            end
        end
    end
    
    -- Create floating window
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false
    vim.bo[buf].filetype = "lspinfo"
    
    local width = 60
    local height = math.min(#lines + 2, math.floor(vim.o.lines * 0.8))
    
    local opts = {
        relative = "editor",
        width = width,
        height = height,
        col = math.floor((vim.o.columns - width) / 2),
        row = math.floor((vim.o.lines - height) / 2),
        style = "minimal",
        border = "rounded",
        title = " LSP Info ",
        title_pos = "center",
    }
    
    local win = vim.api.nvim_open_win(buf, true, opts)
    
    -- Close with q or <Esc>
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, nowait = true })
    vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", { buffer = buf, nowait = true })
end

-- LspRestart: Restart LSP clients attached to current buffer
function M.lsp_restart(client_name)
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = get_buffer_clients(bufnr)
    
    if #clients == 0 then
        vim.notify("No LSP clients attached to this buffer", vim.log.levels.WARN)
        return
    end
    
    local restarted = {}
    
    for _, client in ipairs(clients) do
        if client_name == nil or client.name == client_name then
            local name = client.name
            local root_dir = client.config.root_dir
            
            -- Stop the client
            vim.lsp.stop_client(client.id)
            table.insert(restarted, name)
            
            -- Wait a bit for clean shutdown
            vim.wait(100)
            
            -- Restart by re-enabling
            vim.schedule(function()
                vim.lsp.enable(name)
            end)
        end
    end
    
    if #restarted > 0 then
        vim.notify(string.format("Restarted LSP clients: %s", table.concat(restarted, ", ")), vim.log.levels.INFO)
    else
        if client_name then
            vim.notify(string.format("LSP client '%s' not found in this buffer", client_name), vim.log.levels.WARN)
        end
    end
end

-- LspStart: Start a specific LSP server
function M.lsp_start(server_name)
    if server_name == nil or server_name == "" then
        vim.notify("Usage: :LspStart <server_name>", vim.log.levels.ERROR)
        return
    end
    
    -- Check if server is already running
    local clients = get_all_clients()
    for _, client in ipairs(clients) do
        if client.name == server_name then
            vim.notify(string.format("LSP server '%s' is already running", server_name), vim.log.levels.INFO)
            return
        end
    end
    
    -- Try to enable the server
    local ok = pcall(vim.lsp.enable, server_name)
    if ok then
        vim.notify(string.format("Started LSP server: %s", server_name), vim.log.levels.INFO)
    else
        vim.notify(string.format("Failed to start LSP server: %s", server_name), vim.log.levels.ERROR)
    end
end

-- LspStop: Stop LSP clients attached to current buffer
function M.lsp_stop(client_name)
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = get_buffer_clients(bufnr)
    
    if #clients == 0 then
        vim.notify("No LSP clients attached to this buffer", vim.log.levels.WARN)
        return
    end
    
    local stopped = {}
    
    for _, client in ipairs(clients) do
        if client_name == nil or client.name == client_name then
            vim.lsp.stop_client(client.id)
            table.insert(stopped, client.name)
        end
    end
    
    if #stopped > 0 then
        vim.notify(string.format("Stopped LSP clients: %s", table.concat(stopped, ", ")), vim.log.levels.INFO)
    else
        if client_name then
            vim.notify(string.format("LSP client '%s' not found in this buffer", client_name), vim.log.levels.WARN)
        end
    end
end

-- LspLog: Open the LSP log file
function M.lsp_log()
    local log_path = vim.lsp.get_log_path()
    
    if vim.fn.filereadable(log_path) == 0 then
        vim.notify("LSP log file not found: " .. log_path, vim.log.levels.WARN)
        return
    end
    
    vim.cmd("tabnew " .. log_path)
    vim.notify("Opened LSP log: " .. log_path, vim.log.levels.INFO)
end

-- Setup function to create commands
function M.setup()
    -- Create user commands
    vim.api.nvim_create_user_command("LspInfo", function()
        M.lsp_info()
    end, { desc = "Display LSP client information" })
    
    vim.api.nvim_create_user_command("LspRestart", function(opts)
        M.lsp_restart(opts.args ~= "" and opts.args or nil)
    end, {
        nargs = "?",
        desc = "Restart LSP clients (optionally specify client name)",
        complete = function()
            local clients = get_buffer_clients()
            local names = {}
            for _, client in ipairs(clients) do
                table.insert(names, client.name)
            end
            return names
        end,
    })
    
    vim.api.nvim_create_user_command("LspStart", function(opts)
        M.lsp_start(opts.args)
    end, {
        nargs = 1,
        desc = "Start an LSP server",
        complete = function()
            -- Return common server names from mason config
            return {
                "clangd",
                "pyright",
                "bashls",
                "yamlls",
                "rust_analyzer",
                "lua_ls",
                "taplo",
                "lemminx",
                "jsonls",
                "ruff",
            }
        end,
    })
    
    vim.api.nvim_create_user_command("LspStop", function(opts)
        M.lsp_stop(opts.args ~= "" and opts.args or nil)
    end, {
        nargs = "?",
        desc = "Stop LSP clients (optionally specify client name)",
        complete = function()
            local clients = get_buffer_clients()
            local names = {}
            for _, client in ipairs(clients) do
                table.insert(names, client.name)
            end
            return names
        end,
    })
    
    vim.api.nvim_create_user_command("LspLog", function()
        M.lsp_log()
    end, { desc = "Open LSP log file" })
end

-- Auto-setup when module is loaded
M.setup()

return M
