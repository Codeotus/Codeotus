-- ============================
-- Neovim Init File
-- ============================

-- ----------------------------
-- Safe Require Helper
-- ----------------------------
local function safe_require(module)
    local ok, result = pcall(require, module)
    if not ok then
        vim.notify(
            "Failed to load: " .. module .. "\n" .. tostring(result),
            vim.log.levels.ERROR,
            { title = "Module Load Error" }
        )
        return nil
    end
    return result
end

-- ============= ============= ============= =============
-- 1. System core override
-- ============= ============= ============= =============
safe_require("user._ui._core._itallic0")
safe_require("user.sys.directMap.quit_save")
safe_require("user.sys.directMap.buf_cycle")
safe_require("user.sys.plugins")

-- ============= ============= ============= =============
-- 1. Inbuilt core
-- ============= ============= ============= =============
safe_require("user.sys.inbuilt.last_pos")


-- ============= ============= ============= =============
-- 1. BASIC SETTINGS CORE
-- ============= ============= ============= =============
safe_require("user.sys.env")
safe_require("user.sys.options")
safe_require("user.sys.mappings")
safe_require("user.sys.autoreload")
safe_require("user.sys.utilities")
safe_require("user.sys.mason")
-- ============= ============= ============= =============
-- 1. BASIC SETTINGS CORE
-- ============= ============= ============= =============

-- ============= ============= ============= =============
--  2. ui CORE (Overridden)
-- ============= ============= ============= =============

safe_require("user._ui._core._dashboard")
safe_require("user._ui._core._dapui")
safe_require("user._ui._core._diagonasticsigns")
safe_require("user._ui._core._ibl")
safe_require("user._ui._core._bufferline")
safe_require("user._ui._core._statusline")
safe_require("user._ui._core._dressing")
safe_require("user._ui._core._windows")
safe_require("user._ui._core._sgt")
safe_require("user._ui._core._notify")
safe_require("user._ui._core._ascii")

-- ============= ============= ============= =============
--  2. Custom treesitter
-- ============= ============= ============= =============

safe_require("user._ui._customts.ts_file_call")
safe_require("user._ui._customts.gruvbox_ts")


-- ============= ============= ============= =============
--  2. Cherry on top
-- ============= ============= ============= =============
safe_require("user._ui.cherry.custom_treesitters")
safe_require("user._ui.cherry.gitsigns")
-- safe_require("user._ui.cherry.snacks") backup only for mini.notify
-- safe_require("user._ui.cherry.bold_text")
-- safe_require("user._ui.cherry.noice")
safe_require("user._ui.cherry.theme")
safe_require("user._ui.cherry.colors")

-- ============= ============= ============= =============
-- 3. Mini Eco_system
-- ============= ============= ============= =============
safe_require("user.ecosys.mini.mini_surround")
safe_require("user.ecosys.mini.mini_notify")
safe_require("user.ecosys.mini.mini_icons")
safe_require("user.ecosys.mini.mini_animate")
safe_require("user.ecosys.mini.mini_jump")


-- ============= ============= ============= =============
-- 4. LspConfig Setup
-- ============= ============= ============= =============

-- HighLevel
safe_require("user.config.LspConfig.HighLevel.lua_ls")
safe_require("user.config.LspConfig.HighLevel.pyright")

-- LowLevel
safe_require("user.config.LspConfig.LowLevel.asm")
safe_require("user.config.LspConfig.LowLevel.clang")
safe_require("user.config.LspConfig.LowLevel.cmake")
safe_require("user.config.LspConfig.LowLevel.rust_analyzer")
safe_require("user.config.LspConfig.LowLevel.zls")

-- Productive
safe_require("user.config.LspConfig.Productive.bash_ls")
safe_require("user.config.LspConfig.Productive.marksman")
safe_require("user.config.LspConfig.Productive.vimls")

-- Utilities
safe_require("user.config.LspConfig.Utilities.dockerls")
safe_require("user.config.LspConfig.Utilities.jsonls")
safe_require("user.config.LspConfig.Utilities.yamlls")

-- Web
safe_require("user.config.LspConfig.Web.css_ls")
safe_require("user.config.LspConfig.Web.gopls")
safe_require("user.config.LspConfig.Web.html")
safe_require("user.config.LspConfig.Web.phpactor")
safe_require("user.config.LspConfig.Web.vtsls")

-- Activate Them all --
safe_require("user.config.LspBatch.lsp")
-- ============= ============= ============= =============
-- 5. LspBatch Setup
-- ============= ============= ============= =============
-- safe_require("user.config.LspBatch.cmp") -- Comment this for blink completion

--[[
--]]
safe_require("user.config.LspBatch.cmd_cmp")  -- Comment this if using nvim completion
safe_require("user.config.LspBatch.blinkCmp") -- Comment this if using nvim completion

safe_require("user.config.LspBatch.autopairs")
safe_require("user.config.LspBatch.formatter")
safe_require("user.config.LspBatch.luasnip")
safe_require("user.config.LspBatch.lspkind")
safe_require("user.config.LspBatch.navic")

-- ============= ============= ============= =============
-- 5. LspBatch Setup
-- ============= ============= ============= =============

safe_require("user.config.IdeBatch.code_runner_on_click")
safe_require("user.config.IdeBatch.nvimtree")
safe_require("user.config.IdeBatch.telescope")
safe_require("user.config.IdeBatch.toggleterm")
safe_require("user.config.IdeBatch.project")
safe_require("user.config.IdeBatch.sessions")
safe_require("user.config.LspBatch.trouble")
safe_require("user.config.IdeBatch.snipe")
safe_require("user.config.IdeBatch.todo")
safe_require("user.config.IdeBatch.sessions")
safe_require("user.config.IdeBatch.whkey")
safe_require("user.config.IdeBatch.multiselect")
safe_require("user.config.IdeBatch.treesitter")
safe_require("user.config.IdeBatch.showkey")
safe_require("user.config.IdeBatch.surround")
safe_require("user.config.IdeBatch.arrow")
safe_require("user.config.IdeBatch.comments")
safe_require("user.config.IdeBatch.lazygit")
safe_require("user.config.IdeBatch.flash")
safe_require("user.config.IdeBatch.undotree")
safe_require("user.config.IdeBatch.yanky")
safe_require("user.config.IdeBatch.oil")
safe_require("user.config.IdeBatch.file_organizer_setup")

-- ============= ============= ============= =============
-- 4. Call the Inbuilt
-- ============= ============= ============= =============

safe_require("user.config.IdeBatch.call.autosave")
safe_require("user.config.IdeBatch.call.notific")

-- ============= ============= ============= =============
-- 4. PluginExtensionConfiguration
-- ============= ============= ============= =============
safe_require("user.other.extconfig.overseer")


-- ============= ============= ============= =============
-- 6. Custom Cmp
-- ============= ============= ============= =============

-- NOTE: IS CURRENTLY IN NON-PRODUCTION READY BUT WORKING STATE !

-- safe_require("user._other._cmp.cmp-gd")


-- ============= ============= ============= ============= =============
-- Load the colorscheme at last !
-- ============= ============= ============= ============= =============
-- NOTE: SGT colorsheme_name will override
vim.cmd.colorscheme("gruvbox")
