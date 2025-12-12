require("lspconfig").clangd.setup({
    cmd = {
        "clangd",
        "--background-index"
    },
    filetypes = { "c", "cpp" },
    -- settings is for LSP-specific configuration only
    settings = {}
})
