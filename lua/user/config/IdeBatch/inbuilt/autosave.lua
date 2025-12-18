-- Neovim Autosave Plugin
-- Place this in ~/.config/nvim/lua/autosave.lua

local M = {}

-- Default configuration
M.config = {
    enabled = true,
    allow = { "all" },         -- {"rust", "python", "lua"} or {"all"}
    disallow = { "c", "cpp" }, -- Disallowed by default
    speed = 100,               -- Delay in milliseconds (0 for instant)
    mode = "n",                -- normal mode only
}

-- State
local timer = nil
local autocmd_id = nil

-- Check if current filetype is allowed
local function is_filetype_allowed()
    local ft = vim.bo.filetype

    -- If filetype is empty, don't autosave
    if ft == "" then
        return false
    end

    -- Check disallow list first
    for _, disallowed in ipairs(M.config.disallow) do
        if disallowed == "all" then
            return false
        end
        if ft == disallowed then
            return false
        end
    end

    -- Check allow list
    for _, allowed in ipairs(M.config.allow) do
        if allowed == "all" then
            return true
        end
        if ft == allowed then
            return true
        end
    end

    return false
end

-- Check if buffer can be saved
local function can_save_buffer()
    local bufnr = vim.api.nvim_get_current_buf()

    -- Check if buffer is modifiable and modified
    if not vim.bo[bufnr].modifiable then
        return false
    end

    if not vim.bo[bufnr].modified then
        return false
    end

    -- Check if buffer has a valid filename
    local filename = vim.api.nvim_buf_get_name(bufnr)
    if filename == "" or filename:match("^term://") then
        return false
    end

    -- Check if in normal mode
    local mode = vim.api.nvim_get_mode().mode
    if mode ~= M.config.mode then
        return false
    end

    -- Check filetype
    if not is_filetype_allowed() then
        return false
    end

    return true
end

-- Perform autosave
local function autosave()
    if not M.config.enabled then
        return
    end

    if can_save_buffer() then
        -- Save without triggering autocmds to prevent recursion
        vim.cmd("silent! noautocmd write")
    end
end

-- Debounced autosave
local function schedule_autosave()
    if timer then
        timer:stop()
    end

    if M.config.speed == 0 then
        autosave()
    else
        timer = vim.defer_fn(autosave, M.config.speed)
    end
end

-- Setup autocmds
local function setup_autocmds()
    if autocmd_id then
        vim.api.nvim_del_augroup_by_id(autocmd_id)
    end

    autocmd_id = vim.api.nvim_create_augroup("Autosave", { clear = true })

    vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
        group = autocmd_id,
        callback = function()
            if M.config.enabled then
                schedule_autosave()
            end
        end,
    })

    -- Additional trigger on leaving insert mode
    vim.api.nvim_create_autocmd("InsertLeave", {
        group = autocmd_id,
        callback = function()
            if M.config.enabled then
                schedule_autosave()
            end
        end,
    })
end

-- Toggle autosave
function M.toggle()
    M.config.enabled = not M.config.enabled

    if M.config.enabled then
        vim.notify("Autosave enabled", vim.log.levels.INFO)
    else
        vim.notify("Autosave disabled", vim.log.levels.INFO)
        if timer then
            timer:stop()
            timer = nil
        end
    end
end

-- Setup function
function M.setup(opts)
    -- Merge user config with defaults
    if opts then
        M.config = vim.tbl_deep_extend("force", M.config, opts)
    end

    -- Setup autocmds
    setup_autocmds()

    -- Create user command
    vim.api.nvim_create_user_command("AutosaveToggle", M.toggle, {})

    -- Setup keybinding
    vim.keymap.set("n", "<leader>ab", M.toggle, {
        desc = "Toggle Autosave",
        silent = true
    })
end

return M
