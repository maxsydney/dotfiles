-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Configure lazy.nvim
require("lazy").setup({
    -- Core dependencies
    { "nvim-lua/plenary.nvim" },
    { 
        "windwp/nvim-autopairs",
        event = "InsertEnter",
    },
    { 
        "numToStr/Comment.nvim",
        keys = {
            { "gc", mode = { "n", "v" }, desc = "Comment toggle linewise" },
            { "gb", mode = { "n", "v" }, desc = "Comment toggle blockwise" },
        },
    },
    { 
        "kyazdani42/nvim-web-devicons",
        lazy = true,
    },
    { 
        "kyazdani42/nvim-tree.lua",
        cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },
        keys = {
            { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer" },
        },
    },
    { 
        "akinsho/bufferline.nvim",
        event = { "BufReadPost", "BufNewFile" },
        keys = {
            { "<S-h>", "<cmd>bprevious<cr>", desc = "Prev buffer" },
            { "<S-l>", "<cmd>bnext<cr>", desc = "Next buffer" },
        },
    },
    { 
        "moll/vim-bbye",
        cmd = { "Bdelete", "Bwipeout" },
    },
    { 
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
    },
    { 
        "ahmedkhalf/project.nvim",
        event = "VeryLazy",
    },
    { 
        "lukas-reineke/indent-blankline.nvim",
        event = { "BufReadPost", "BufNewFile" },
    },
    { 
        "folke/which-key.nvim",
        event = "VeryLazy",
    },
    { 
        "ThePrimeagen/harpoon",
        keys = {
            { "<leader>h", desc = "Harpoon" },
        },
    },

    -- Terminal
    { 
        "akinsho/toggleterm.nvim",
        cmd = { "ToggleTerm", "TermExec" },
        keys = {
            { "<C-\\>", desc = "Toggle terminal" },
        },
    },

    -- Colorschemes
    { "lunarvim/Onedarker.nvim", lazy = true },
    { "ellisonleao/gruvbox.nvim", lazy = true },
    { "navarasu/onedark.nvim", lazy = true },
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

    -- Completion plugins
    { 
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lua",
        },
    },
    { "hrsh7th/cmp-buffer", lazy = true },
    { "hrsh7th/cmp-path", lazy = true },
    { "hrsh7th/cmp-nvim-lsp", lazy = true },
    { "hrsh7th/cmp-nvim-lua", lazy = true },

    -- LSP
    { 
        "williamboman/mason.nvim",
        cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate" },
        build = ":MasonUpdate",
    },
    { 
        "williamboman/mason-lspconfig.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "williamboman/mason.nvim" },
    },
    { 
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
    },

    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        keys = {
            { "<C-p>", "<cmd>Telescope find_files<cr>", desc = "Find files" },
            { "<C-space>", "<cmd>Telescope commands<cr>", desc = "Commands" },
            { "fg", desc = "Live grep" },
            { "fc", "<cmd>Telescope grep_string<cr>", desc = "Grep string" },
            { "fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
            { "fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
        },
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    { 
        "nvim-telescope/telescope-live-grep-args.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        dependencies = { "nvim-telescope/telescope.nvim" },
    },
    {
        "nvim-telescope/telescope-frecency.nvim",
        dependencies = { 
            "nvim-telescope/telescope.nvim",
            "kkharji/sqlite.lua",
        },
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
    },

    -- Debugging
    { 
        "mfussenegger/nvim-dap",
        keys = {
            { "<leader>d", desc = "Debug" },
        },
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        keys = {
            { "<leader>d", desc = "Debug" },
        },
    },
    { 
        "mfussenegger/nvim-dap-python",
        ft = "python",
        dependencies = { "mfussenegger/nvim-dap" },
    },
    { 
        "theHamsta/nvim-dap-virtual-text",
        dependencies = { "mfussenegger/nvim-dap" },
    },
    { "nvim-neotest/nvim-nio", lazy = true },
    { 
        "nvim-telescope/telescope-dap.nvim",
        dependencies = { 
            "nvim-telescope/telescope.nvim",
            "mfussenegger/nvim-dap",
        },
    },
    { 
        "ldelossa/nvim-dap-projects",
        dependencies = { "mfussenegger/nvim-dap" },
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-dap",
        },
        cmd = { "DapInstall", "DapUninstall" },
    },

    -- Git
    { 
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    },

    -- Visual tweaks
    { 
        "stevearc/dressing.nvim",
        event = "VeryLazy",
    },
}, {
    ui = {
        border = "rounded",
    },
    checker = {
        enabled = true,
        notify = false,
    },
    change_detection = {
        notify = false,
    },
})
