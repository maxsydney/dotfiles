--
-- Configure DAP and associated UI
--
local dap, dapui = require("dap"), require("dapui")

-- Launch dap-ui on dap events
dap.listeners.before.attach.dapui_config = function()
    dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
    dapui.open()
end
--[[ dap.listeners.before.event_terminated.dapui_config = function() ]]
--[[     dapui.close() ]]
--[[ end ]]
--[[ dap.listeners.before.event_exited.dapui_config = function() ]]
--[[     dapui.close() ]]
--[[ end ]]

dapui.setup(
    {
        controls = {
            element = "repl",
            enabled = true,
            icons = {
                disconnect = "",
                pause = "",
                play = "",
                run_last = "",
                step_back = "",
                step_into = "",
                step_out = "",
                step_over = "",
                terminate = ""
            }
        },
        element_mappings = {},
        expand_lines = true,
        floating = {
            border = "single",
            mappings = {
                close = { "q", "<Esc>" }
            }
        },
        force_buffers = true,
        icons = {
            collapsed = "",
            current_frame = "",
            expanded = ""
        },
        layouts = { {
            elements = { {
                id = "scopes",
                size = 0.25
            }, {
                id = "breakpoints",
                size = 0.25
            }, {
                id = "stacks",
                size = 0.25
            }, {
                id = "watches",
                size = 0.25
            } },
            position = "left",
            size = 40
        }, {
            elements = { {
                id = "repl",
                size = 0.5
            }, {
                id = "console",
                size = 0.5
            } },
            position = "bottom",
            size = 10
        } },
        mappings = {
            edit = "e",
            expand = { "<CR>", "<2-LeftMouse>" },
            open = "o",
            remove = "d",
            repl = "r",
            toggle = "t"
        },
        render = {
            indent = 1,
            max_value_lines = 100
        }
    }
)

-- Set debugger keymaps
vim.keymap.set('n', '<F5>', function()
    vim.cmd("NvimTreeClose")
    dap.continue()
end)
vim.keymap.set('n', '<F17>', function()
    dap.terminate()
    dapui.close()
    vim.cmd("NvimTreeOpen")
end)
vim.keymap.set('n', '<S-F5>', function()
    dap.terminate()
    dapui.close()
    vim.cmd("NvimTreeOpen")
end)

-- Duplicate for mac os
vim.keymap.set('n', '<S-F5>', function()
    dap.terminate()
    dapui.close()
end)

vim.keymap.set('n', '<F10>', function() dap.step_over() end)
vim.keymap.set('n', '<F11>', function() dap.step_into() end)
vim.keymap.set('n', '<F23>', function() dap.step_out() end)
-- Duplicate for mac os
vim.keymap.set('n', '<S-F11>', function() dap.step_out() end)
vim.keymap.set('n', '<Leader>db', function() dap.toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>DB', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end)
vim.keymap.set('n', '<Leader>lp',
    function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set('n', '<Leader>dr', function() dap.repl.open() end)
vim.keymap.set('n', '<Leader>dl', function() dap.run_last() end)
vim.keymap.set({ 'n', 'v' }, '<Leader>dh', function()
    require('dap.ui.widgets').hover()
end)
vim.keymap.set({ 'n', 'v' }, '<Leader>dp', function()
    require('dap.ui.widgets').preview()
end)
vim.keymap.set('n', '<Leader>df', function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.frames)
end)
--[[ vim.keymap.set('n', '<Leader>df', function() require 'telescope'.extensions.dap.frames {} end) ]]
vim.keymap.set('n', '<Leader>ds', function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.scopes)
end)

-- For closing floating DAP windows with q
vim.api.nvim_create_autocmd("FileType", {
    pattern = "dap-float",
    callback = function()
        vim.keymap.set('n', 'q', function()
            vim.api.nvim_win_close(0, false)
        end)
    end
})
