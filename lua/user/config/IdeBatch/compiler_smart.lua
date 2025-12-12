-- compiler_smart.lua
local M = {}

-- All major C/C++ library flags in one place
-- local C_LIBS = "-lm -lpthread -lrt -ldl -lGL -lGLU -lglut -lSDL2 -lglfw -lcurl -lssl -lcrypto -lz -lpng -ljpeg -lsqlite3"
-- local CPP_LIBS = C_LIBS .. " -lboost_system -lboost_filesystem -lboost_thread"

local C_LIBS = "-Wl,--as-needed -lm -lpthread -ldl"
local CPP_LIBS = C_LIBS

-- Find available compiler
local function get_compiler(compilers)
    for _, compiler in ipairs(compilers) do
        if vim.fn.executable(compiler) == 1 then
            return compiler
        end
    end
    return nil
end

-- Get command for any language
function M.get_command(lang)
    local commands = {
        c = function()
            local compiler = get_compiler({ "gcc", "clang", "cc" }) or "gcc"
            return string.format(
                "cd $dir && %s $fileName -o $fileNameWithoutExt %s 2>/dev/null || %s $fileName -o $fileNameWithoutExt && $dir/$fileNameWithoutExt",
                compiler, C_LIBS, compiler)
        end,

        cpp = function()
            local compiler = get_compiler({ "g++", "clang++", "c++" }) or "g++"
            return string.format(
                "cd $dir && %s $fileName -o $fileNameWithoutExt -std=c++17 %s 2>/dev/null || %s $fileName -o $fileNameWithoutExt -std=c++17 && $dir/$fileNameWithoutExt",
                compiler, CPP_LIBS, compiler)
        end,

        -- Other languages (no libs needed)
        -- rust = "cd $dir && rustc $fileName -o $fileNameWithoutExt && $dir/$fileNameWithoutExt",
        rust =
        'cd $dir && [ -f Cargo.toml ] && cargo run || (rustc $fileName -o $fileNameWithoutExt && $dir/$fileNameWithoutExt)',
        go = "go run",
        python = "python3 -u",
        javascript = "node",
        typescript = "deno run",
        java = "cd $dir && javac $fileName && java $fileNameWithoutExt",
        lua = "lua",
        ruby = "ruby",
        php = "php",
        sh = "bash",
    }

    local cmd = commands[lang]
    return type(cmd) == "function" and cmd() or cmd
end

return M
