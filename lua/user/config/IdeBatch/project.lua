require("project_nvim").setup({
    -- Auto-detection
    detection_methods = { "lsp", "pattern" },

    -- Smart patterns for multiple languages
    patterns = {
        ".git",
        "_darcs", ".hg", ".bzr", ".svn",
        "Makefile",
        -- Web/JS/TS
        "package.json", "tsconfig.json", "jsconfig.json",
        -- Rust
        "Cargo.toml",
        -- Go
        "go.mod",
        -- Python
        "pyproject.toml", "setup.py", "requirements.txt", "Pipfile",
        -- Lua/Neovim
        "init.lua",
        -- Java/Kotlin
        "pom.xml", "build.gradle",
        -- C/C++
        "CMakeLists.txt",
    },

    silent_chdir = true,   -- Clean, no spam
    show_hidden = false,
    scope_chdir = 'global',
    datapath = vim.fn.stdpath("data"),
})

-- Telescope integration
require('telescope').load_extension('projects')

-- MANUAL PROJECT CONTROL KEYBINDINGS

-- Quick project picker
vim.keymap.set('n', '<leader>fp', '<cmd>Telescope projects<cr>',
    { desc = "Find Projects" })

-- Manual root directory changes
vim.keymap.set('n', '<leader>pa', function()
    local project = require("project_nvim.project")
    -- Add current directory as project root
    local cwd = vim.fn.getcwd()
    project.add_project(cwd)
    print("Added project: " .. cwd)
end, { desc = "Add current dir as project" })

vim.keymap.set('n', '<leader>pc', function()
    -- Change to a directory and mark it as project root
    local path = vim.fn.input("Project path: ", "", "dir")
    if path ~= "" then
        vim.cmd("cd " .. path)
        local project = require("project_nvim.project")
        project.add_project(path)
        print("Changed to project: " .. path)
    end
end, { desc = "Change to project (manual)" })

vim.keymap.set('n', '<leader>pr', function()
    -- Set current file's directory as project root
    local project = require("project_nvim.project")
    local file_dir = vim.fn.expand("%:p:h")
    vim.cmd("cd " .. file_dir)
    project.add_project(file_dir)
    print("Set project root: " .. file_dir)
end, { desc = "Set current file's dir as root" })

-- RESESSION WORKFLOW INTEGRATION

-- Auto-save session when leaving a project (via Telescope picker)
-- This creates a seamless project-switching experience
vim.api.nvim_create_autocmd("DirChanged", {
    callback = function()
        -- Optional: auto-save previous project session
        -- Uncomment if you want automatic session saving on project switch
        -- vim.schedule(function()
        --   require("resession").save(vim.fn.getcwd())
        -- end)
    end,
})

-- Helper function: Switch project AND load its session
vim.keymap.set('n', '<leader>fP', function()
    require('telescope').extensions.projects.projects({
        attach_mappings = function(_, map)
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")

            -- Override <CR> to load session after project selection
            map('i', '<CR>', function(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)

                -- Change to project
                vim.cmd("cd " .. selection.value)

                -- Try to load session for this project
                vim.schedule(function()
                    local resession = require("resession")
                    local session_name = selection.value:gsub("/", "_")
                    if resession.load(session_name, { silence_errors = true }) then
                        print("Loaded session: " .. session_name)
                    else
                        print("No session found for: " .. selection.value)
                    end
                end)
            end)

            return true
        end,
    })
end, { desc = "Find Projects + Load Session" })

-- Quick save current project session
vim.keymap.set('n', '<leader>ps', function()
    local cwd = vim.fn.getcwd()
    local session_name = cwd:gsub("/", "_")
    require("resession").save(session_name)
    print("Saved session: " .. session_name)
end, { desc = "Save project session" })
