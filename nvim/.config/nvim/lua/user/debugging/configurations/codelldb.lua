local mason_registry = require("mason-registry")
local codelldb_path = mason_registry.get_package("codelldb"):get_install_path() .. "/codelldb"

require('dap').adapters.codelldb = {
    type = 'server',
    port = "13000",
    executable = {
        command = codelldb_path,
        args = { "--port", "13000" },
    }
}
