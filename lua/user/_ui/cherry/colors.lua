local theme_manager = require("user._ui.cherry.theme") -- Save the artifact as lua/theme_manager.lua

theme_manager.setup({
    default_theme = "gruvbox", -- Your default theme

    -- Optional: Add custom themes
    themes = {
        gruvbox = {
            contrast = "hard", -- or "soft" or ""
        },
        tokyonight = {
            style = "night", -- storm, moon, day
        },
        -- Add your own themes here
    }
})
