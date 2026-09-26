-- rust-analyzer extensions not exposed by nvim-lspconfig
-- Uses an LspAttach autocmd rather than on_attach so lspconfig's own
-- rust_analyzer on_attach (which defines :LspCargoReload) isn't overridden.

-- Expand the macro under the cursor recursively and show it in a split
local function expand_macro(client, bufnr)
    local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
    client:request("rust-analyzer/expandMacro", params, function(err, result)
        if err then
            vim.notify("Expand macro failed: " .. tostring(err.message or err), vim.log.levels.ERROR)
            return
        end
        if result == nil then
            vim.notify("No macro under cursor", vim.log.levels.WARN)
            return
        end

        local lines = { "// Recursive expansion of " .. result.name .. "! macro", "" }
        vim.list_extend(lines, vim.split(result.expansion, "\n"))

        vim.cmd("vsplit")
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_win_set_buf(0, buf)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        vim.bo[buf].filetype = "rust"
        vim.bo[buf].modifiable = false
        vim.bo[buf].bufhidden = "wipe"
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, nowait = true })
    end, bufnr)
end

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client or client.name ~= "rust_analyzer" then
            return
        end

        local bufnr = args.buf
        vim.api.nvim_buf_create_user_command(bufnr, "RustExpandMacro", function()
            expand_macro(client, bufnr)
        end, { desc = "Recursively expand the macro under the cursor" })

        vim.keymap.set("n", "<leader>rm", function()
            expand_macro(client, bufnr)
        end, { buffer = bufnr, silent = true, desc = "Expand macro" })
    end,
})
