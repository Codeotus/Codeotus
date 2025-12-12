-- ─────────────────────────────────────────────
-- Enhanced Smart Bufferline
-- Features:
-- - Auto theme switching on colorscheme change
-- - Uses editor background for all buffers
-- - Visible separator lines between buffers
-- - Toggle globally with :GBT
-- - Responsive for all screen sizes
-- - Minimal diagnostic indicators [!]
-- - Dot indicators: Yellow (unsaved) → Green (saved)
-- - No italic text
-- - Bright text even with same background
-- - Optimized spacing and buffer management
-- ─────────────────────────────────────────────

local bufferline = require("bufferline")

-- ─────────────────────────────────────────────
-- Global toggle state
-- ─────────────────────────────────────────────
_G.bufferline_enabled = true

-- ─────────────────────────────────────────────
-- Main setup function
-- ─────────────────────────────────────────────
local function setup_bufferline()
    if not _G.bufferline_enabled then
        -- Hide bufferline
        vim.o.showtabline = 0
        -- Clear bufferline display
        pcall(function()
            bufferline.setup({
                options = {
                    always_show_bufferline = false,
                }
            })
        end)
        return
    end

    bufferline.setup({
        options = {
            mode = "buffers",
            themable = true,

            -- Separators (vertical lines between buffers)
            separator_style = { '│', '│' }, -- Thin vertical line separator

            -- Diagnostic settings
            diagnostics = "nvim_lsp",

            -- Close button
            close_command = "bdelete! %d",
            right_mouse_command = "bdelete! %d",
            left_mouse_command = "buffer %d",
            middle_mouse_command = nil,

            -- Icons and indicators
            show_buffer_icons = true,
            show_buffer_close_icons = true,
            show_close_icon = false,
            show_tab_indicators = true,
            show_duplicate_prefix = true,

            -- Better space management
            enforce_regular_tabs = false,
            always_show_bufferline = true,

            -- Responsive sizing
            max_name_length = 18,
            tab_size = 18,
            truncate_names = true,

            -- Number style
            numbers = "none",

            -- Custom indicator icon
            indicator = {
                icon = '▎',
                style = 'icon',
            },

            -- Modified icon (custom dot)
            modified_icon = '●',

            -- Buffer management
            buffer_close_icon = '󰅖',
            close_icon = '󰅙',
            left_trunc_marker = '󰁍',
            right_trunc_marker = '󰁔',

            -- Offsets for file explorers
            offsets = {
                {
                    filetype = "NvimTree",
                    text = "󰙅 File Explorer",
                    text_align = "center",
                    separator = true,
                },
                {
                    filetype = "neo-tree",
                    text = "󰙅 File Explorer",
                    text_align = "center",
                    separator = true,
                },
            },

            -- Hover actions
            hover = {
                enabled = true,
                delay = 200,
                reveal = { 'close' }
            },

            -- Sorting
            sort_by = 'insert_after_current',
        },

    })

    vim.o.showtabline = 2

    -- Set up keymaps after bufferline is configured
    local keymap = vim.keymap.set
    local opts = { noremap = true, silent = true }

    -- Navigate buffers
    keymap("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", opts)
    keymap("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", opts)

    -- Move buffers
    keymap("n", "<leader>bl", "<cmd>BufferLineMoveNext<CR>", opts)
    keymap("n", "<leader>bh", "<cmd>BufferLineMovePrev<CR>", opts)

    -- Pick buffer
    keymap("n", "<leader>bp", "<cmd>BufferLinePick<CR>", opts)

    -- Close buffers
    keymap("n", "<leader>bc", function()
        require("bufferline").pick_buffer()
        vim.defer_fn(function()
            vim.cmd("bdelete")
        end, 100)
    end, { desc = "Pick buffer to close" })

    keymap("n", "<leader>bk", function()
        local bufferline_commands = require("bufferline.commands")
        bufferline_commands.close_buffer_with_pick()
    end, { desc = "Pick and close buffer" })

    keymap("n", "<leader>bx", "<cmd>bdelete<CR>", opts)

    -- Close all but current
    keymap("n", "<leader>bo", function()
        local bufferline_commands = require("bufferline.commands")
        bufferline_commands.close_others()
    end, { desc = "Close other buffers" })

    -- Close left/right
    keymap("n", "<leader>bL", function()
        local bufferline_commands = require("bufferline.commands")
        bufferline_commands.close_in_direction("left")
    end, { desc = "Close buffers to the left" })

    keymap("n", "<leader>bR", function()
        local bufferline_commands = require("bufferline.commands")
        bufferline_commands.close_in_direction("right")
    end, { desc = "Close buffers to the right" })

    -- Pin/unpin buffer
    keymap("n", "<leader>bP", function()
        local bufferline_commands = require("bufferline.commands")
        bufferline_commands.toggle_pin()
    end, { desc = "Toggle buffer pin" })
end

-- ─────────────────────────────────────────────
-- Auto-refresh on colorscheme change
-- ─────────────────────────────────────────────
vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("BufferlineThemeSync", { clear = true }),
    callback = function()
        vim.defer_fn(setup_bufferline, 100)
    end,
})

-- ─────────────────────────────────────────────
-- Toggle command :GBT (Global Bufferline Toggle)
-- ─────────────────────────────────────────────
vim.api.nvim_create_user_command("GBT", function()
    _G.bufferline_enabled = not _G.bufferline_enabled

    if _G.bufferline_enabled then
        -- Re-enable and refresh
        setup_bufferline()
        vim.cmd('redraw')
        print("✓ Bufferline enabled")
    else
        -- Disable
        vim.o.showtabline = 0
        pcall(function()
            bufferline.setup({
                options = {
                    always_show_bufferline = false,
                }
            })
        end)
        vim.cmd('redraw')
        print("✗ Bufferline disabled")
    end
end, { desc = "Toggle bufferline globally" })

-- ─────────────────────────────────────────────
-- Manual refresh command
-- ─────────────────────────────────────────────
vim.api.nvim_create_user_command("BufferlineRefresh", setup_bufferline, {
    desc = "Manually refresh bufferline theme"
})

-- Initial setup
setup_bufferline()
