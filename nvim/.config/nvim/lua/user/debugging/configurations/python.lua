-- Configuration using dap-python with venv support
local function get_python_path()
    -- First check if there's an active virtual environment
    local venv = os.getenv("VIRTUAL_ENV")
    if venv then
        -- Use the Python from the active virtual environment
        if vim.fn.has("win32") == 1 then
            -- Windows path
            return venv .. "\\Scripts\\python.exe"
        else
            -- Unix path
            return venv .. "/bin/python"
        end
    end

    -- No active venv, try to detect Python path
    local handle = io.popen("which python3 || which python")
    local system_python = handle:read("*a"):gsub("\n$", "")
    handle:close()

    return system_python
end

local status_ok, dap_python = pcall(require, "dap-python")
if not status_ok then
    print("Failed to load dap python")
    return
end

local python_path = get_python_path()
dap_python.setup(python_path)
