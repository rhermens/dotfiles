local statusline = require('mini.statusline')

statusline.setup({
    content = {
        active = function()
            local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
            local git           = statusline.section_git({ trunc_width = 40 })
            local diff          = statusline.section_diff({ trunc_width = 75 })
            local diagnostics   = statusline.section_diagnostics({ trunc_width = 75 })
            local lsp           = statusline.section_lsp({ trunc_width = 75 })
            local filename      = statusline.section_filename({ trunc_width = 140 })
            local fileinfo      = statusline.section_fileinfo({ trunc_width = 120 })

            return statusline.combine_groups({
                { hl = mode_hl,                 strings = { mode } },
                { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
                '%=', -- End left alignment
                { hl = 'MiniStatuslineFilename', strings = { filename } },
                '%<', -- Mark general truncate point
                { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
            })
        end
    }
})
