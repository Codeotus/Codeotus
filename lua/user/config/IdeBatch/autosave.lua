require("auto-save").setup({
    enabled = false,     -- off by default

    execution_message = {
        enabled = true,
        message = function()
            return "AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S")
        end,
        dim = 0.18,
        cleaning_interval = 1250,
    },

    -- FIX: Use simple array format for trigger_events
    trigger_events = {
        "InsertLeave",
        "TextChanged",
        "FocusLost",
    },

    condition = function(buf)
        local fn = vim.fn

        -- Check if buffer is modifiable
        if fn.getbufvar(buf, "&modifiable") == 0 then
            return false
        end

        -- Check buffer type (skip special buffers)
        local buftype = fn.getbufvar(buf, "&buftype")
        if buftype ~= "" then
            return false
        end

        -- Check if file exists or buffer has a name
        local bufname = fn.bufname(buf)
        if bufname == "" then
            return false
        end

        return true
    end,

    write_all_buffers = false,
    debounce_delay = 135,

    callbacks = {
        enabling = function()
            vim.notify("AutoSave enabled", vim.log.levels.INFO)
        end,
        disabling = function()
            vim.notify("AutoSave disabled", vim.log.levels.WARN)
        end,
        before_saving = function()
            -- Optional: Do something before saving
        end,
        after_saving = function()
            -- Optional: Do something after saving
        end,
    },
})

-- Keymaps
vim.keymap.set("n", "<leader>as", "<cmd>ASToggle<CR>", { desc = "Toggle autosave" })
