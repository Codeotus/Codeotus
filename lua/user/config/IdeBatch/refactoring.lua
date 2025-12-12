-- Refactoring.nvim setup
require('refactoring').setup({})

-- Keymaps for refactoring
local opts = { noremap = true, silent = true, desc = "Refactor" }

-- Open refactor menu (visual mode)
vim.keymap.set("v", "<leader>rr", require('refactoring').select_refactor, opts)

-- Common refactors
vim.keymap.set("v", "<leader>re", function()
    require('refactoring').refactor("Extract Function")
end, { desc = "Extract Function" })

vim.keymap.set("v", "<leader>rv", function()
    require('refactoring').refactor("Extract Variable")
end, { desc = "Extract Variable" })

vim.keymap.set("n", "<leader>ri", function()
    require('refactoring').refactor("Inline Variable")
end, { desc = "Inline Variable" })
