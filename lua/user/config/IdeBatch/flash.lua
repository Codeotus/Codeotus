require("flash").setup({
    -- Labels to use for jump targets
    labels = "asdfghjklqwertyuiopzxcvbnm",

    -- Search settings
    search = {
        -- Search mode: "exact", "search", or "fuzzy"
        mode = "exact",
        -- Behave like `incsearch`
        incremental = false,
        -- When `false`, find only matches in the given direction
        forward = true,
        -- Wrap search around the file
        wrap = true,
        -- Maximum number of matches
        max_length = false,
    },

    -- Jump settings
    jump = {
        -- Jump position: "start", "end", or "range"
        pos = "start",
        -- Automatically jump when there is only one match
        autojump = false,
        -- Clear highlight after jump
        nohlsearch = false,
    },

    -- Label settings
    label = {
        -- Show labels before or after the match
        before = true,
        after = true,
        -- Style: "inline", "overlay", or "eol"
        style = "overlay",
        -- Reuse labels across multiple matches
        reuse = "lowercase",
        -- Minimum pattern length to show labels
        min_pattern_length = 0,
    },

    -- Highlight settings
    highlight = {
        -- Show a backdrop with hl FlashBackdrop
        backdrop = true,
    },

    -- Mode-specific settings
    modes = {
        -- Options for character search (like f, F, t, T)
        char = {
            enabled = true,
            jump_labels = true,
            multi_line = true,
        },
        -- Options for search using `/` or `?`
        search = {
            enabled = true,
        },
        -- Options for Treesitter selections
        treesitter = {
            labels = "abcdefghijklmnopqrstuvwxyz",
            jump = { pos = "range" },
        },
    },

    -- Prompt settings
    prompt = {
        enabled = true,
        prefix = { { "Enter: ", "FlashPromptIcon" } },
    },
})

-- Default jump
vim.keymap.set({ "n", "x", "o" }, "l", function() require("flash").jump() end, { desc = "Flash" })

-- Treesitter search
vim.keymap.set({ "n", "x", "o" }, "T", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })

-- Remote operation (like using flash with `d`, `c`, etc.)
vim.keymap.set("o", "r", function() require("flash").remote() end, { desc = "Remote Flash" })

-- Treesitter search (select nodes)
vim.keymap.set({ "o", "x" }, "R", function() require("flash").treesitter_search() end, { desc = "Treesitter Search" })

-- Toggle flash in regular search
vim.keymap.set({ "c" }, "<c-s>", function() require("flash").toggle() end, { desc = "Toggle Flash Search" })
