vim.lsp.config('vtsls', {
    settings = {
        vtsls = {
            tsserver = {
                globalPlugins = {
                    {
                        name = '@vue/typescript-plugin',
                        location = vim.fs.normalize(
                            vim.fs.dirname(vim.fn.resolve(vim.fn.exepath('vue-language-server'))) ..
                            '/../lib/language-tools/packages/language-server'
                        ),
                        languages = { 'vue' },
                        configNamespace = 'typescript',
                        enableForWorkspaceTypeScriptVersions = true,
                    }
                }
            },
        }
    },
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' }
})
