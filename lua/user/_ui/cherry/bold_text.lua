-- =======================================================================
-- Uncomment to get de saturated gruvbox --> 
-- =======================================================================

-- vim.api.nvim_create_autocmd("ColorScheme", {
  -- pattern = "gruvbox",
  -- callback = function()
    -- -- Force bold on major syntax groups
    -- vim.cmd [[
      -- hi GruvboxRed gui=bold
      -- hi GruvboxOrange gui=bold
      -- hi GruvboxYellow gui=bold
      -- hi GruvboxAqua gui=bold
      -- hi GruvboxBlue gui=bold
      -- hi GruvboxGreen gui=bold
      -- hi Keyword gui=bold
      -- hi Statement gui=bold
      -- hi Function gui=bold
      -- hi Type gui=bold
      -- hi Constant gui=bold
    -- ]]
  -- end,
-- })

-- =======================================================================
-- Uncomment to get saturated gruvbox --> 
-- Through it is not that better!
-- =======================================================================

-- vim.api.nvim_create_autocmd("ColorScheme", {
  -- pattern = "gruvbox",
  -- callback = function()
    -- local groups = {
      -- "GruvboxRed",
      -- "GruvboxOrange",
      -- "GruvboxYellow",
      -- "GruvboxAqua",
      -- "GruvboxBlue",
      -- "GruvboxGreen",
      -- "Keyword",
      -- "Statement",
      -- "Function",
      -- "Type",
      -- "Constant",
    -- }

    -- for _, group in ipairs(groups) do
      -- local ok, current = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
      -- if ok and current then
        -- -- Build a new table with only allowed highlight fields
        -- vim.api.nvim_set_hl(0, group, {
          -- fg = current.fg,
          -- bg = current.bg,
          -- sp = current.sp,
          -- -- italic = current.italic,
          -- underline = current.underline,
          -- bold = true,
        -- })
      -- end
    -- end

    -- -- Optional: restore Gruvbox borders
    -- vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#b8bb26", bg = "none" })
    -- vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#b8bb26", bg = "none" })
  -- end,
-- })


-- =======================================================================
-- Universal (by Claude) to get de saturated one for almost all 68 thenes --> 
-- =======================================================================

-- Configuration
vim.g.bold_text_enabled = true -- Set to false to disable by default

-- Comprehensive list of text-related highlight groups to make bold
local text_groups = {
  -- Syntax highlighting
  "Keyword",
  "Statement",
  "Conditional",
  "Repeat",
  "Label",
  "Operator",
  "Exception",
  "Include",
  "Define",
  "Macro",
  "PreProc",
  "StorageClass",
  "Structure",
  "Typedef",
  "Function",
  "Identifier",
  "Type",
  "Constant",
  "String",
  "Character",
  "Number",
  "Boolean",
  "Float",
  "Comment",
  "Special",
  "SpecialChar",
  "Tag",
  "Delimiter",
  "SpecialComment",
  "Debug",
  -- Treesitter groups (modern syntax)
  "@keyword",
  "@keyword.function",
  "@keyword.operator",
  "@keyword.return",
  "@function",
  "@function.builtin",
  "@function.call",
  "@method",
  "@method.call",
  "@variable",
  "@variable.builtin",
  "@parameter",
  "@property",
  "@type",
  "@type.builtin",
  "@string",
  "@number",
  "@boolean",
  "@constant",
  "@constant.builtin",
  "@operator",
  "@punctuation.bracket",
  "@punctuation.delimiter",
  "@constructor",
  "@tag",
  "@attribute",
  -- Gruvbox specific (if using Gruvbox)
  "GruvboxRed",
  "GruvboxOrange",
  "GruvboxYellow",
  "GruvboxAqua",
  "GruvboxBlue",
  "GruvboxGreen",
  "GruvboxPurple",
  "GruvboxRedBold",
  "GruvboxOrangeBold",
  "GruvboxYellowBold",
  "GruvboxAquaBold",
  "GruvboxBlueBold",
  "GruvboxGreenBold",
  "GruvboxPurpleBold",
}

-- Function to apply bold to text groups
local function apply_bold_text()
  if not vim.g.bold_text_enabled then
    return
  end
  for _, group in ipairs(text_groups) do
    local ok, current = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
    if ok and current and next(current) ~= nil then
      -- Preserve all existing attributes and add bold
      vim.api.nvim_set_hl(0, group, {
        fg = current.fg,
        bg = current.bg,
        sp = current.sp,
        italic = current.italic,
        underline = current.underline,
        undercurl = current.undercurl,
        strikethrough = current.strikethrough,
        reverse = current.reverse,
        standout = current.standout,
        bold = true, -- Always set bold
      })
    end
  end
end

-- Function to remove bold from text groups (restore original)
local function remove_bold_text()
  -- Force reload the colorscheme to restore original settings
  local current_colorscheme = vim.g.colors_name
  if current_colorscheme then
    vim.cmd("colorscheme " .. current_colorscheme)
  end
end

-- Auto-apply bold text whenever colorscheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    -- Small delay to ensure colorscheme is fully loaded
    vim.defer_fn(function()
      apply_bold_text()
    end, 10)
  end,
})

-- Apply bold text on startup (after initial colorscheme loads)
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.defer_fn(function()
      apply_bold_text()
    end, 50)
  end,
})

-- Toggle command: :ToggleBoldText
vim.api.nvim_create_user_command("ToggleBoldText", function()
  vim.g.bold_text_enabled = not vim.g.bold_text_enabled
  if vim.g.bold_text_enabled then
    apply_bold_text()
    print("Bold text enabled")
  else
    remove_bold_text()
    print("Bold text disabled")
  end
end, { desc = "Toggle bold text for all themes" })

-- Optional: Create a keybinding for quick toggle
-- Uncomment the line below to bind <leader>tb to toggle bold text
-- vim.keymap.set("n", "<leader>tb", "<cmd>ToggleBoldText<cr>", { desc = "Toggle bold text" })
