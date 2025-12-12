local compiler = require("user.config.IdeBatch.compiler_smart")

require("code_runner").setup({
    mode = "toggleterm",
    focus = true,
    startinsert = false,

    filetype = {
        c = compiler.get_command("c"),
        cpp = compiler.get_command("cpp"),
        rust = compiler.get_command("rust"),
        go = compiler.get_command("go"),
        python = compiler.get_command("python"),
        javascript = compiler.get_command("javascript"),
        typescript = compiler.get_command("typescript"),
        java = compiler.get_command("java"),
        lua = compiler.get_command("lua"),
        ruby = compiler.get_command("ruby"),
        php = compiler.get_command("php"),
        sh = compiler.get_command("sh"),
    },
})

vim.keymap.set("n", "<leader>zz", ":RunCode<CR>", { desc = "Run Code" })
