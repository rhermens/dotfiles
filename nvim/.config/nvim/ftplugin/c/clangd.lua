local esp = require('esp32')

esp.setup({
    build_dir = "build",
    clangd_args = {
        "--query-driver=" .. vim.fn.expand("~") .. "/.espressif/tools/esp-clang/*/esp-clang/bin/clang,"
            .. vim.fn.expand("~") .. "/.espressif/tools/esp-clang/*/esp-clang/bin/clang++",
    },
});

vim.lsp.config('clangd', esp.lsp_config());
