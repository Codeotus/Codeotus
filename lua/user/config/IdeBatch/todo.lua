-- Todo Comments
require("todo-comments").setup({
  signs = true, -- show icons in the sign column
  keywords = {
    FIX = { icon = "󰨰 ", color = "error", alt = { "FIXME", "BUG", "ISSUE" } },
    TODO = { icon = " ", color = "info" },
    HACK = { icon = " ", color = "warning" },
    WARN = { icon = " ", color = "warning", alt = { "WARNING", "WARN" } },
    PERF = { icon = "󱎫 ", color = "hint", alt = { "OPTIMIZE" } },
    NOTE = { icon = "󰍨 ", color = "hint", alt = { "INFO" } },
    OK = { icon = " ", color = "info", alt = { "DONE", "SUCCESS" } },
    FIXED = { icon = " ", color = "info", alt = { "RESOLVED", "SOLVED" } },
    LOOKING = { icon = " ", color = "hint", alt = { "RESEARCH", "INVESTIGATE", "MoreDo" } },
  },
  highlight = {
    before = "",          -- no extra highlight before keyword
    keyword = "wide",     -- highlight the keyword and following text
    after = "fg",         -- highlight text after keyword
    pattern = [[.*<(KEYWORDS)\s*:]], -- match "TODO:", "FIX:", etc.
  },

  -- FIXED: 
  search = {
    command = "rg",
    args = {
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
    },
    pattern = [[\b(KEYWORDS):]], -- ripgrep pattern
  },
})
