-- In your init.lua or init.vim (as lua code)

-- Require and setup the autosave module
require("user.config.IdeBatch.inbuilt.autosave").setup({
    enabled = true,            -- Start with autosave enabled
    allow = { "all" },         -- Allow all filetypes (or specify: {"rust", "python", "lua"})
    disallow = { "c", "cpp" }, -- Disallow these filetypes by default
    speed = 100,               -- Delay in milliseconds (use 0 for instant save)
    mode = "n",                -- Only autosave in normal mode
})
