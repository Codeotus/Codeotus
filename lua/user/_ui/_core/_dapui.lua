-- =====================
-- Debugger (DAP + UI) - Max Level
-- =====================
local dap = require("dap")
local dapui = require("dapui")
local dapvt = require("nvim-dap-virtual-text") -- virtual text for variable values

-- -------------------------
-- 1. Setup DAP UI
-- -------------------------
dapui.setup({
    icons = { expanded = "▾", collapsed = "▸" },
    mappings = {
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
    },
    layouts = {
        {
            elements = { "scopes", "breakpoints", "stacks", "watches" },
            size = 40,
            position = "left",
        },
        {
            elements = { "repl" },
            size = 10,
            position = "bottom",
        },
    },
    floating = { border = "rounded", mappings = { close = { "q", "<Esc>" } } },
    windows = { indent = 1 },
})

-- Enable virtual text (line-wise variable values)
dapvt.setup({
    enabled = true,
    enabled_commands = true,
    highlight_changed_variables = true,
    show_stop_reason = true,
    commented = false,
})

-- -------------------------
-- 2. Auto-open/close UI
-- -------------------------
dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

-- -------------------------
-- 3. Keymaps
-- -------------------------
local km = vim.keymap.set
km("n", "<leader>db", dap.toggle_breakpoint)
km("n", "<leader>dB", function() dap.set_breakpoint(vim.fn.input("Condition: ")) end)
km("n", "<leader>dl", function() dap.set_breakpoint(nil, nil, vim.fn.input("Log point: ")) end)
km("n", "<leader>dc", dap.continue)
km("n", "<leader>do", dap.step_over)
km("n", "<leader>di", dap.step_into)
km("n", "<leader>du", dap.step_out)
km("n", "<leader>dr", dap.repl.open)
km("n", "<leader>de", dapui.eval)
km("v", "<leader>de", dapui.eval)

-- -------------------------
-- 4. Language Adapters & Configurations
-- -------------------------

-- Python
dap.adapters.python = { type = "executable", command = "python", args = { "-m", "debugpy.adapter" } }
dap.configurations.python = { { type = "python", request = "launch", name = "Launch file", program = "${file}" } }

-- C / C++ / Rust / x86_64 ASM
dap.adapters.cppdbg = { type = "executable", command = "/path/to/OpenDebugAD7" }
dap.configurations.cpp = {
    {
        name = "Launch file",
        type = "cppdbg",
        request = "launch",
        program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file") end,
        cwd = "${workspaceFolder}",
        stopAtEntry = true,
    },
}
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp
dap.configurations.asm = dap.configurations.cpp -- ASM support (x86_64 binary)

-- Go
dap.adapters.go = { type = "server", host = "127.0.0.1", port = 38697 }
dap.configurations.go = { { type = "go", request = "launch", name = "Debug", program = "${file}" } }

-- Node.js / JS / TS
dap.adapters.node2 = { type = "executable", command = "node", args = { "/path/to/vscode-node-debug2/out/src/nodeDebug.js" } }
dap.configurations.javascript = { { type = "node2", request = "launch", program = "${file}" } }
dap.configurations.typescript = dap.configurations.javascript

-- Lua (Neovim)
dap.adapters.nlua = function(callback, config)
    callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
end
dap.configurations.lua = { { type = "nlua", request = "attach", name = "Attach to Neovim" } }

-- PHP
dap.adapters.php = { type = "executable", command = "php-debug-adapter" }
dap.configurations.php = { { type = "php", request = "launch", name = "Launch file", program = "${file}" } }

-- Ruby
dap.adapters.ruby = { type = "executable", command = "rdbg", args = { "--open" } }
dap.configurations.ruby = { { type = "ruby", request = "launch", name = "Launch file", program = "${file}" } }

-- Java
dap.adapters.java = { type = "executable", command = "java-debug-adapter" }
dap.configurations.java = { { type = "java", request = "launch", name = "Launch file", mainClass = "${file}" } }

-- You can add more languages here by adding dap.adapters and dap.configurations entries
