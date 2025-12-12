local mini_notify = require('mini.notify')

mini_notify.setup({
    content = {
        format = nil,
        sort = nil,
    },

    lsp_progress = {
        enable = false,
        duration_last = 1000,
    },

    window = {
        config = {
            border = "rounded",
            anchor = "NW",
            row = vim.o.lines,
            col = vim.o.columns,
            focusable = false,
            zindex = 100,
            style = "minimal",
        },
        winblend = 10,
        max_width_share = 0.35,
        max_height_share = 0.25,
    },
})

-- Ensure TRACE level exists
if not vim.log.levels.TRACE then
    vim.log.levels.TRACE = 0
end

-- Override vim.notify to show ALL levels with no throttling
vim.notify = mini_notify.make_notify({
    ERROR = { duration = 5000, hl_group = 'DiagnosticError' },
    WARN  = { duration = 4000, hl_group = 'DiagnosticWarn' },
    INFO  = { duration = 3000, hl_group = 'DiagnosticInfo' },
    DEBUG = { duration = 3000, hl_group = 'DiagnosticHint' },
    TRACE = { duration = 3000, hl_group = 'DiagnosticHint' },
})

-- LSP message handler to show ALL messages
vim.lsp.handlers["window/showMessage"] = function(_, result, ctx)
    local client_name = "Unknown"
    if vim.lsp.get_client_by_id then
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        if client then
            client_name = client.name
        end
    end

    local level_map = {
        [1] = vim.log.levels.ERROR,
        [2] = vim.log.levels.WARN,
        [3] = vim.log.levels.INFO,
        [4] = vim.log.levels.DEBUG,
    }

    local level = level_map[result.type] or vim.log.levels.INFO

    vim.notify(string.format("[%s] %s", client_name, result.message), level)
end

-- Keybindings
vim.keymap.set('n', '<leader>nh', function()
    mini_notify.show_history()
end, { desc = 'Show notification history' })

vim.keymap.set('n', '<leader>nc', function()
    mini_notify.clear()
end, { desc = 'Clear all notifications' })

vim.keymap.set('n', '<leader>nr', function()
    mini_notify.refresh()
end, { desc = 'Refresh notifications' })
