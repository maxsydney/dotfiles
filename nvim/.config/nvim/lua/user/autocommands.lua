vim.cmd [[
  augroup _general_settings
    autocmd!
    autocmd FileType qf,help,man,lspinfo nnoremap <silent> <buffer> q :close<CR> 
    autocmd TextYankPost * silent! lua vim.highlight.on_yank({higroup = 'Visual', timeout = 150})
    autocmd BufWinEnter * :set formatoptions-=cro
    autocmd FileType qf set nobuflisted
  augroup end

  augroup _git
    autocmd!
    autocmd FileType gitcommit setlocal wrap
    autocmd FileType gitcommit setlocal spell
  augroup end

  augroup _markdown
    autocmd!
    autocmd FileType markdown setlocal wrap
    autocmd FileType markdown setlocal spell
  augroup end

  augroup _auto_resize
    autocmd!
    autocmd VimResized * tabdo wincmd = 
  augroup end

  augroup _alpha
    autocmd!
    autocmd User AlphaReady set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2
  augroup end
]]

-- While Neovim has focus (X11 only): Caps Lock acts as Escape. Neovim never
-- sees the keyboard itself, so this swaps the X key options on focus changes.
-- Only options are touched, so the layout (accents toggled with $mod+Shift+s
-- in i3) is left as-is.
if vim.fn.executable("setxkbmap") == 1 and vim.env.DISPLAY then
    local caps_group = vim.api.nvim_create_augroup("CapsAsEscape", { clear = true })
    local function caps_escape()
        vim.fn.jobstart({ "setxkbmap", "-option", "", "-option", "caps:escape" })
    end
    local function caps_restore()
        vim.fn.jobstart({ "setxkbmap", "-option", "" })
    end
    vim.api.nvim_create_autocmd({ "VimEnter", "FocusGained", "VimResume" }, { group = caps_group, callback = caps_escape })
    vim.api.nvim_create_autocmd({ "FocusLost", "VimSuspend" }, { group = caps_group, callback = caps_restore })
    vim.api.nvim_create_autocmd("VimLeavePre", {
        group = caps_group,
        callback = function()
            vim.fn.system({ "setxkbmap", "-option", "" })
        end,
    })
end
