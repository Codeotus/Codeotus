-- 1. LUASNIP SETUP
-- ====================
require('luasnip.loaders.from_vscode').lazy_load()

-- ====================
-- 2. LSP CAPABILITIES FOR CMP
-- ====================
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Enable maximum snippet support
capabilities.textDocument.completion.completionItem = {
    snippetSupport = true,
    resolveSupport = {
        properties = {
            'documentation',
            'detail',
            'additionalTextEdits',
        }
    },
    insertReplaceSupport = true,
    labelDetailsSupport = true,
    commitCharactersSupport = true,
    documentationFormat = { 'markdown', 'plaintext' },
    deprecatedSupport = true,
    preselectSupport = true,
}



--  For blink-cmp Uncomment this :
local blink_capabilities = require('blink.cmp').get_lsp_capabilities()

-- Enable maximum snippet support
blink_capabilities.textDocument.completion.completionItem = {
    snippetSupport = true,
    resolveSupport = {
        properties = {
            'documentation',
            'detail',
            'additionalTextEdits',
        }
    },
    insertReplaceSupport = true,
    labelDetailsSupport = true,
    commitCharactersSupport = true,
    documentationFormat = { 'markdown', 'plaintext' },
    deprecatedSupport = true,
    preselectSupport = true,
}

-- vim.lsp.handlers["textDocument/signatureHelp"] = function() end
-- vim.lsp.handlers["textDocument/documentHighlight"] = function() end

-- local servers = {
--     --  Don't add anything here go to lua/user/config/LspConfig/ & make a file there or edit existing
-- }
-- vim.lsp.enable(vim.tbl_keys(servers))


-- Set global border style for LSP floating windows
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover, {
        border = "rounded",
        max_width = 80,
        max_height = 20,
    }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help, {
        border = "rounded",
        max_width = 80,
        max_height = 20,
    }
)

-- Set default border for all floating windows
vim.diagnostic.config({
    float = {
        border = "rounded",
        max_width = 80,
        max_height = 20,
    }
})

-- Global border style (affects other floating windows too)
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or "rounded"
    opts.max_width = opts.max_width or 80
    opts.max_height = opts.max_height or 20
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- Keybindings for LSP
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }

        -- K for hover documentation
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)

        -- H for signature help
        vim.keymap.set('n', 'H', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, opts) -- Also in insert mode
    end,
})
