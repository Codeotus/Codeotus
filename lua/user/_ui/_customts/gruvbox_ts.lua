-- File: ~/.config/nvim/lua/theme_overrides/gruvbox_ts.lua

local M = {}

-- Define your overrides for gruvbox
M.overrides = {
  c = {
    ["@function.call"] = "#fe8019",           -- orange
    ["@function.builtin"] = "#fabd2f",        -- yellow
    ["@string"] = "#8ec07c",                  -- aqua
    ["@string.escape"] = "#d3869b",           -- purple
    ["@keyword"] = "#fb4934",                 -- red
    ["@keyword.return"] = "#fb4934",          -- red
    ["@type"] = "#83a598",                    -- blue
    ["@type.builtin"] = "#83a598",            -- blue
    ["@variable"] = "#ebdbb2",                -- fg
    ["@variable.parameter"] = "#fe8019",      -- orange
    ["@constant"] = "#d3869b",                -- purple
    ["@constant.builtin"] = "#d3869b",        -- purple
    ["@constant.macro"] = "#8ec07c",          -- aqua
    ["@keyword.directive"] = "#8ec07c",       -- aqua (preprocessor)
    ["@operator"] = "#fe8019",                -- orange
    ["@comment"] = "#928374",                 -- gray
  },
  
  cpp = {
    ["@function.call"] = "#fe8019",
    ["@function.builtin"] = "#fabd2f",
    ["@string"] = "#8ec07c",
    ["@string.escape"] = "#d3869b",
    ["@keyword"] = "#fb4934",
    ["@keyword.return"] = "#fb4934",
    ["@type"] = "#83a598",
    ["@type.builtin"] = "#83a598",
    ["@variable"] = "#ebdbb2",
    ["@variable.parameter"] = "#fe8019",
    ["@constant"] = "#d3869b",
    ["@constant.builtin"] = "#d3869b",
    ["@constant.macro"] = "#8ec07c",
    ["@keyword.directive"] = "#8ec07c",
    ["@operator"] = "#fe8019",
    ["@comment"] = "#928374",
    ["@namespace"] = "#8ec07c",               -- C++ specific
    ["@type.qualifier"] = "#fb4934",          -- const, static, etc.
  },
  
  python = {
    ["@function.call"] = "#fe8019",
    ["@string"] = "#8ec07c",
    ["@keyword"] = "#fb4934",
  },
  
  lua = {
    ["@function.call"] = "#fe8019",
    ["@string"] = "#8ec07c",
    ["@keyword"] = "#fb4934",
  },
}

return M

