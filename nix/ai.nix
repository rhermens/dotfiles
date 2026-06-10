{ config, pkgs, lib, ... }:
{
  home.packages = [
    pkgs.acli
  ];

  home.file = {
    ".pi/agent/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/ai/.pi/agent/settings.json";
    ".agents/skills".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/ai/.agents/skills";
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

  programs.pi-coding-agent = {
    enable = true;
  };

  programs.claude-code = {
    enable = true;
    enableMcpIntegration = true;
    context = ./../ai/.claude/CLAUDE.md;
    skills = ./../ai/.agents/skills;
    agentsDir = ../ai/agents;
    lspServers = {
      vtsls = {
        command = "${config.home.homeDirectory}/.local/share/nvim/mason/bin/vtsls";
        args = [ "--stdio" ];
        extensionToLanguage = {
          ".ts" = "typescript";
          ".tsx" = "typescriptreact";
          ".js" = "javascript";
          ".jsx" = "javascriptreact";
        };
      };
      gopls = {
        command = "${config.home.homeDirectory}/.local/share/nvim/mason/bin/gopls";
        extensionToLanguage = {
          ".go" = "go";
        };
      };
      rust-analyzer = {
        command = "${config.home.homeDirectory}/.local/share/nvim/mason/bin/rust-analyzer";
        extensionToLanguage = {
          ".rs" = "rust";
        };
      };
      rnix-lsp = {
        command = "${config.home.homeDirectory}/.local/share/nvim/mason/bin/rnix-lsp";
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

  services.ollama = {
    enable = true;
  };
}
