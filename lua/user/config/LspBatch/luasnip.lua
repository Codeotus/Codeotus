-- Minimal LuaSnip config for debugging
local status_ok, luasnip = pcall(require, "luasnip")
if not status_ok then
    vim.notify("❌ LuaSnip not found!", vim.log.levels.ERROR)
    return
end

vim.notify("✅ LuaSnip loaded successfully")

-- Basic configuration
luasnip.config.set_config({
    history = true,
    updateevents = "TextChanged,TextChangedI",
    enable_autosnippets = true,
})

-- Get the snippets path
local snippet_path = vim.fn.stdpath("config") .. "/lua/user/snippets"

-- Check if directory exists
if vim.fn.isdirectory(snippet_path) == 0 then
    return
end

-- Load snippets
require("luasnip.loaders.from_vscode").lazy_load({
    paths = { snippet_path }
})


-- Simple keymaps that WILL work
vim.keymap.set({ "i" }, "<C-k>", function()
    if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
        print("✅ Snippet expanded/jumped")
    else
        print("❌ No snippet to expand")
    end
end, { silent = false, desc = "Expand or jump" })

vim.keymap.set({ "i" }, "<C-j>", function()
    if luasnip.jumpable(-1) then
        luasnip.jump(-1)
        print("✅ Jumped back")
    else
        print("❌ Can't jump back")
    end
end, { silent = false, desc = "Jump back" })

-- Debug command
vim.api.nvim_create_user_command("SnippetDebug", function()
    print("\n=== SNIPPET DEBUG ===")
    print("Snippet path: " .. snippet_path)
    print("Directory exists: " .. (vim.fn.isdirectory(snippet_path) == 1 and "YES" or "NO"))

    -- List files
    local handle = io.popen('ls -la ' .. snippet_path)
    if handle then
        local result = handle:read("*a")
        handle:close()
        print("Files in snippets dir:\n" .. result)
    end

    -- Check available snippets for current filetype
    local ft = vim.bo.filetype
    print("Current filetype: " .. ft)
    local snips = luasnip.get_snippets(ft)
    if snips and #snips > 0 then
        print("Available snippets for " .. ft .. ":")
        for _, snip in ipairs(snips) do
            print("  - " .. snip.trigger .. " : " .. (snip.name or "no name"))
        end
    else
        print("❌ NO SNIPPETS FOUND for filetype: " .. ft)
    end
end, {})
