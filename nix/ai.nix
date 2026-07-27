{ config, pkgs, lib, inputs, ... }:
{
  home.packages = [
    pkgs.acli
    pkgs.whichllm
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

  services.ollama = {
    enable = false;
    environmentVariables = {
      OLLAMA_CONTEXT_LENGTH = "32768";
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
    marketplaces = {
      context-mode = pkgs.fetchFromGitHub {
        owner = "mksglu";
        repo = "context-mode";
        tag = "v1.0.162";
        sha256 = "sha256-yDr8N2mGwg+ejzeeMSHybaQFki6ny11Dqj6Cy+QGsdc=";
      };
    };
    plugins = [
      (pkgs.fetchFromGitHub {
        owner = "mksglu";
        repo = "context-mode";
        tag = "v1.0.162";
        sha256 = "sha256-yDr8N2mGwg+ejzeeMSHybaQFki6ny11Dqj6Cy+QGsdc=";
      })
    ];
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
            hooks = [{
              type = "command";
              command = ../terminal/.config/tmux/session-notify.sh;
            }];
          }
        ];
      };
    };
  };
}
