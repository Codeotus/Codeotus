-- Neovim Notification Manager Plugin
-- Place this in ~/.config/nvim/lua/notif_manager.lua

local M = {}

-- Default configuration
M.config = {
    enabled = true,
    current_profile = "normal", -- "quiet", "normal", "verbose"

    profiles = {
        quiet = {
            severity_filter = "ERROR", -- Only errors
            source_filter = { "all" }, -- Block all sources
            focus_mode = true,
            dnd_filetypes = { "all" },
        },
        normal = {
            severity_filter = "WARN", -- Warn and above
            source_filter = {}, -- Allow all sources
            focus_mode = true,
            dnd_filetypes = { "markdown", "org", "text" },
        },
        verbose = {
            severity_filter = "INFO", -- Show everything
            source_filter = {}, -- Allow all sources
            focus_mode = false,
            dnd_filetypes = {},
        },
    },

    -- Per-buffer overrides
    buffer_overrides = {},

    -- Muted notifications history
    muted_history = {},
    max_history = 100,
}

-- Severity levels
local SEVERITY = {
    ERROR = 1,
    WARN = 2,
    INFO = 3,
    DEBUG = 4,
}

-- State
local original_notify = nil
local is_focus_active = false
local focus_timer = nil

-- Get current profile settings
local function get_current_settings()
    local bufnr = vim.api.nvim_get_current_buf()

    -- Check buffer override first
    if M.config.buffer_overrides[bufnr] then
        return M.config.buffer_overrides[bufnr]
    end

    -- Return current profile
    return M.config.profiles[M.config.current_profile]
end

-- Check if notification should be shown based on severity
local function check_severity(level, filter)
    if not filter then return true end

    local level_num = SEVERITY[level] or SEVERITY.INFO
    local filter_num = SEVERITY[filter] or SEVERITY.INFO

    return level_num <= filter_num
end

-- Check if source is blocked
local function is_source_blocked(source, filter)
    if not filter or #filter == 0 then
        return false
    end

    for _, blocked in ipairs(filter) do
        if blocked == "all" then
            return true
        end
        if source and source:lower():match(blocked:lower()) then
            return true
        end
    end

    return false
end

-- Check if DND for current filetype
local function is_dnd_filetype()
    local settings = get_current_settings()
    local ft = vim.bo.filetype

    if not settings.dnd_filetypes or #settings.dnd_filetypes == 0 then
        return false
    end

    for _, dnd_ft in ipairs(settings.dnd_filetypes) do
        if dnd_ft == "all" then
            return true
        end
        if ft == dnd_ft then
            return true
        end
    end

    return false
end

-- Add to muted history
local function add_to_history(msg, level, opts)
    table.insert(M.config.muted_history, 1, {
        message = msg,
        level = level,
        source = opts.title or "Unknown",
        timestamp = os.date("%H:%M:%S"),
        reason = opts._mute_reason or "Unknown",
    })

    -- Keep history size manageable
    if #M.config.muted_history > M.config.max_history then
        table.remove(M.config.muted_history)
    end
end

-- Custom notify function
local function custom_notify(msg, level, opts)
    opts = opts or {}

    -- If disabled globally, mute everything
    if not M.config.enabled then
        opts._mute_reason = "Global disable"
        add_to_history(msg, level, opts)
        return
    end

    local settings = get_current_settings()

    -- Check DND filetype
    if is_dnd_filetype() then
        opts._mute_reason = "DND filetype"
        add_to_history(msg, level, opts)
        return
    end

    -- Check focus mode
    if settings.focus_mode and is_focus_active then
        opts._mute_reason = "Focus mode active"
        add_to_history(msg, level, opts)
        return
    end

    -- Convert level to string
    local level_str = "INFO"
    if level == vim.log.levels.ERROR then
        level_str = "ERROR"
    elseif level == vim.log.levels.WARN then
        level_str = "WARN"
    elseif level == vim.log.levels.INFO then
        level_str = "INFO"
    elseif level == vim.log.levels.DEBUG then
        level_str = "DEBUG"
    end

    -- Check severity filter
    if not check_severity(level_str, settings.severity_filter) then
        opts._mute_reason = "Severity filter (" .. settings.severity_filter .. ")"
        add_to_history(msg, level, opts)
        return
    end

    -- Check source filter
    if is_source_blocked(opts.title, settings.source_filter) then
        opts._mute_reason = "Source blocked"
        add_to_history(msg, level, opts)
        return
    end

    -- Show notification
    original_notify(msg, level, opts)
end

-- Focus mode detection
local function setup_focus_detection()
    local group = vim.api.nvim_create_augroup("NotifManagerFocus", { clear = true })

    -- Detect typing activity
    vim.api.nvim_create_autocmd({ "TextChangedI", "TextChanged" }, {
        group = group,
        callback = function()
            local settings = get_current_settings()
            if not settings.focus_mode then return end

            is_focus_active = true

            -- Reset timer
            if focus_timer then
                focus_timer:stop()
            end

            -- Deactivate focus after 2 seconds of inactivity
            focus_timer = vim.defer_fn(function()
                is_focus_active = false
            end, 2000)
        end,
    })

    vim.api.nvim_create_autocmd("InsertEnter", {
        group = group,
        callback = function()
            local settings = get_current_settings()
            if settings.focus_mode then
                is_focus_active = true
            end
        end,
    })

    vim.api.nvim_create_autocmd("InsertLeave", {
        group = group,
        callback = function()
            if focus_timer then
                focus_timer:stop()
            end
            vim.defer_fn(function()
                is_focus_active = false
            end, 500)
        end,
    })
end

-- Toggle global notifications
function M.toggle_global()
    M.config.enabled = not M.config.enabled
    vim.notify(
        "Notifications " .. (M.config.enabled and "enabled" or "disabled"),
        vim.log.levels.INFO,
        { title = "NotifManager" }
    )
end

-- Toggle current buffer notifications
function M.toggle_buffer()
    local bufnr = vim.api.nvim_get_current_buf()

    if M.config.buffer_overrides[bufnr] then
        M.config.buffer_overrides[bufnr] = nil
        vim.notify("Buffer notifications: using profile settings", vim.log.levels.INFO)
    else
        M.config.buffer_overrides[bufnr] = {
            severity_filter = "ERROR",
            source_filter = { "all" },
            focus_mode = false,
            dnd_filetypes = {},
        }
        vim.notify("Buffer notifications: muted", vim.log.levels.INFO)
    end
end

-- Switch profile
function M.switch_profile(profile)
    if not M.config.profiles[profile] then
        vim.notify("Profile '" .. profile .. "' not found", vim.log.levels.ERROR)
        return
    end

    M.config.current_profile = profile
    vim.notify("Switched to profile: " .. profile, vim.log.levels.INFO)
end

-- Show muted notifications buffer
function M.show_history()
    local buf = vim.api.nvim_create_buf(false, true)

    -- Build content
    local lines = { "=== Muted Notifications History ===" }
    table.insert(lines, "")

    if #M.config.muted_history == 0 then
        table.insert(lines, "No muted notifications")
    else
        for _, entry in ipairs(M.config.muted_history) do
            table.insert(lines, string.format("[%s] %s", entry.timestamp, entry.source))
            table.insert(lines, string.format("  Level: %s", entry.level or "INFO"))
            table.insert(lines, string.format("  Reason: %s", entry.reason))
            table.insert(lines, string.format("  Message: %s", entry.message))
            table.insert(lines, "")
        end
    end

    table.insert(lines, "")
    table.insert(lines, "Press 'q' to close | Press 'c' to clear history")

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
    vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
    vim.api.nvim_buf_set_option(buf, "filetype", "notifhistory")

    -- Open in split
    vim.cmd("split")
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win, buf)
    vim.api.nvim_win_set_height(win, math.min(#lines, 30))

    -- Keymaps
    vim.keymap.set("n", "q", function()
        vim.api.nvim_win_close(win, true)
    end, { buffer = buf, silent = true })

    vim.keymap.set("n", "c", function()
        M.config.muted_history = {}
        vim.api.nvim_win_close(win, true)
        vim.notify("History cleared", vim.log.levels.INFO)
    end, { buffer = buf, silent = true })
end

-- Get status for statusline
function M.get_status()
    if not M.config.enabled then
        return "🔕"
    end

    local bufnr = vim.api.nvim_get_current_buf()
    if M.config.buffer_overrides[bufnr] then
        return "🔕(buf)"
    end

    local profile = M.config.current_profile
    if profile == "quiet" then
        return "🔇"
    elseif profile == "verbose" then
        return "🔔"
    else
        return "🔔"
    end
end

-- Setup function
function M.setup(opts)
    -- Merge config
    if opts then
        M.config = vim.tbl_deep_extend("force", M.config, opts)
    end

    -- Store original notify
    original_notify = vim.notify

    -- Replace vim.notify
    vim.notify = custom_notify

    -- Setup focus detection
    setup_focus_detection()

    -- Commands
    vim.api.nvim_create_user_command("NotifToggle", M.toggle_global, {})
    vim.api.nvim_create_user_command("NotifToggleBuffer", M.toggle_buffer, {})
    vim.api.nvim_create_user_command("NotifHistory", M.show_history, {})
    vim.api.nvim_create_user_command("NotifProfile", function(opts)
        M.switch_profile(opts.args)
    end, {
        nargs = 1,
        complete = function()
            return vim.tbl_keys(M.config.profiles)
        end,
    })

    -- Keymaps
    vim.keymap.set("n", "<leader>nt", M.toggle_global, { desc = "Toggle notifications" })
    vim.keymap.set("n", "<leader>nb", M.toggle_buffer, { desc = "Toggle buffer notifications" })
    vim.keymap.set("n", "<leader>nh", M.show_history, { desc = "Show notification history" })
    vim.keymap.set("n", "<leader>nq", function() M.switch_profile("quiet") end, { desc = "Quiet profile" })
    vim.keymap.set("n", "<leader>nn", function() M.switch_profile("normal") end, { desc = "Normal profile" })
    vim.keymap.set("n", "<leader>nv", function() M.switch_profile("verbose") end, { desc = "Verbose profile" })
end

return M
