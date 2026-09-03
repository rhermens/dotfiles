{ config, inputs, pkgs, ... }:
{
  home.packages = [
    pkgs.python3
    pkgs.nodejs

    pkgs.acli
    pkgs.whichllm
    inputs.qmd.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  home.file = {
    ".pi/agent/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/ai/.pi/agent/settings.json";
    ".pi/web-search.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/ai/.pi/web-search.json";
    ".pi/agent/extensions".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/ai/.pi/agent/extensions";
    ".pi/agent/themes".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/ai/.pi/agent/themes";
    ".agents/skills".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/skills";
  };

  programs.mcp = {
    enable = true;
    servers = {
      exa = {
        type = "http";
        url = "https://mcp.exa.ai/mcp";
      };
    };
  };

  programs.herdr = {
    enable = true;
  };

  programs.codex = {
    enable = true;
    enableMcpIntegration = true;
    skills = "/home/roy/skills";
  };

  services.ollama = {
    enable = false;
    environmentVariables = {
      OLLAMA_CONTEXT_LENGTH = "32768";
    };
  };

  services.git-watch = {
    skills = {
      enable = true;
      interval = 120;
      path = "~/skills";
    };
  };

  programs.pi-coding-agent = {
    enable = true;
    context = ./../ai/AGENTS.md;
  };

  programs.claude-code = {
    enable = true;
    enableMcpIntegration = true;
    context = ./../ai/AGENTS.md;
    skills = "${config.home.homeDirectory}/.agents/skills";
    settings = {
      model = "opus";
    };
    marketplaces = { };
    plugins = [ ];
    lspServers = {
      vtsls = {
        command = "vtsls";
        args = [ "--stdio" ];
        extensionToLanguage = {
          ".ts" = "typescript";
          ".tsx" = "typescriptreact";
          ".js" = "javascript";
          ".jsx" = "javascriptreact";
        };
      };
      gopls = {
        command = "gopls";
        extensionToLanguage = {
          ".go" = "go";
        };
      };
      rust-analyzer = {
        command = "rust-analyzer";
        extensionToLanguage = {
          ".rs" = "rust";
        };
      };
      rnix-lsp = {
        command = "rnix-lsp";
        extensionToLanguage = {
          ".nix" = "nix";
        };
      };
    };
    settings = {
      theme = "auto";
      editorMode = "vim";
      skipAutoPermissionPrompt = true;
      permissions.defaultMode = "auto";
      hooks = {
        Stop = [
          {
            matcher = "*";
            hooks = [
              {
                type = "command";
                command = ../terminal/.config/tmux/session-notify.sh;
              }
              {
                type = "command";
                command = ../terminal/.config/tmux/window-notify.sh;
              }
            ];
          }
        ];
      };
    };
  };
}
