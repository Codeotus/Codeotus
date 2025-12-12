-- local harpoon = require("harpoon")
--
-- -- REQUIRED: Setup harpoon with UI customization
-- harpoon:setup({
--     settings = {
--         save_on_toggle = true,
--         sync_on_ui_close = true,
--         key = function()
--             return vim.loop.cwd()
--         end,
--     },
--     menu = {
--         width = vim.api.nvim_win_get_width(0) - 4,
--         height = 10,
--         borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
--     },
-- })
--
--
-- -- UI
-- vim.keymap.set("n", "<C-e>", function()
--     harpoon.ui:toggle_quick_menu(harpoon:list())
-- end, { desc = "Harpoon: Toggle menu" })
--
-- -- Add current file with visual feedback
-- vim.keymap.set("n", "<C-a>", function()
--     harpoon:list():add()
--     vim.notify("Added to Harpoon", vim.log.levels.INFO)
-- end, { desc = "Harpoon: Add file" })
--
-- vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end , {desc = "Add to Harpoon"})


-- Harpoon 2 configuration with custom multilist toggling
local harpoon = require("harpoon")

-- Initialize harpoon with custom lists
harpoon:setup({
    settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
        key = function()
            -- Use current working directory as key for data isolation
            return vim.loop.cwd()
        end,
    },
    -- Define your custom lists here
    default = {
        select = function(list_item, list, options)
            options = options or {}
            options.vsplit = options.vsplit or false
            options.split = options.split or false
            options.tabedit = options.tabedit or false

            if options.vsplit then
                vim.cmd("vsplit")
            elseif options.split then
                vim.cmd("split")
            elseif options.tabedit then
                vim.cmd("tabedit")
            end

            vim.cmd("edit " .. list_item.value)
        end
    }
})

-- Create custom list names (add as many as you need)
local list_names = {
    "default",
    "work",
    "personal",
    "test",
}

-- Track current active list
local current_list = "default"

-- Function to safely toggle between lists
local function toggle_list()
    local current_idx = 1
    for i, name in ipairs(list_names) do
        if name == current_list then
            current_idx = i
            break
        end
    end

    -- Move to next list (wrap around)
    local next_idx = (current_idx % #list_names) + 1
    current_list = list_names[next_idx]

    print("Switched to Harpoon list: " .. current_list)
end

-- Function to select a specific list by name
local function select_list(list_name)
    for _, name in ipairs(list_names) do
        if name == list_name then
            current_list = list_name
            print("Switched to Harpoon list: " .. current_list)
            return
        end
    end
    print("List '" .. list_name .. "' not found")
end

-- Wrapper functions that use the current list
local function add_file()
    harpoon:list(current_list):add()
    print("Added to " .. current_list .. " list")
end

local function toggle_quick_menu()
    harpoon.ui:toggle_quick_menu(harpoon:list(current_list))
end

local function nav_file(index)
    harpoon:list(current_list):select(index)
end

local function nav_next()
    harpoon:list(current_list):next()
end

local function nav_prev()
    harpoon:list(current_list):prev()
end

-- Keymaps
vim.keymap.set("n", "<leader>ah", add_file, { desc = "Harpoon: Add file to current list" })
vim.keymap.set("n", "<C-e>", toggle_quick_menu, { desc = "Harpoon: Toggle quick menu" })

-- Navigate to specific files in current list
vim.keymap.set("n", "<C-h>", function() nav_file(1) end, { desc = "Harpoon: Go to file 1" })
vim.keymap.set("n", "<C-j>", function() nav_file(2) end, { desc = "Harpoon: Go to file 2" })
vim.keymap.set("n", "<C-k>", function() nav_file(3) end, { desc = "Harpoon: Go to file 3" })
vim.keymap.set("n", "<C-l>", function() nav_file(4) end, { desc = "Harpoon: Go to file 4" })

-- Navigate next/prev in current list
vim.keymap.set("n", "<C-S-P>", nav_prev, { desc = "Harpoon: Previous file" })
vim.keymap.set("n", "<C-S-N>", nav_next, { desc = "Harpoon: Next file" })

-- List toggling keymaps
vim.keymap.set("n", "<leader>ht", toggle_list, { desc = "Harpoon: Toggle to next list" })
vim.keymap.set("n", "<leader>hs", function()
    vim.ui.select(list_names, {
        prompt = "Select Harpoon list:",
    }, function(choice)
        if choice then
            select_list(choice)
        end
    end)
end, { desc = "Harpoon: Select specific list" })

-- Quick access to specific lists
vim.keymap.set("n", "<leader>h1", function() select_list("default") end, { desc = "Harpoon: Switch to default" })
vim.keymap.set("n", "<leader>h2", function() select_list("work") end, { desc = "Harpoon: Switch to work" })
vim.keymap.set("n", "<leader>h3", function() select_list("personal") end, { desc = "Harpoon: Switch to personal" })
vim.keymap.set("n", "<leader>h4", function() select_list("test") end, { desc = "Harpoon: Switch to test" })

-- Show current list
vim.keymap.set("n", "<leader>hi", function()
    print("Current Harpoon list: " .. current_list)
end, { desc = "Harpoon: Show current list" })
