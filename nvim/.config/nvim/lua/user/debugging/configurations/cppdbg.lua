-- Basic adapter configuration for cppdbg
local mason_registry = require("mason-registry")
local cpptools = mason_registry.get_package("cpptools")

-- Check if cpptools is installed
if not cpptools:is_installed() then
    vim.notify("cpptools is not installed. Run :MasonInstall cpptools", vim.log.levels.warn)
    return
end

local has_cpptools = mason_registry.is_installed("cpptools")
if not has_cpptools then
    print("cpptools is not installed. Run :MasonInstall cpptools")
    return
end

-- Only proceed if cpptools is installed
local mason_path = vim.fn.stdpath("data") .. "/mason"
local adapter_path = mason_path .. "/bin/OpenDebugAD7"
require("dap").adapters.cppdbg = {
    id = 'cppdbg',
    type = 'executable',
    command = adapter_path
}
