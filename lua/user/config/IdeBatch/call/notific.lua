-- Require and setup
require("user.config.IdeBatch.inbuilt.notific").setup({
    enabled = true,
    current_profile = "normal", -- Start with normal profile

    -- Customize profiles if needed
    profiles = {
        quiet = {
            severity_filter = "ERROR", -- Only errors
            source_filter = { "all" }, -- Block all sources
            focus_mode = true,         -- Auto-mute while typing
            dnd_filetypes = { "all" }, -- DND for all filetypes
        },
        normal = {
            severity_filter = "WARN", -- Warnings and errors
            source_filter = {},       -- Allow all
            focus_mode = true,        -- Auto-mute while typing
            dnd_filetypes = { "markdown", "org", "text" },
        },
        verbose = {
            severity_filter = "INFO", -- Show everything
            source_filter = {},       -- Allow all
            focus_mode = false,       -- Always show
            dnd_filetypes = {},       -- No DND
        },
    },
})
