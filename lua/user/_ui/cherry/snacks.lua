local snacks = require('snacks')

-- Setup Snacks with beautiful notifications
snacks.setup({
    -- Enable notification system
    notifier = {
        enabled = true,
        timeout = 3000, -- 3 seconds default display
        width = { min = 40, max = 0.4 },
        height = { min = 1, max = 0.6 },
        margin = { top = 0, right = 1, bottom = 0 },
        padding = true,
        sort = { "level", "added" },

        -- Show notifications with rounded borders
        style = "compact",
        top_down = true,

        -- CRITICAL: Show ALL levels including DEBUG and TRACE
        filter = function(notif)
            return true -- Show everything, no filtering
        end,

        -- Icons for different severity levels
        icons = {
            error = "●",
            warn = "●",
            info = "●",
            debug = "●",
            trace = "●",
        },

        -- Level styles
        level = {
            error = { hl = "DiagnosticError" },
            warn = { hl = "DiagnosticWarn" },
            info = { hl = "DiagnosticInfo" },
            debug = { hl = "DiagnosticHint" },
            trace = { hl = "DiagnosticHint" },
        },
    },

    -- Other snacks features (optional)
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    statuscolumn = { enabled = false },
    words = { enabled = true },
})

-- Override vim.notify to use Snacks and show ALL messages
vim.notify = function(msg, level, opts)
    -- Ensure TRACE level exists (might not in older Neovim)
    if not vim.log.levels.TRACE then
        vim.log.levels.TRACE = 0
    end

    -- Default to INFO if level is nil
    level = level or vim.log.levels.INFO

    -- Call Snacks notifier
    return snacks.notifier.notify(msg, level, opts)
end

-- Configure to show ALL severity levels (including DEBUG and TRACE)
vim.lsp.handlers["window/showMessage"] = function(_, result, ctx)
    local client_name = "Unknown"
    if vim.lsp.get_client_by_id then
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        if client then
            client_name = client.name
        end
    end

    -- Map LSP message types to vim log levels
    local level_map = {
        [1] = vim.log.levels.ERROR,
        [2] = vim.log.levels.WARN,
        [3] = vim.log.levels.INFO,
        [4] = vim.log.levels.DEBUG,
    }

    local level = level_map[result.type] or vim.log.levels.INFO

    snacks.notifier.notify(result.message, level, {
        title = "LSP | " .. client_name,
    })
end

-- Also capture LSP progress messages
vim.lsp.handlers["$/progress"] = function(_, result, ctx)
    local client_name = "Unknown"
    if vim.lsp.get_client_by_id then
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        if client then
            client_name = client.name
        end
    end

    local value = result.value
    if value and value.kind then
        local message = value.message or value.title or ""
        if value.kind == "end" then
            snacks.notifier.notify(message, vim.log.levels.INFO, {
                title = "LSP | " .. client_name,
            })
        end
    end
end

-- Useful keybindings
vim.keymap.set('n', '<leader>nh', function()
    snacks.notifier.show_history()
end, { desc = 'Show notification history' })

vim.keymap.set('n', '<leader>nc', function()
    snacks.notifier.hide()
end, { desc = 'Hide notifications' })

vim.keymap.set('n', '<leader>un', function()
    snacks.notifier.hide()
end, { desc = 'Dismiss all notifications' })
