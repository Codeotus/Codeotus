require('ufo').setup({
    open_fold_hl_timeout = 150,
    close_fold_kinds_for_ft = {
        default = { 'imports', 'comment' },
    },
    preview = {
        win_config = {
            border = { '', '─', '', '', '', '─', '', '' },
            winhighlight = 'Normal:Folded',
            winblend = 0
        },
        mappings = {
            scrollU = '<C-u>',
            scrollD = '<C-d>',
            jumpTop = '[',
            jumpBot = ']'
        }
    },
    provider_selector = function(bufnr, filetype, buftype)
        return { 'treesitter', 'indent' }
    end
})
-- Fold settings
-- vim.o.foldcolumn = '1'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Using ufo provider needs a large value
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99

-- Don't map to za as za helps to toggle code folding.
vim.keymap.set('n', "<leader>zo", "Code Fold", { desc = "Code Fold with ufo" })
vim.keymap.set('n', "<leader>zoa", require('ufo').openAllFolds, { desc = "Open all folds" })
vim.keymap.set('n', "<leader>zoc", require('ufo').closeAllFolds, { desc = "Close all folds" })
vim.keymap.set('n', "<leader>zok", require('ufo').openFoldsExceptKinds, { desc = "Open folds except kinds" })
vim.keymap.set('n', "<leader>zow", require('ufo').closeFoldsWith, { desc = "Close folds with" })
vim.keymap.set('n', "<leader>zop", function()
    local winid = require('ufo').peekFoldedLinesUnderCursor()
    if not winid then
        vim.lsp.buf.hover()
    end
end, { desc = "Peek fold lines under cursor" })
