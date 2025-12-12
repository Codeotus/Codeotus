require("lspconfig").lua_ls.setup({
    cmd = {
        "lua-language-server"
    },
    filetypes = { "lua" },
    -- settings is for LSP-specific configuration only
    handlers = {
        ["$/progress"] = function() end,
    },
    settings = {
        Lua = {
            runtime = {
                version = "Lua 5.4",
            },
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                checkThirdParty = false,
                library = { vim.env.VIMRUNTIME .. "/lua" },
                -- reduces workspace scanning massively
                maxPreload = 2000,
                preloadFileSize = 500,
            },
            telemetry = { enable = false },
        },
    },
})
