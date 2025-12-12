local source = {}

local function load_completions()
  local json_path = vim.fn.expand('~/.config/jnv/lua/user/CustomCmp/gdscript_autocompletion.json')
  local file = io.open(json_path, 'r')
  
  if not file then
    vim.notify('GDScript completions file not found: ' .. json_path, vim.log.levels.WARN)
    return {}
  end
  
  local content = file:read('*all')
  file:close()
  
  local ok, decoded = pcall(vim.json.decode, content)
  if ok and decoded.completions then
    return decoded.completions
  end
  
  vim.notify('Failed to parse GDScript completions JSON', vim.log.levels.ERROR)
  return {}
end

local completions = load_completions()

source.new = function()
  return setmetatable({}, { __index = source })
end

source.get_trigger_characters = function()
  return { '.', '_' }
end

source.complete = function(self, params, callback)
  local items = {}
  
  for _, item in ipairs(completions) do
    table.insert(items, {
      label = item.label,
      kind = require('cmp').lsp.CompletionItemKind[item.kind] or 1,
      insertText = item.insertText,
      documentation = item.documentation,
    })
  end
  
  callback({ items = items, isIncomplete = false })
end

return source
