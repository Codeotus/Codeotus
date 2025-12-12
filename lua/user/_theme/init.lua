local M = {}

local colors = {
    bg = '#000000',
    fg = '#FFFFFF',

}

function M.colorscheme()
    vim.cmd('highlight clear')
    vim.cmd('syntax clear')

    vim.o.background = 'dark';
    vim.g.colors_name = 'MyTheme';

    local set = vim.api.nvim_set_hl
    set(0, 'Normal', { bg = colors.bg, fg = colors.fg })
    print("Colorscheme applied!") -- Debug line
end

return M
