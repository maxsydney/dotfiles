-- Mason setup for LSP server and DAP installation
require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

local servers = {
    "clangd",               -- C/C++
    "pyright",              -- Python
    "bashls",               -- Bash
    "yamlls",               -- YAML
    "rust_analyzer",        -- Rust
    "lua_ls",               -- Lua
    "taplo",                -- TOML
    "lemminx",              -- XML
    "jsonls"                -- JSON
}

local debuggers = {
    "codelldb",       -- For C/C++/Rust
    "python",         -- For Python
    "cpptools"
}

-- Configure mason-lspconfig to auto-install servers
require("mason-lspconfig").setup({
    ensure_installed = servers,
    automatic_installation = true,
})

-- Configure mason-nvim-dap for debuggers
local mason_dap_ok, mason_dap = pcall(require, "mason-nvim-dap")
if mason_dap_ok then
    mason_dap.setup({
        ensure_installed = debuggers,
        automatic_installation = true,
        handlers = {
            function(config)
                require('mason-nvim-dap').default_setup(config)
            end,
        },
    })
else
    print("Warning: mason-nvim-dap not available, debug adapters not installed")
end

-- Get LSP handlers (on_attach and capabilities)
local handlers = require("user.lsp.handlers")

-- Register global LSP configuration
-- This applies on_attach and capabilities to all LSP servers
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client then
            handlers.on_attach(client, args.buf)
        end
    end,
})

-- Set default capabilities for all servers
vim.lsp.config('*', {
    capabilities = handlers.capabilities,
})

-- Enable all LSP servers using the new vim.lsp.enable() API
-- Servers will load their configs from ~/.config/nvim/lsp/<servername>.lua if they exist,
-- otherwise they'll use nvim-lspconfig's default configs
vim.lsp.enable(servers)
