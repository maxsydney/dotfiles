-- Basic adapter configuration for cppdbg
local mason_registry = require("mason-registry")
local cpptools_path = mason_registry.get_package("cpptools"):get_install_path()
local adapter_path = cpptools_path .. "/extension/debugAdapters/bin/OpenDebugAD7"

require("dap").adapters.cppdbg = {
    id = 'cppdbg',
    type = 'executable',
    command = adapter_path
}
