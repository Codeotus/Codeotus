-- Complete blink.cmp configuration
-- Works on all window sizes, toggleable docs, auto-insert first item

-- State for toggleable documentation
local docs_enabled = true

require('blink.cmp').setup({
    -- Keymap configuration
    keymap = {
        preset = 'default',

        -- Accept completion (inserts the selected item)
        ['<CR>'] = { 'accept', 'fallback' },
        ['<Tab>'] = { 'select_next', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'fallback' },

        -- Scroll documentation
        ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
        ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },

        -- Show/hide documentation manually
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },

        -- Navigation
        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },

        -- Cancel completion
        ['<C-e>'] = { 'hide', 'fallback' },
    },

    -- Appearance
    appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = 'mono',

        -- Beautiful kind icons
        kind_icons = {
            Text          = '󰉿',
            Method        = '󰊕',
            Function      = '󰊕',
            Constructor   = '󰒓',
            Field         = '󰜢',
            Variable      = '󰀫',
            Property      = '',
            Class         = '',
            Interface     = '',
            Struct        = '󰆼',
            Module        = '󰅩',
            Unit          = '󰪚',
            Value         = '󰦨',
            Enum          = '',
            EnumMember    = '',
            Keyword       = '󰻾',
            Constant      = '󰏿',
            Snippet       = '',
            Color         = '󰏘',
            File          = '󰈔',
            Reference     = '󰬲',
            Folder        = '󰉋',
            Event         = '',
            Operator      = '󰪚',
            TypeParameter = '󰬛',
        },
    },

    -- Completion behavior
    completion = {
        -- Auto-select first item and insert on <CR>
        list = {
            selection = {
                preselect = true,
                auto_insert = true,
            }
        },

        -- Accept behavior
        accept = {
            auto_brackets = {
                enabled = true, -- Automatically add brackets for functions
            },
        },

        -- Menu configuration (adaptive for all screen sizes)
        menu = {
            max_height = 10, -- Reasonable height for most screens
            min_width = 15,  -- Minimum width

            draw = {
                columns = {
                    { "kind_icon", "label", gap = 1 },
                    { "kind" }
                },

                components = {
                    kind_icon = {
                        text = function(ctx)
                            return ctx.kind_icon .. ' '
                        end,
                        highlight = function(ctx)
                            return 'BlinkCmpKind' .. ctx.kind
                        end,
                    },

                    label = {
                        width = { fill = true, max = 40 }, -- Adaptive width
                        text = function(ctx) return ctx.label end,
                        highlight = function(ctx)
                            return ctx.deprecated and 'BlinkCmpLabelDeprecated' or 'BlinkCmpLabel'
                        end,
                    },

                    kind = {
                        width = { max = 15 },
                        text = function(ctx) return ctx.kind end,
                        highlight = function(ctx)
                            return 'BlinkCmpKind' .. ctx.kind
                        end,
                    },
                },
            },

            border = 'rounded',
            scrollbar = true,
            auto_show = true,
        },

        -- Documentation window (toggleable)
        documentation = {
            auto_show = true,         -- Show docs automatically
            auto_show_delay_ms = 200, -- Small delay before showing

            window = {
                min_width = 20,
                max_width = 80, -- Works well on most screens
                max_height = 20,
                border = 'rounded',
            },
        },

        -- Ghost text (shows completion inline)
        ghost_text = {
            enabled = false,
        },
    },

    -- Signature help configuration
    signature = {
        enabled = true,
        window = {
            max_width = 80,
            max_height = 12,
            border = 'rounded',
        },
    },

    -- Sources configuration
    sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },

        -- Per-filetype sources (optional)
        -- providers = {
        --   lsp = { name = 'LSP' },
        --   path = { name = 'Path' },
        --   snippets = { name = 'Snippets' },
        --   buffer = { name = 'Buffer' },
        -- },
    },
})

-- Toggle documentation function
local function toggle_blink_docs()
    docs_enabled = not docs_enabled

    require('blink.cmp').setup({
        completion = {
            documentation = {
                auto_show = docs_enabled,
            },
        },
    })

    vim.notify('Blink docs: ' .. (docs_enabled and 'ON' or 'OFF'), vim.log.levels.INFO)
end

-- Create command and keybinding for toggling docs
vim.api.nvim_create_user_command('ToggleBlinkDocs', toggle_blink_docs, { desc = 'Toggle blink.cmp documentation' })
vim.keymap.set('i', '<C-h>', toggle_blink_docs, { desc = 'Toggle blink docs (insert mode)' })

-- Optional: Smaller config for very small screens (uncomment if needed)
--[[
vim.api.nvim_create_autocmd('VimResized', {
  callback = function()
    local width = vim.o.columns
    if width < 100 then
      -- Apply compact config for small screens
      require('blink.cmp').setup({
        completion = {
          menu = {
            max_height = 8,
            draw = {
              columns = { { "kind_icon", "label", gap = 1 } },
              components = {
                label = { width = { fill = true, max = 30 } },
              },
            },
          },
          documentation = {
            window = {
              max_width = 40,
              max_height = 12,
            },
          },
        },
      })
    end
  end,
})
--]]
