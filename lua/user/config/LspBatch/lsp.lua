-- ===============================
-- 0. Disable line numbers
-- ===============================
-- vim.wo.number = false
-- vim.wo.relativenumber = false

-- ===============================
-- 1. on_attach: keymaps
-- ===============================
local function on_attach(_, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }
    local map = vim.keymap.set
    map("n", "gd", vim.lsp.buf.definition, opts)
    map("n", "K", vim.lsp.buf.hover, opts)
    map("n", "gr", vim.lsp.buf.references, opts)
    map("n", "<leader>rn", vim.lsp.buf.rename, opts)
    map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    map("n", "<leader>f_", function() vim.lsp.buf.format { async = true } end, opts)
end





-- ===============================
-- 2. Capabilities (for cmp-nvim-lsp)
-- ===============================
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- For nvim-cmp Uncomment this :
pcall(function()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
end)





-- For blink-cmp Uncomment this :
-- capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)


-- ===============================
-- 3. Default config
-- ===============================
local default_config = {
    on_attach = on_attach,
    capabilities = capabilities,
}

local servers = {
    --  Don't add anything here go to lua/user/config/LspConfig/ & make a file there or edit existibg
}

-- Configure LSP UI with borders
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover,
    {
        border = "rounded", -- Options: "single", "double", "rounded", "solid", "shadow"
    }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    {
        border = "rounded",
    }
)

-- Also add borders to diagnostic floating windows
vim.diagnostic.config({
    float = {
        border = "rounded",
    },
})


-- Remove automatic triggering characters
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.server_capabilities.signatureHelpProvider then
            client.server_capabilities.signatureHelpProvider.triggerCharacters = {}
        end
    end,
})

-- Add manual keybind (optional - trigger with <C-k> in insert mode)
vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })

-- ===============================
-- Setup all Servers
-- ===============================
for server, opts in pairs(servers) do
    vim.lsp.config(server, vim.tbl_deep_extend("force", default_config, opts))
end
vim.keymap.set("n", "<leader>la", vim.diagnostic.open_float, { desc = "Show Diagnostics" })

-- 6. Enable all 🎉
vim.lsp.enable(vim.tbl_keys(servers))


-- ======================================
--
-- ======================================




-- ===============================
-- Disable automatic signature help
-- ===============================
-- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
--     vim.lsp.handlers.signature_help, {
--         border = "rounded",
--         silent = true,
--         focusable = false,
--     }
-- )



-- 7. Theme (example: dark, easy-to-read)
-- vim.cmd [[
--     colorscheme desert
--     highlight Normal guibg=NONE ctermbg=NONE
-- ]]
