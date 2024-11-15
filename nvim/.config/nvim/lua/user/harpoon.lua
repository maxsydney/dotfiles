
local status_ok, harpoon = pcall(require, "harpoon")
if not status_ok then
  print("Failed to load plugin harpoon")
  return
end

harpoon.setup({
  global_settings = {
    -- sets the marks upon calling `toggle` on the ui, instead of require `:w`.
    save_on_toggle = false,

    -- saves the harpoon file upon every change. disabling is unrecommended.
    save_on_change = true,

    -- sets harpoon to run the command immediately as it's passed to the terminal when calling `sendCommand`.
    enter_on_sendcmd = false,

    -- closes any tmux windows harpoon that harpoon creates when you close Neovim.
    tmux_autoclose_windows = false,

    -- filetypes that you want to prevent from adding to the harpoon list menu.
    excluded_filetypes = { "harpoon" },

    -- set marks specific to each git branch inside git repository
    mark_branch = false,
 }
})

-- TODO: Define keymaps here are registert with whichkey?
-- Set some keymaps
local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

keymap("n", "<M-1>", ":lua require('harpoon.ui').nav_file(1) <CR>", opts)
keymap("n", "<M-2>", ":lua require('harpoon.ui').nav_file(2) <CR>", opts)
keymap("n", "<M-3>", ":lua require('harpoon.ui').nav_file(3) <CR>", opts)
keymap("n", "<M-4>", ":lua require('harpoon.ui').nav_file(4) <CR>", opts)
keymap("n", "<M-n>", ":lua require('harpoon.ui').nav_next() <CR>", opts)
keymap("n", "<M-p>", ":lua require('harpoon.ui').nav_prev() <CR>", opts)
