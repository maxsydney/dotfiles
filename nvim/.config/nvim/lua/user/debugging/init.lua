require("user.debugging.dap")
require("user.debugging.virtual-text")
require("user.debugging.configurations.python")
require("user.debugging.configurations.codelldb")

-- Generic fallback configs. Loaded before the project config so that a
-- project's .nvim-dap.lua can still override dap.configurations.{cpp,rust}.
require("user.debugging.configurations.cpp").setup()
require("user.debugging.configurations.rust").setup()

-- Load project-specific configuration last. Adapters and generic configs
-- are defined system-wide (codelldb.lua, dap-python), so a project's
-- .nvim-dap.lua only needs to add its own dap.configurations entries. We do
-- NOT wipe configurations, so project configs extend the existing table
-- (keeping dap-python's defaults available alongside project-specific ones).
local function load_project_dap_config()
  for _, p in ipairs({ "./.nvim-dap.lua", "./.nvim-dap/nvim-dap.lua", "./.nvim/nvim-dap.lua" }) do
    if vim.fn.filereadable(p) == 1 then
      vim.cmd(":luafile " .. p)
      return
    end
  end
end
load_project_dap_config()

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
