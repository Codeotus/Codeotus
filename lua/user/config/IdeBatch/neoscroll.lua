-- Neoscroll config
require('neoscroll').setup({
  -- All these are defaulted; we can tweak for small screens
  mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb'},
  hide_cursor = true,        -- Hide cursor while scrolling
  stop_eof = true,           -- Stop at end of file
  respect_scrolloff = true,  -- Respect 'scrolloff'
  cursor_scrolls_alone = true,
  easing_function = "sine",  -- Smooth but not too slow
  pre_hook = nil,
  post_hook = nil,
})

-- Map scrolling keys with smaller step for small screens
local t = {}
t['<C-u>'] = {'scroll', {'-5', 'true', '250'}}  -- scroll up 5 lines
t['<C-d>'] = {'scroll', {'5', 'true', '250'}}   -- scroll down 5 lines
t['<C-b>'] = {'scroll', {'-10', 'true', '300'}} -- page up
t['<C-f>'] = {'scroll', {'10', 'true', '300'}}  -- page down
t['<C-y>'] = {'scroll', {'-1', 'false', '100'}} -- 1 line up
t['<C-e>'] = {'scroll', {'1', 'false', '100'}}  -- 1 line down

require('neoscroll.config').set_mappings(t)
