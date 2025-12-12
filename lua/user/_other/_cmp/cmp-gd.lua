-- Register custom GDScript source
local cmp = require('cmp')
cmp.register_source('gdscript', require('user.CustomCmp.source-gd').new())

-- Setup filetype-specific completion for GDScript
cmp.setup.filetype('gdscript', {
  sources = cmp.config.sources({
    { name = 'gdscript', priority = 900 },
    { name = 'luasnip', priority = 750 },
    { name = 'buffer', priority = 500 },
    { name = 'path', priority = 250 },
  }),
})

vim.filetype.add({
  extension = {
    gd = 'gdscript',
  },
}) 
