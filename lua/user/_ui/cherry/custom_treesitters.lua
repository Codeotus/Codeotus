-- local theme_overrides = {
--   gruvbox = {
--     ["@function"]       = { fg = "#fe8019", bold = true },
--     ["@function.call"]  = { fg = "#fabd2f", bold = true },
--     ["@string"]         = { fg = "#98971a" },
--   },
-- 
--  -- catppuccin = {
--  --},
-- 
--   -- tokyonight = {
--   --  ["@function"] = { fg = "#7aa2f7" },
--   --  ["@string"]   = { fg = "#9ece6a" },
--   --},
-- }
-- 
-- vim.api.nvim_create_autocmd("ColorScheme", {
--   pattern = "*",
--   callback = function(args)
--     local name = args.match  -- theme name
--     local overrides = theme_overrides[name]
-- 
--     if overrides then
--       for group, opts in pairs(overrides) do
--         vim.api.nvim_set_hl(0, group, opts)
--       end
--     end
--   end,
-- })
--------------------------------------------------------------------
--  THEME + FILETYPE HIGHLIGHT OVERRIDES (SINGLE FILE VERSION)
--------------------------------------------------------------------

-- // The tip to get the language based builtins is to do :Inspect and this will give you the name for e.g in print() of python it give pythonBuiltin and you can just override like this as shown in the e.g of gruvbox based pythonn highlight groups.
-- // Structure goes this way : 
-- theme_name_as_per_plugin = {
    -- ["@HighLightGroupName"] = {fg = #color , bold = true/false , bg = #color , italics = true/false},
    -- langfiletype_based_override = {fg = #color, bold = true/false, bg = #color etc etc...},
    -- }
local theme_overrides = {
  ------------------------------------------------------------------
  -- GRUVBOX OVERRIDES
  ------------------------------------------------------------------
  gruvbox = {
    -- Global Treesitter overrides (apply to all filetypes)
    ["@function"]       = { fg = "#f98019", bold = true },
    ["@function.call"]  = { fg = "#fabd2f", bold = true },
    ["@string"]         = { fg = "#98971a" },

    -- Filetype-specific overrides

    c = {
      ["@function"] = { fg = "#fe8019", bold = true },
      ["@type"]     = { fg = "#00ff87" },
    },

    -- python = {
    --     ["pythonBuiltin"] = {fg = "#fe8019"},
    --     ["@function"]       = { fg = "#ffaa00" },
    --     ["@variable.builtin"] = { fg = "#ff6600" },
    -- },
  },

  ------------------------------------------------------------------
  -- TOKYONIGHT OVERRIDES
  ------------------------------------------------------------------
  tokyonight = {
    ["@function"] = { fg = "#7aa2f7" },
    ["@string"]   = { fg = "#9ece6a" },

    lua = {
      ["@keyword"] = { fg = "#ff00ff" },
    },

    javascript = {
      ["@function"] = { fg = "#ffb86c" },
      ["@string"]   = { fg = "#50fa7b" },
    },
  },

  ------------------------------------------------------------------
  -- CATPPUCCIN OVERRIDES
  ------------------------------------------------------------------
  catppuccin = {
    ["@function"] = { fg = "#c6a0f6" },
    ["@string"]   = { fg = "#a6da95" },

    lua = {
      ["@function.call"] = { fg = "#f5bde6" },
    },
  },
}

--------------------------------------------------------------------
--  APPLY THEME OVERRIDES ON :colorscheme
--------------------------------------------------------------------
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function(args)
    local name = args.match          -- theme name
    local overrides = theme_overrides[name]
    if not overrides then return end

    -- Apply global highlights (direct @groups)
    for group, opts in pairs(overrides) do
      if type(opts) == "table" and not group:match("^%a") then
        vim.api.nvim_set_hl(0, group, opts)
      end
    end

    ----------------------------------------------------------------
    -- Apply filetype-specific overrides dynamically
    ----------------------------------------------------------------
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "*",
      callback = function(ftargs)
        local ft = ftargs.match                   -- "lua" | "c" | "python" etc.
        local ft_overrides = overrides[ft]
        if not ft_overrides then return end

        for group, opts in pairs(ft_overrides) do
          vim.api.nvim_set_hl(0, group, opts)
        end
      end,
    })
  end,
})
