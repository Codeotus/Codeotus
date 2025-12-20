-- Minimal blink.cmp + LSP setup for maximum snippet expansion
-- Install: saghen/blink.cmp, neovim/nvim-lspconfig

-- ====================
-- 1. BLINK.CMP SETUP
-- ====================
require('blink.cmp').setup({
    appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = 'mono'
    },

    completion = {
        list = {
            max_items = 6, -- Show only 5-6 items
        },

        accept = {
            auto_brackets = {
                enabled = true,
            },
        },

        menu = {
            scrollbar = true,
            draw = {
                columns = {
                    { "label",     gap = 1 },
                    { "kind_icon", "kind", gap = 1 }
                },
            },
        },

        documentation = {
            auto_show = true,
            auto_show_delay_ms = 0,
            treesitter_highlighting = true,

            window = {
                max_width = 50,
                max_height = 12,
                scrollbar = true,

                -- Force to right side only (good for vertical splits)
                direction_priority = {
                    menu_north = { 'e' }, -- east (right)
                    menu_south = { 'e' },
                },

                -- Or force below menu (good for wide screens)
                -- direction_priority = {
                --     menu_north = { 'n' }, -- north (above)
                --     menu_south = { 's' }, -- south (below)
                -- },
            },
        },

        ghost_text = {
            enabled = true,
        },
    },

    sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
    },


    keymap = {
        preset = 'default',
        ['<C-space>'] = { 'show', 'show_documentation' },
        ['<C-e>'] = { 'hide', 'hide_documentation' },
        ['<C-k>'] = { 'show_documentation', 'hide_documentation' }, -- Toggle docs with Ctrl+k
        ['<CR>'] = { 'accept', 'fallback' },
        ['<Tab>'] = { 'snippet_forward', 'select_next', 'fallback' },
        ['<S-Tab>'] = { 'snippet_backward', 'select_prev', 'fallback' },
        ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },   -- Scroll docs up
        ['<C-d>'] = { 'scroll_documentation_down', 'fallback' }, -- Scroll docs down
    },


    signature = {
        enabled = false,
    },
})

-- ====================
-- 2. LSP CAPABILITIES
-- ====================
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


vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        vim.api.nvim_set_hl(0, "LspReferenceText", {})
        vim.api.nvim_set_hl(0, "LspReferenceRead", {})
        vim.api.nvim_set_hl(0, "LspReferenceWrite", {})
    end,
})
