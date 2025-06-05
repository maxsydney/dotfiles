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
    "rust_analyzer",        -- rust
    "lua_ls",               -- lua
    "taplo",                -- TOML
    "lemminx",              -- XML
    "jsonls"                -- JSON
}

local debuggers = {
    "codelldb",       -- For C/C++/Rust
    "python",         -- For Python
    "cpptools"
}

local lspconfig = require("lspconfig")
local opts = {}

-- Configure mason-lspconfig
-- require("mason-lspconfig").setup ({
--     ensure_installed = servers,
--     automatic_installation = true,
-- })

-- Configure mason-nvim-dap
local mason_dap_ok, mason_dap = pcall(require, "mason-nvim-dap")
if mason_dap_ok then
    mason_dap.setup({
        ensure_installed = debuggers,
        automatic_installation = true,
        handlers = {
            function(config)
                -- Default setup for debug adapters
                require('mason-nvim-dap').default_setup(config)
            end,
        },
    })
else
    print("Warning: mason-nvim-dap not available, debug adapters not installed")
end

--[[ require'lspconfig'.jsonls.setup{} ]]

for _, server in pairs(servers) do
    opts = {
        on_attach = require("user.lsp.handlers").on_attach,
        capabilities = require("user.lsp.handlers").capabilities,
    }

    if server == "lua_ls" then
        local sumneko_opts = require "user.lsp.settings.sumneko_lua"
        opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
    end

    if server == "pyright" then
        local pyright_opts = require "user.lsp.settings.pyright"
        opts = vim.tbl_deep_extend("force", pyright_opts, opts)
    end

    if server == "lemminx" then
        local lemminx_opts = require("user.lsp.settings.lemminx")
        opts = vim.tbl_deep_extend("force", lemminx_opts, opts)
    end

    if server == "jsonls" then
        local jsonls_opts = require("user.lsp.settings.jsonls")
        opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
    end

    if server == "rust_analyzer" then
        local keymap = vim.keymap.set
        local key_opts = { silent = true }

        keymap("n", "<leader>rh", "<cmd>RustSetInlayHints<Cr>", key_opts)
        keymap("n", "<leader>rhd", "<cmd>RustDisableInlayHints<Cr>", key_opts)
        keymap("n", "<leader>th", "<cmd>RustToggleInlayHints<Cr>", key_opts)
        keymap("n", "<leader>rr", "<cmd>RustRunnables<Cr>", key_opts)
        keymap("n", "<leader>rem", "<cmd>RustExpandMacro<Cr>", key_opts)
        keymap("n", "<leader>roc", "<cmd>RustOpenCargo<Cr>", key_opts)
        keymap("n", "<leader>rpm", "<cmd>RustParentModule<Cr>", key_opts)
        keymap("n", "<leader>rjl", "<cmd>RustJoinLines<Cr>", key_opts)
        keymap("n", "<leader>rha", "<cmd>RustHoverActions<Cr>", key_opts)
        keymap("n", "<leader>rhr", "<cmd>RustHoverRange<Cr>", key_opts)
        keymap("n", "<leader>rmd", "<cmd>RustMoveItemDown<Cr>", key_opts)
        keymap("n", "<leader>rmu", "<cmd>RustMoveItemUp<Cr>", key_opts)
        keymap("n", "<leader>rsb", "<cmd>RustStartStandaloneServerForBuffer<Cr>", key_opts)
        keymap("n", "<leader>rd", "<cmd>RustDebuggables<Cr>", key_opts)
        keymap("n", "<leader>rv", "<cmd>RustViewCrateGraph<Cr>", key_opts)
        keymap("n", "<leader>rw", "<cmd>RustReloadWorkspace<Cr>", key_opts)
        keymap("n", "<leader>rss", "<cmd>RustSSR<Cr>", key_opts)
        keymap("n", "<leader>rxd", "<cmd>RustOpenExternalDocs<Cr>", key_opts)

         require("rust-tools").setup {
             tools = {
                 on_initialized = function()
                     vim.cmd [[
             autocmd BufEnter,CursorHold,InsertLeave,BufWritePost *.rs silent! lua vim.lsp.codelens.refresh()
           ]]
                 end,
             },
             server = {
                 on_attach = require("user.lsp.handlers").on_attach,
                 capabilities = require("user.lsp.handlers").capabilities,
                 settings = {
                     ["rust-analyzer"] = {
                         lens = {
                             enable = true,
                         },
                         checkOnSave = {
                             command = "clippy",
                         },
                     },
                 },
             },
         }

        goto continue
    end

    lspconfig[server].setup(opts)
    ::continue::
end
