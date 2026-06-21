-- Generic codelldb launch config for C/C++.
-- Loaded as a fallback default before nvim-dap-projects searches for a
-- project-specific .nvim-dap.lua. If a project defines its own
-- dap.configurations.cpp, that assignment runs later and overrides this.
local setup = require("user.debugging.configurations.dap_defaults").new("build")

local M = {}

function M.setup(opts)
    setup({ "cpp", "c" }, opts)
end

return M
