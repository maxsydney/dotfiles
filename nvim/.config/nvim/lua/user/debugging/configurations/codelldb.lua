-- Set up codelldb adapter here

require('dap').adapters.codelldb = {
    type = 'server',
    port = "13000",
    executable = {
        command = '/home/max/.local/share/nvim/mason/packages/codelldb/codelldb',
        args = { "--port", "13000" },
    }
}

-- Add a default configuration for rust 
require('dap').configurations.rust = {
    {
        name = "Debug file",
        type = "codelldb",
        request = "launch",
        program = function()
            local default_executable = vim.fn.getcwd() .. '/target/debug/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
            if vim.fn.filereadable(default_executable) then
                return default_executable
            else
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
    },
}
