local on_attach = function(client, bufnr)
    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local telescope_builtin = require('telescope.builtin')
    local bufopts = { noremap=true, silent=true, buffer=bufnr }

    local definition = require('omnisharp_extended').telescope_lsp_definitions

    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)

    vim.keymap.set('n', 'gd', definition, bufopts)
    vim.keymap.set('n', 'gi', telescope_builtin.lsp_implementations, bufopts)
    vim.keymap.set('n', 'gr', telescope_builtin.lsp_references, bufopts)
    vim.keymap.set('n', '<space>D', telescope_builtin.lsp_type_definitions, bufopts)

    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
end

local lsp_flags = {
    -- This is the default in Nvim 0.7+
    debounce_text_changes = 150,
}
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

require('lspconfig').omnisharp.setup {
    on_attach = function (client, bufnr) 
        -- Ironically, omnisharp does not adhere to LSP spec
        client.server_capabilities["semanticTokensProvider"] = nil
        on_attach(client, bufnr)
    end,
    flags = lsp_flags,
    capabilities = capabilities,
    handlers = {
        -- Download source
        ["textDocument/definition"] = function ()
            return require('omnisharp_extended').handler
        end
    }
}
