return {
    "mrcjkb/rustaceanvim",
    version = "^6",
    ft = "rust",
    config = function()
        vim.g.rustaceanvim = {
            -- Plugin configuration
            tools = {
                inlay_hints = {
                    auto = true,
                },
            },
            -- LSP configuration
            server = {
                on_attach = function(_, bufnr)
                    -- Your keybindings here
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
                end,
                default_settings = {
                    ['rust-analyzer'] = {
                        cargo = {
                            allFeatures = true,
                        },
                        checkOnSave = {
                            command = "clippy",
                        },
                    },
                },
            },
            -- DAP configuration
            dap = {},
        }
    end,
}
