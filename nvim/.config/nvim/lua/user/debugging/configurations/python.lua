-- Very simple configuration using dap-python
local handle = io.popen("which python3")
local pythonEnv = handle:read("*a")
handle:close()


local status_ok, dap_python = pcall(require, "dap-python")
if not status_ok then
    print("Failed to load dap python")
	return
end

dap_python.setup(pythonEnv)
