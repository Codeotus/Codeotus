local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.setup({
    defaults = {
        -- Better matching algorithms
        sorting_strategy = "ascending",
        selection_strategy = "reset",
        scroll_strategy = "cycle",

        -- Fuzzy matching improvements
        file_sorter = require("telescope.sorters").get_fzf_sorter,
        generic_sorter = require("telescope.sorters").get_fzf_sorter,
        -- Show only most relevant results
        layout_strategy = "flex",
        layout_config = {
            flex = {
                flip_columns = 120,
            },
        },

        -- UI improvements
        results_title = false,
        prompt_prefix = " ",
        selection_caret = " ",
        entry_prefix = "  ",

        -- Show fewer results, but more relevant
        -- Uncomment to limit results (makes it snappier)
        -- cache_picker = { num_pickers = 10 },

        -- Better file filtering
        file_ignore_patterns = {
            "node_modules",
            ".git/",
            "__pycache__",
            "%.lock",
            "%.jpg",
            "%.jpeg",
            "%.png",
            "%.svg",
            "%.otf",
            "%.ttf",
        },

        path_display = { "smart" }, -- smarter than truncate
        winblend = 0,
        preview = {
            hide_on_startup = true,
        },
        previewer = false,

        -- Better matching behavior
        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            "--trim", -- trim whitespace
        },

        mappings = {
            i = {
                ["<leader>fp"] = require("telescope.actions.layout").toggle_preview,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                ["<cr>"] = actions.select_default,
            },
            n = {
                ["<leader>fp"] = require("telescope.actions.layout").toggle_preview,
                ["q"] = actions.close,
            },
        },
    },

    pickers = {
        find_files = {
            hidden = true,
            cwd = vim.fn.expand("~"),
            find_command = { "rg", "--files", "--hidden", "--smart-case" },
            -- Show top 50 most relevant results initially
            -- results_title = "Files",
        },

        buffers = {
            sort_mru = true,
            sort_lastused = true,
            ignore_current_buffer = true,
            -- Show only open buffers first
            only_cwd = false,
        },

        live_grep = {
            -- Jump to best match faster
            only_sort_text = true,
            additional_args = function()
                return { "--hidden", "--smart-case" }
            end,
        },

        grep_string = {
            only_sort_text = true,
        },
    },

    extensions = {
        file_browser = {
            path = vim.fn.expand("~"),
            hidden = true,
            grouped = true,
            respect_gitignore = false,
            hijack_netrw = true,
            previewer = false,
            -- Better sorting for file browser
            sorting_strategy = "ascending",
        },

        -- Optional: fzf native for MUCH better performance
        -- Uncomment if you have telescope-fzf-native installed
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        },
    },
})

-- Load extensions
-- telescope.load_extension("file_browser")

-- Optional but HIGHLY recommended for better matching:
-- Install telescope-fzf-native.nvim and uncomment:
telescope.load_extension("fzf")
telescope.load_extension("file_browser")
