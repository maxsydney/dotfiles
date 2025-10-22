local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
    return
end

configs.setup({
    ensure_installed = { "c", "cpp", "rust", "python", "lua", "bash", "json" },
    sync_install = false,         -- Don't install synchronously
    auto_install = false,         -- Don't auto-install missing parsers
    highlight = {
        enable = true,            -- false will disable the whole extension
        additional_vim_regex_highlighting = true,
    },
    autopairs = {
        enable = true,
    },
    indent = {
        enable = true
    },
})
