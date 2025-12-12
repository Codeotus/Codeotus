-- ============================================================================
-- File: ~/.config/nvim/lua/Overrider/Caller.lua

local M = {}

-- Apply overrides based on current colorscheme
function M.apply()
  local colorscheme = vim.g.colors_name
  if not colorscheme then
    return
  end
  -- Try to load the override file for current colorscheme
  local ok, overrides = pcall(require, "theme_overrides." .. colorscheme .. "_ts")
  if not ok or not overrides or not overrides.overrides then
    return
  end
  -- Get current filetype
  local filetype = vim.bo.filetype
  if not filetype or filetype == "" then
    return
  end
  -- Apply overrides for this filetype
  local ft_overrides = overrides.overrides[filetype]
  if not ft_overrides then
    return
  end
  for group, color in pairs(ft_overrides) do
    -- Support both with and without filetype suffix
    local group_with_ft = group .. "." .. filetype
    -- Try setting with filetype suffix first
    vim.api.nvim_set_hl(0, group_with_ft, { fg = color })
    -- Also set without suffix for compatibility
    vim.api.nvim_set_hl(0, group, { fg = color })
  end
end

-- Apply to all open buffers
function M.apply_all()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local ft = vim.api.nvim_buf_get_option(buf, "filetype")
      if ft and ft ~= "" then
        vim.api.nvim_buf_call(buf, function()
          M.apply()
        end)
      end
    end
  end
end

-- Setup autocommands
function M.setup()
  local group = vim.api.nvim_create_augroup("ThemeOverrides", { clear = true })
  -- Apply on colorscheme change
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = function()
      vim.defer_fn(function()
        M.apply_all()
      end, 100)
    end,
  })
  -- Apply on filetype change
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    callback = function()
      vim.defer_fn(function()
        M.apply()
      end, 50)
    end,
  })
  -- Apply on buffer enter
  vim.api.nvim_create_autocmd("BufEnter", {
    group = group,
    callback = function()
      M.apply()
    end,
  })
  -- Apply immediately for current buffer
  M.apply()
end

return M


-- ============================================================================
-- Add to your init.lua:
-- 
-- require('theme_overrides').setup()
-- 
-- Then just change your colorscheme as normal:
-- vim.cmd('colorscheme gruvbox')
