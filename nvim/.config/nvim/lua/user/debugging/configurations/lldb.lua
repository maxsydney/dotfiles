-- Configuration set with VS code launch.json

require("dap").adapters.lldb = {
    id = 'lldb',
    type = 'executable',
    command = '/usr/local/opt/llvm/bin/lldb-vscode',
}

