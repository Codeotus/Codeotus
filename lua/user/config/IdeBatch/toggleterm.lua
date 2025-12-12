-- Advanced ToggleTerm Configuration
-- Main toggle: Ctrl+Space
-- Leader x family: xf (float), xb (bottom), xs (horizontal split), xv (vertical split)

require("toggleterm").setup({
    -- Size configuration
    size = function(term)
        if term.direction == "horizontal" then
            return 15
        elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
        end
    end,

    -- VSCode-like bottom terminal by default
    open_mapping = [[<C-Space>]],
    hide_numbers = true,
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    terminal_mappings = true,
    persist_size = true,
    persist_mode = true,
    direction = 'horizontal', -- VSCode-like bottom terminal
    close_on_exit = true,
    shell = vim.o.shell,

    -- Advanced styling
    float_opts = {
        border = 'curved',
        width = math.floor(vim.o.columns * 0.9),
        height = math.floor(vim.o.lines * 0.9),
        winblend = 3,
        highlights = {
            border = "Normal",
            background = "Normal",
        }
    },

    -- Better window management
    winbar = {
        enabled = false,
    },

    -- Auto scroll to bottom on output
    auto_scroll = true,
})

-- Terminal instances for different types
local Terminal = require('toggleterm.terminal').Terminal

-- 1. Default horizontal terminal (VSCode-like, Ctrl+Space)
local horizontal_term = Terminal:new({
    direction = "horizontal",
    hidden = true,
    count = 1,
})

function _HORIZONTAL_TOGGLE()
    horizontal_term:toggle()
end

-- 2. Floating terminal (leader xf)
local float_term = Terminal:new({
    direction = "float",
    hidden = true,
    count = 2,
    float_opts = {
        border = 'curved',
        width = math.floor(vim.o.columns * 0.9),
        height = math.floor(vim.o.lines * 0.9),
    }
})

function _FLOAT_TOGGLE()
    float_term:toggle()
end

-- 3. Bottom terminal (leader xb)
local bottom_term = Terminal:new({
    direction = "horizontal",
    hidden = true,
    count = 3,
})

function _BOTTOM_TOGGLE()
    bottom_term:toggle()
end

-- 4. Horizontal split terminal (leader xs)
local hsplit_term = Terminal:new({
    direction = "horizontal",
    hidden = true,
    count = 4,
    size = 20,
})

function _HSPLIT_TOGGLE()
    hsplit_term:toggle()
end

-- 5. Vertical split terminal (leader xv)
local vsplit_term = Terminal:new({
    direction = "vertical",
    hidden = true,
    count = 5,
})

function _VSPLIT_TOGGLE()
    vsplit_term:toggle()
end

-- 6. Lazygit integration (leader xg)
local lazygit = Terminal:new({
    cmd = "lazygit",
    direction = "float",
    hidden = true,
    count = 6,
    float_opts = {
        border = 'curved',
        width = math.floor(vim.o.columns * 0.95),
        height = math.floor(vim.o.lines * 0.95),
    },
    on_open = function(term)
        vim.cmd("startinsert!")
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
    end,
})

function _LAZYGIT_TOGGLE()
    lazygit:toggle()
end

-- 7. Node REPL (leader xn)
local node = Terminal:new({
    cmd = "node",
    direction = "float",
    hidden = true,
    count = 7,
})

function _NODE_TOGGLE()
    node:toggle()
end

-- 8. Python REPL (leader xp)
local python = Terminal:new({
    cmd = "python3",
    direction = "float",
    hidden = true,
    count = 8,
})

function _PYTHON_TOGGLE()
    python:toggle()
end

-- 9. Htop (leader xh)
local htop = Terminal:new({
    cmd = "htop",
    direction = "float",
    hidden = true,
    count = 9,
    float_opts = {
        border = 'curved',
        width = math.floor(vim.o.columns * 0.9),
        height = math.floor(vim.o.lines * 0.9),
    },
})

function _HTOP_TOGGLE()
    htop:toggle()
end

-- Key mappings
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Main toggle: Ctrl+Space (VSCode-like horizontal terminal)
keymap('n', '<C-Space>', '<cmd>lua _HORIZONTAL_TOGGLE()<CR>', opts)
keymap('t', '<C-Space>', '<cmd>lua _HORIZONTAL_TOGGLE()<CR>', opts)

-- Leader x family keybindings
keymap('n', '<leader>xf', '<cmd>lua _FLOAT_TOGGLE()<CR>',
    { noremap = true, silent = true, desc = "Toggle floating terminal" })
keymap('n', '<leader>xb', '<cmd>lua _BOTTOM_TOGGLE()<CR>',
    { noremap = true, silent = true, desc = "Toggle bottom terminal" })
keymap('n', '<leader>xs', '<cmd>lua _HSPLIT_TOGGLE()<CR>',
    { noremap = true, silent = true, desc = "Toggle horizontal split terminal" })
keymap('n', '<leader>xv', '<cmd>lua _VSPLIT_TOGGLE()<CR>',
    { noremap = true, silent = true, desc = "Toggle vertical split terminal" })
keymap('n', '<leader>xg', '<cmd>lua _LAZYGIT_TOGGLE()<CR>', { noremap = true, silent = true, desc = "Toggle lazygit" })
keymap('n', '<leader>xn', '<cmd>lua _NODE_TOGGLE()<CR>', { noremap = true, silent = true, desc = "Toggle Node REPL" })
keymap('n', '<leader>xp', '<cmd>lua _PYTHON_TOGGLE()<CR>', { noremap = true, silent = true, desc = "Toggle Python REPL" })
keymap('n', '<leader>xh', '<cmd>lua _HTOP_TOGGLE()<CR>', { noremap = true, silent = true, desc = "Toggle htop" })

-- Additional useful terminal keybindings
keymap('n', '<leader>xa', '<cmd>ToggleTermToggleAll<CR>',
    { noremap = true, silent = true, desc = "Toggle all terminals" })
keymap('n', '<leader>xt', '<cmd>ToggleTermSendCurrentLine<CR>',
    { noremap = true, silent = true, desc = "Send current line to terminal" })
keymap('v', '<leader>xt', '<cmd>ToggleTermSendVisualSelection<CR>',
    { noremap = true, silent = true, desc = "Send visual selection to terminal" })

-- Terminal mode navigation (better escape and movement)
function _G.set_terminal_keymaps()
    local t_opts = { buffer = 0 }
    -- ESC to exit terminal mode (double tap)
    keymap('t', '<esc><esc>', [[<C-\><C-n>]], t_opts)

    -- Window navigation from terminal
    keymap('t', '<C-h>', [[<Cmd>wincmd h<CR>]], t_opts)
    keymap('t', '<C-j>', [[<Cmd>wincmd j<CR>]], t_opts)
    keymap('t', '<C-k>', [[<Cmd>wincmd k<CR>]], t_opts)
    keymap('t', '<C-l>', [[<Cmd>wincmd l<CR>]], t_opts)

    -- Resize windows in terminal mode
    keymap('t', '<C-Left>', [[<Cmd>vertical resize -2<CR>]], t_opts)
    keymap('t', '<C-Right>', [[<Cmd>vertical resize +2<CR>]], t_opts)
    keymap('t', '<C-Up>', [[<Cmd>resize -2<CR>]], t_opts)
    keymap('t', '<C-Down>', [[<Cmd>resize +2<CR>]], t_opts)
end

-- Apply terminal keymaps when entering terminal
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

-- Auto insert mode when entering terminal
vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
    pattern = "term://*",
    callback = function()
        vim.cmd("startinsert")
    end
})

-- Status indicator
vim.api.nvim_create_user_command('TerminalStatus', function()
    print("ToggleTerm Advanced Configuration Loaded")
    print("Main: Ctrl+Space | Float: <leader>xf | Bottom: <leader>xb")
    print("H-Split: <leader>xs | V-Split: <leader>xv")
    print("LazyGit: <leader>xg | Node: <leader>xn | Python: <leader>xp")
    print("Htop: <leader>xh | Toggle All: <leader>xa")
end, {})
