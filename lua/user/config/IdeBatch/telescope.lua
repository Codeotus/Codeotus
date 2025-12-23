require('telescope').setup({
    defaults = {
        -- Layout
        layout_strategy = 'flex',
        layout_config = {
            horizontal = {
                preview_width = 0.55,
                results_width = 0.8,
            },
            vertical = {
                mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
            flex = {
                flip_columns = 120,
            },
        },

        -- Sorting & matching - CASE INSENSITIVE
        sorting_strategy = "ascending",
        selection_strategy = "reset",
        file_ignore_patterns = {
            "node_modules/",
            ".git/",
            "dist/",
            "build/",
            "%.lock",
            "target/",
        },

        -- UI - minimal and clean
        prompt_prefix = " ",
        selection_caret = " ",
        entry_prefix = "  ",
        multi_icon = "󰄵 ",
        borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },

        -- Performance
        path_display = { "absolute" }, -- SHOWS FULL PATH
        dynamic_preview_title = true,
        results_title = false,

        -- Behavior
        wrap_results = false,
        scroll_strategy = "cycle",

        -- Better previewer
        preview = {
            treesitter = true,
        },

        -- CASE INSENSITIVE matching
        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case", -- Smart case: case insensitive unless you type uppercase
        },

        -- Fast mappings
        mappings = {
            i = {
                ["<C-j>"] = "move_selection_next",
                ["<C-k>"] = "move_selection_previous",
                ["<C-n>"] = "move_selection_next",
                ["<C-p>"] = "move_selection_previous",

                ["<C-q>"] = "close",
                ["<esc>"] = "close",

                ["<CR>"] = "select_default",
                ["<C-x>"] = "select_horizontal",
                ["<C-v>"] = "select_vertical",
                ["<C-t>"] = "select_tab",

                ["<C-u>"] = "preview_scrolling_up",
                ["<C-d>"] = "preview_scrolling_down",

                ["<C-s>"] = "toggle_selection",
                ["<C-a>"] = "toggle_all",

                ["<C-c>"] = "close",
            },
            n = {
                ["<C-q>"] = "close",
                ["q"] = "close",

                ["<CR>"] = "select_default",
                ["x"] = "select_horizontal",
                ["v"] = "select_vertical",
                ["t"] = "select_tab",

                ["j"] = "move_selection_next",
                ["k"] = "move_selection_previous",

                ["<C-u>"] = "preview_scrolling_up",
                ["<C-d>"] = "preview_scrolling_down",

                ["s"] = "toggle_selection",
                ["a"] = "toggle_all",
            },
        },
    },

    pickers = {
        -- File pickers
        find_files = {
            hidden = true,
            find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
            path_display = { "absolute" }, -- FULL PATH
        },

        oldfiles = {
            prompt_title = "Recent Files",
            cwd_only = true,
            path_display = { "absolute" }, -- FULL PATH
        },

        -- Search pickers
        live_grep = {
            additional_args = function()
                return { "--hidden", "--glob", "!.git/*" }
            end,
            path_display = { "absolute" }, -- FULL PATH
        },

        grep_string = {
            additional_args = function()
                return { "--hidden", "--glob", "!.git/*" }
            end,
            path_display = { "absolute" }, -- FULL PATH
        },

        -- Buffer picker
        buffers = {
            sort_lastused = true,
            sort_mru = true,
            show_all_buffers = true,
            ignore_current_buffer = false,
            path_display = { "absolute" }, -- FULL PATH
            mappings = {
                i = {
                    ["<c-d>"] = "delete_buffer",
                },
                n = {
                    ["d"] = "delete_buffer",
                },
            },
        },

        -- LSP pickers
        lsp_references = {
            show_line = false,
            path_display = { "absolute" }, -- FULL PATH
        },

        lsp_definitions = {
            path_display = { "absolute" }, -- FULL PATH
        },

        lsp_document_symbols = {
            symbol_width = 50,
        },

        -- Git pickers
        git_files = {
            show_untracked = true,
            path_display = { "absolute" }, -- FULL PATH
        },

        git_status = {
            path_display = { "absolute" }, -- FULL PATH
            git_icons = {
                added = " ",
                changed = " ",
                copied = " ",
                deleted = " ",
                renamed = "➡",
                unmerged = " ",
                untracked = " ",
            },
        },

        -- Other pickers
        colorscheme = {
            enable_preview = true,
        },

        help_tags = {
            mappings = {
                i = {
                    ["<CR>"] = "select_default",
                },
            },
        },
    },

    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case", -- CASE INSENSITIVE (smart: insensitive unless you type uppercase)
        },

        file_browser = {
            theme = "ivy",
            hijack_netrw = true,
            hidden = true,
            grouped = true,
            previewer = true,
            initial_mode = "normal",
            path_display = { "absolute" }, -- FULL PATH
            mappings = {
                ["i"] = {
                    ["<C-n>"] = require("telescope._extensions.file_browser.actions").create,
                    ["<C-r>"] = require("telescope._extensions.file_browser.actions").rename,
                    ["<C-d>"] = require("telescope._extensions.file_browser.actions").remove,
                    ["<C-h>"] = require("telescope._extensions.file_browser.actions").toggle_hidden,
                },
                ["n"] = {
                    ["c"] = require("telescope._extensions.file_browser.actions").create,
                    -- ["r"] = require("telescope._extensions.file_browser.actions").rename,
                    ["d"] = require("telescope._extensions.file_browser.actions").remove,
                    ["h"] = require("telescope._extensions.file_browser.actions").goto_parent_dir,
                    ["l"] = "select_default",
                    ["."] = require("telescope._extensions.file_browser.actions").toggle_hidden,
                    ["/"] = function()
                        vim.cmd('startinsert')
                    end,
                },
            },
        },
    },
})

-- Load extensions
require('telescope').load_extension('fzf')
require('telescope').load_extension('file_browser')
