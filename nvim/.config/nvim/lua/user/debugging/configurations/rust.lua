-- Generic codelldb launch config for Rust.
-- Loaded as a fallback default before nvim-dap-projects searches for a
-- project-specific .nvim-dap.lua. If a project defines its own
-- dap.configurations.rust, that assignment runs later and overrides this.
local setup = require("user.debugging.configurations.dap_defaults").new("target/debug")

local M = {}

function M.setup(opts)
    setup({ "rust" }, opts)
end

return M
