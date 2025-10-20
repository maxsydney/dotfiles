require("user.debugging.dap")
require("user.debugging.virtual-text")
require("user.debugging.configurations.cppdbg")
require("user.debugging.configurations.python")
require("user.debugging.configurations.lldb")
require("user.debugging.configurations.codelldb")

-- Load nvim-dap-projects last to allow for project specific configuration
require('nvim-dap-projects').search_project_config()

-- Auto-reload nvim-dap.lua on save
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = '.nvim-dap.lua',  -- or whatever your project config file is named
  callback = function(ev)
    local ok, err = pcall(dofile, ev.match)
    if ok then
      vim.notify('DAP project config reloaded', vim.log.levels.INFO)
    else
      vim.notify('Error reloading DAP config: ' .. err, vim.log.levels.ERROR)
    end
  end,
  desc = 'Reload project DAP config on save',
})
