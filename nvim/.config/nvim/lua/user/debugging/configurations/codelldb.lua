local mason_registry = require("mason-registry")
local codelldb = mason_registry.get_package("codelldb")

-- check if it's installed first
if not codelldb:is_installed() then
    vim.notify("codelldb is not installed. run :masoninstall codelldb", vim.log.levels.warn)
    return
end

local mason_path = vim.fn.stdpath("data") .. "/mason"
local codelldb_path = mason_path .. "/bin/codelldb"

require('dap').adapters.codelldb = {
    type = 'server',
    port = "13000",
    executable = {
        command = codelldb_path,
        args = { "--port", "13000" },
    }
}
