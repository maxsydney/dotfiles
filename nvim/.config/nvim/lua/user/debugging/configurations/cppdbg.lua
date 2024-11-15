-- Configuration set with VS code launch.json
require("dap").adapters.cppdbg = {
    id = 'cppdbg',
    type = 'executable',
    command = string.format("%s/.local/share/nvim/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7", os.getenv("HOME")),
}
