-- require('mini.animate').setup({
--     cursor = {
--         enable = true,
--         timing = require('mini.animate').gen_timing.linear({ duration = 40, unit = 'total' }),
--     },
--     scroll = { enable = false }, -- Disable scroll for max speed
--     resize = { enable = false },
--     open = { enable = false },
--     close = { enable = false },
-- })

--[[
-- CONFIGURATION 2: Exponential timing (starts fast, ends slow - feels smoother)
require('mini.animate').setup({
  cursor = {
    enable = true,
    timing = require('mini.animate').gen_timing.exponential({
      easing = 'out',     -- 'in', 'out', or 'in-out'
      duration = 80,
      unit = 'total'
    }),
  },
})
]]

--[[
-- CONFIGURATION 3: Cubic timing (very smooth acceleration/deceleration)
require('mini.animate').setup({
  cursor = {
    enable = true,
    timing = require('mini.animate').gen_timing.cubic({
      easing = 'out',
      duration = 70,
      unit = 'total'
    }),
  },
})
]]

--[[
-- CONFIGURATION 4: Quadratic timing (subtle smoothing)
require('mini.animate').setup({
  cursor = {
    enable = true,
    timing = require('mini.animate').gen_timing.quadratic({
      easing = 'out',
      duration = 60,
      unit = 'total'
    }),
  },
})
]]

-- ============================================================================
-- RECOMMENDED DURATION VALUES
-- ============================================================================
--[[
  50ms  - Very fast, barely noticeable (good for fast typers)
  60ms  - Fast & smooth (RECOMMENDED)
  80ms  - Smooth, noticeable
  100ms - Slower, more obvious
  120ms+ - Too slow for most people

  Try different values and see what feels best for you!
]]

-- ============================================================================
-- KEYBIND TO TOGGLE ANIMATIONS ON/OFF
-- ============================================================================

-- Toggle cursor animation
-- vim.keymap.set('n', '<leader>tc', function()
--     if vim.g.minianimate_disable then
--         vim.g.minianimate_disable = false
--         print("✨ Cursor animations enabled")
--     else
--         vim.g.minianimate_disable = true
--         print("❌ Cursor animations disabled")
--     end
-- end, { desc = 'Toggle cursor animations' })
--
-- -- ============================================================================
-- -- ENHANCE CURSOR VISIBILITY (pairs well with animations)
-- -- ============================================================================
--
-- -- Better cursor line highlighting
-- vim.opt.cursorline = true
--
-- -- Custom cursor colors (adjust to your theme)
-- vim.api.nvim_set_hl(0, 'Cursor', {
--     fg = '#1e1e1e',
--     bg = '#61afef', -- Bright blue
--     bold = true
-- })
--
-- vim.api.nvim_set_hl(0, 'CursorLine', {
--     bg = '#2d3139', -- Subtle background
-- })
--
-- vim.api.nvim_set_hl(0, 'CursorLineNr', {
--     fg = '#e5c07b', -- Gold for line number
--     bold = true
-- })
--
-- -- Different cursor shapes for different modes
-- vim.opt.guicursor = {
--     'n-v-c:block-Cursor/lCursor',            -- Normal: block
--     'i-ci-ve:ver25-Cursor/lCursor',          -- Insert: thin line
--     'r-cr:hor20-Cursor/lCursor',             -- Replace: underscore
--     'a:blinkwait700-blinkoff400-blinkon250', -- Blink
-- }
