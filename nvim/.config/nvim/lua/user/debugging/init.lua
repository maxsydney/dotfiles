require("user.debugging.dap")
require("user.debugging.virtual-text")
require("user.debugging.configurations.cppdbg")
require("user.debugging.configurations.python")
require("user.debugging.configurations.lldb")
require("user.debugging.configurations.codelldb")

-- Load nvim-dap-projects last to allow for project specific configuration
require('nvim-dap-projects').search_project_config()
