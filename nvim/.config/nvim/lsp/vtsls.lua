local mason_path = require('mason.settings').current.install_root_dir

return {
    settings = {
        vtsls = {
            tsserver = {
                globalPlugins = {
                    {
                        name = '@vue/typescript-plugin',
                        location = mason_path .. '/packages/vue-language-server',
                        languages = { 'vue' },
                        configNamespace = 'typescript',
                    }
                }
            },
        }
    },
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' }
}
