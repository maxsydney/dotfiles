local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system({
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    })
    print("Installing packer close and reopen Neovim...")
    vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Have packer use a popup window
packer.init({
    display = {
        open_fn = function()
            return require("packer.util").float({ border = "rounded" })
        end,
    },
})
-- Install your plugins here
return packer.startup(function(use)
    use { "wbthomason/packer.nvim" } -- Have packer manage itself
    use { "nvim-lua/plenary.nvim" }  -- Useful lua functions used by lots of plugins
    use { "windwp/nvim-autopairs" }  -- Autopairs, integrates with both cmp and treesitter
    use { "numToStr/Comment.nvim" }
    use { "JoosepAlviste/nvim-ts-context-commentstring" }
    use { "kyazdani42/nvim-web-devicons" }
    use { "kyazdani42/nvim-tree.lua" }
    use { "akinsho/bufferline.nvim" }
    use { "moll/vim-bbye" }
    use { "nvim-lualine/lualine.nvim" }
    use { "ahmedkhalf/project.nvim" }
    use { "lewis6991/impatient.nvim" }
    use { "lukas-reineke/indent-blankline.nvim" }
    use { "goolord/alpha-nvim" }
    use { "folke/which-key.nvim" }
    use { "ThePrimeagen/harpoon" }

    -- Terminal stuff
    use { "akinsho/toggleterm.nvim" }

    -- Colorschemes
    use { "lunarvim/Onedarker.nvim" }
    use { "ellisonleao/gruvbox.nvim" }
    use { "navarasu/onedark.nvim" }

    -- cmp plugins
    use { "hrsh7th/nvim-cmp" }         -- The completion plugin
    use { "hrsh7th/cmp-buffer" }       -- buffer completions
    use { "hrsh7th/cmp-path" }         -- path completions
    use { "saadparwaiz1/cmp_luasnip" } -- snippet completions
    use { "hrsh7th/cmp-nvim-lsp" }
    use { "hrsh7th/cmp-nvim-lua" }

    -- snippets
    use { "L3MON4D3/LuaSnip", commit = "79b2019c68a2ff5ae4d732d50746c901dd45603a" }             --snippet engine
    use { "rafamadriz/friendly-snippets", commit = "d27a83a363e61009278b6598703a763ce9c8e617" } -- a bunch of snippets to use

    -- LSP
    use {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
    }
    use { "simrat39/rust-tools.nvim" }

    -- Telescope
    use {
        'nvim-telescope/telescope.nvim',
        requires = { 'nvim-lua/plenary.nvim' }
    }
    use {
        "nvim-telescope/telescope-live-grep-args.nvim",
        config = function()
            require("telescope").load_extension("live_grep_args")
        end }
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    use {
        "nvim-telescope/telescope-frecency.nvim",
        config = function()
            require "telescope".load_extension("frecency")
        end,
        requires = { "kkharji/sqlite.lua" }
    }
    -- Treesitter
    use { "nvim-treesitter/nvim-treesitter", run = ':TSUpdate' }

    -- Debugging
    use { "mfussenegger/nvim-dap" }
    use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } }
    use { "mfussenegger/nvim-dap-python" }
    use { "theHamsta/nvim-dap-virtual-text" }
    use { "nvim-neotest/nvim-nio" }
    use { 'nvim-telescope/telescope-dap.nvim' }
    use { 'ldelossa/nvim-dap-projects' }

    -- Visual tweaks
    use { 'stevearc/dressing.nvim' }
end)
