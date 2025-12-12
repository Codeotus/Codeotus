-- Basic setup with defaults
require('user.config.IdeBatch.autosave').setup()

-- Or customize it
require('user.config.IdeBatch.autosave').setup({
    enabled = true,
    execution_message = {
        message = function()
            return "AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S")
        end,
        cleaning_interval = 1250, -- Clear message after 1.25s
    },
    trigger_events = { "InsertLeave", "TextChanged" },
    conditions = {
        exists = true,
        filename_is_not = {},
        filetype_is_not = {},
        modifiable = true,
    },
    write_all_buffers = false, -- Save only current buffer
    debounce_delay = 135,      -- Wait 135ms before saving
})
