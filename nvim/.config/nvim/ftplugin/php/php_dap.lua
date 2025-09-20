require('mason-nvim-dap').setup({
    handlers = {
        php = function(config)
            config.configurations.php = {
                {
                    type = "php",
                    name = "Listen for Xdebug",
                    request = "launch",
                    port = 9003,
                    pathMappings = {
                        ["/var/www/html"] = "${workspaceFolder}"
                    }
                }
            }
            require('mason-nvim-dap').default_setup(config)
        end
    }
})
