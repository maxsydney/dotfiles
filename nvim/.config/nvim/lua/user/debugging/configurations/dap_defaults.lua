-- Shared factory for a generic codelldb launch config fallback, used by
-- cpp.lua and rust.lua so the prompt/cache logic isn't duplicated per language.
local M = {}

-- default_subdir: where the built executable usually lives relative to cwd,
-- e.g. "build" for C/C++ (CMake) or "target/debug" for Rust (Cargo).
function M.new(default_subdir)
    -- Remembers the last path entered per cwd so repeat launches
    -- (and dap.run_last) don't require retyping it.
    local last_program_by_cwd = {}

    local function prompt_for_program()
        local cwd = vim.fn.getcwd()
        local default = last_program_by_cwd[cwd]
        if not default then
            default = default_subdir .. "/" .. vim.fn.fnamemodify(cwd, ":t")
        end
        local program = vim.fn.input("Path to executable (relative to project root): ", default, "file")
        last_program_by_cwd[cwd] = program
        if not vim.startswith(program, "/") then
            program = cwd .. "/" .. program
        end
        return program
    end

    local function config(opts)
        opts = opts or {}
        return {
            name = opts.name or "Launch",
            type = "codelldb",
            request = "launch",
            program = opts.program or prompt_for_program,
            cwd = opts.cwd or "${workspaceFolder}",
            args = opts.args or {},
            stopOnEntry = false,
        }
    end

    -- opts.configs lets a project define multiple launch targets at once,
    -- e.g. { { name = "tests", program = ... }, { name = "app", program = ... } }
    return function(filetypes, opts)
        opts = opts or {}
        local configs = opts.configs or { opts }
        local dap_configs = {}
        for _, cfg in ipairs(configs) do
            table.insert(dap_configs, config(cfg))
        end
        for _, ft in ipairs(filetypes) do
            require("dap").configurations[ft] = dap_configs
        end
    end
end

return M
