-- rust-analyzer configuration
-- (root_dir override lives in after/lsp/rust_analyzer.lua)
return {
    settings = {
        ["rust-analyzer"] = {
            cargo = { targetDir = true },
            check = { command = "clippy", allTargets = false },
            inlayHints = {
                maxLength = 15,
                typeHints = {
                    -- Closures here often take heavily-generic Dimensioned types
                    -- (Quantity<dyn Dimension<L, M, T, I, Th, N, J, Kind>>). The
                    -- inferred-parameter-type hint prints the whole thing inline
                    -- per closure param, and maxLength only truncates individual
                    -- fragments of it, not the total line.
                    hideClosureParameter = true,
                },
            },
        },
    },
}
