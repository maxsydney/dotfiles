-- rust-analyzer root_dir override. Lives in after/ because nvim-lspconfig's
-- lsp/rust_analyzer.lua loads after lsp/ and would otherwise replace it.

-- Setting root_dir below replaces nvim-lspconfig's, so load theirs to delegate to.
local lspconfig_root_dir
for _, path in ipairs(vim.api.nvim_get_runtime_file("lsp/rust_analyzer.lua", true)) do
    if path:find("nvim-lspconfig", 1, true) then
        lspconfig_root_dir = dofile(path).root_dir
    end
end

return {
    root_dir = function(bufnr, on_dir)
        -- Diffview buffers (diffview:///<repo>/.git/:0:/<file>) walk up to the
        -- repo's top-level Cargo.toml, which starts a second rust-analyzer on
        -- the whole outer workspace. Not calling on_dir skips attaching.
        if vim.api.nvim_buf_get_name(bufnr):match("^diffview://") then
            return
        end
        -- Files with no Cargo.toml, rust-project.json or .git above them (e.g.
        -- git difftool's /tmp/git-blob-*/ copies) resolve to a nil root, which
        -- would start an extra rootless rust-analyzer. Skip those.
        lspconfig_root_dir(bufnr, function(dir)
            if dir then
                on_dir(dir)
            end
        end)
    end,
}
