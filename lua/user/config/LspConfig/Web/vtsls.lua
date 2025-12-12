require("lspconfig").vtsls.setup({
    cmd = { "vtsls", "--stdio" },
    filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
    },
    root_dir = require("lspconfig").util.root_pattern(
        "package.json",
        "tsconfig.json",
        "jsconfig.json",
        ".git"
    ),
    single_file_support = true,

    settings = {
        vtsls = {
            autoUseWorkspaceTsdk = true,
            experimental = {
                completion = {
                    enableServerSideFuzzyMatch = true,
                    entriesLimit = 3000,
                },
            },
        },
        typescript = {
            updateImportsOnFileMove = { enabled = "always" },
            suggest = {
                completeFunctionCalls = true,
                includeCompletionsForImportStatements = true,
                includeAutomaticOptionalChainCompletions = true,
            },
            preferences = {
                importModuleSpecifier = "relative",
                includePackageJsonAutoImports = "auto",
                quoteStyle = "single",
            },
            inlayHints = {
                parameterNames = { enabled = "all" },
                parameterTypes = { enabled = true },
                variableTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                enumMemberValues = { enabled = true },
            },
            format = {
                enable = true,
                semicolons = "insert",
                insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = true,
            },
            referencesCodeLens = {
                enabled = true,
                showOnAllFunctions = true,
            },
            implementationsCodeLens = {
                enabled = true,
            },
        },
        javascript = {
            updateImportsOnFileMove = { enabled = "always" },
            suggest = {
                completeFunctionCalls = true,
                includeCompletionsForImportStatements = true,
                includeAutomaticOptionalChainCompletions = true,
            },
            preferences = {
                importModuleSpecifier = "relative",
                includePackageJsonAutoImports = "auto",
                quoteStyle = "single",
            },
            inlayHints = {
                parameterNames = { enabled = "all" },
                parameterTypes = { enabled = true },
                variableTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                enumMemberValues = { enabled = true },
            },
            format = {
                enable = true,
                semicolons = "insert",
                insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = true,
            },
            referencesCodeLens = {
                enabled = true,
                showOnAllFunctions = true,
            },
            implementationsCodeLens = {
                enabled = true,
            },
        },
    },

    on_attach = function(client, bufnr)
        -- Enable inlay hints if available
        if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end

        -- Custom keymaps (REMOVED gD/declaration - not supported)
        local opts = { buffer = bufnr, silent = true }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

        -- Organize imports
        vim.keymap.set("n", "<leader>oi", function()
            vim.lsp.buf.code_action({
                apply = true,
                context = {
                    only = { "source.organizeImports" },
                    diagnostics = {},
                },
            })
        end, opts)

        -- Remove unused imports
        vim.keymap.set("n", "<leader>ru", function()
            vim.lsp.buf.code_action({
                apply = true,
                context = {
                    only = { "source.removeUnused" },
                    diagnostics = {},
                },
            })
        end, opts)
    end,

    flags = {
        allow_incremental_sync = true,
        debounce_text_changes = 150,
    },
})
