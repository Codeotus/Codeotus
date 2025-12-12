-- ~/.config/nvim/lua/user/UI/focus.lua
local ok, focus = pcall(require, "focus")
if not ok then
    return
end

focus.setup({
    enable = true,      -- Globally enable Focus
    commands = true,    -- Enable Focus commands
    autoresize = {
        enable = true,  -- Auto-resize splits
        width = 0,      -- 0 = no max width
        height = 0,     -- 0 = no max height
        minwidth = 20,  -- Min width a split can shrink to
        minheight = 10, -- Min height a split can shrink to
    },
    ui = {
        number = false,         -- Show absolute line numbers in active window
        relativenumber = false, -- Relative numbers in active window
        hybridnumber = false,   -- Hybrid line numbers
        cursorline = true,      -- Highlight cursor line only in active window
        cursorcolumn = false,   -- No cursor column
        signcolumn = true,      -- Always show signcolumn in active window
    },
    bufnew = false,             -- Don’t auto-resize on new empty buffer
})

-- ###################
-- Important Thing
-- ###################
-- ~/.config/nvim/lua/user/UI/ui-autocmds.lua

-- Disable line numbers and gutter in UI plugins where it's distracting
vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        -- File explorers
        "neo-tree",
        "NvimTree",

        -- Diagnostics / problems
        -- "Trouble",

        -- Pickers
        "TelescopePrompt",
        "TelescopeResults",
        "TelescopePreview",

        -- Notifications / UI layers
        "notify",
        "snacks_picker",
        "snacks_input",
        "snacks_select",

        -- Debugging
        "dapui_*",

        -- Terminal
        "toggleterm",

        -- Dashboard / session managers
        "dashboard",
        "alpha",

        -- Package/plugin managers
        "lazy",
        "mason",
    },
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.cursorline = false
        vim.opt_local.signcolumn = "no"
    end,
})

-- ✅ Explicit default for editing buffers
vim.api.nvim_create_autocmd("BufWinEnter", {
    callback = function()
        local ft = vim.bo.filetype
        -- Skip UI-only buffers (so they stay clean)
        local ui_ft = {
            neo_tree = true,
            NvimTree = true,
            Trouble = true,
            TelescopePrompt = true,
            TelescopeResults = true,
            TelescopePreview = true,
            noice = true,
            notify = true,
            snacks_picker = true,
            snacks_input = true,
            snacks_select = true,
            toggleterm = true,
            dashboard = true,
            alpha = true,
            lazy = true,
            mason = true,
        }
        if not ui_ft[ft] and not ft:match("^dapui_") then
            -- Normal editing buffers = clean, useful numbers
            vim.opt_local.number = true
            vim.opt_local.relativenumber = false -- set to true if you like hybrid navigation
            vim.opt_local.cursorline = true
            vim.opt_local.signcolumn = "yes"
        end
    end,
})


-- Equalise all splits (like :wincmd =)
vim.api.nvim_create_user_command("FocusEqualise", function()
    vim.cmd("wincmd =")
end, {})

-- Maximise current split (temporarily hide others)
vim.api.nvim_create_user_command("FocusMaximise", function()
    vim.cmd("only")
end, {})

-- Cycle split layouts (just rotates vertical ↔ horizontal)
vim.api.nvim_create_user_command("FocusSplitCycle", function()
    -- if there's only one window, do nothing
    if vim.fn.winnr('$') == 1 then return end

    -- try to rotate splits
    vim.cmd("wincmd r")
end, {})


vim.keymap.set("n", "<leader>ft", ":FocusToggle<CR>", { desc = "Toggle Focus (auto-resize splits)" })
vim.keymap.set("n", "<leader>fe", ":FocusEqualise<CR>", { desc = "Equalise splits" })
vim.keymap.set("n", "<leader>fm", ":FocusMaximise<CR>", { desc = "Maximise current split" })
vim.keymap.set("n", "<leader>fc", ":FocusSplitCycle<CR>", { desc = "Cycle split layouts" })
