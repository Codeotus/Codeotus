local notify = require("notify")

-- Helper: adaptive timeout (based on message length)
local function adaptive_timeout(msg)
    local base = 2000       -- minimum 2s
    local extra = #msg * 40 -- add 40ms per character
    local max = 6000        -- cap at 6s
    return math.min(base + extra, max)
end

notify.setup({
    -- Default fallback timeout
    timeout = 4000,

    -- Smooth animation
    stages = "static",

    -- CRITICAL FIX: Show ALL levels including DEBUG and TRACE
    level = vim.log.levels.TRACE or vim.log.levels.DEBUG or 0,

    -- Responsive sizing
    max_width = math.floor(vim.o.columns * 0.75),
    max_height = math.floor(vim.o.lines * 0.6),

    -- Rendering style
    render = "wrapped-compact",

    -- Icons
    icons = {
        ERROR = "●",
        WARN = "●",
        INFO = "●",
        DEBUG = "●",
        TRACE = "●",
    },
})

-- Override vim.notify to show ALL messages
vim.notify = function(msg, level, opts)
    opts = opts or {}

    -- Ensure TRACE level exists
    if not vim.log.levels.TRACE then
        vim.log.levels.TRACE = 0
    end

    -- Default to INFO if nil
    level = level or vim.log.levels.INFO

    -- Adaptive timing
    if not opts.timeout and level ~= vim.log.levels.ERROR then
        opts.timeout = adaptive_timeout(tostring(msg))
    end

    -- Errors stay until dismissed
    if level == vim.log.levels.ERROR then
        opts.timeout = false
    end

    notify(msg, level, opts)
end
