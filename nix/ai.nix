{ config, inputs, lib, pkgs, ... }:
{
  imports = [ inputs.codex-desktop-linux.homeManagerModules.default ];

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

  home.sessionVariables = {
    PI_JEV_AUTO = "1";
  };

  # Claude Code discovers skills at <skills-dir>/<skill>/SKILL.md, but ~/skills
  # groups them as <category>/<skill>/SKILL.md. Flatten each leaf into
  # ~/.claude/skills so they are found.
  home.activation.flattenClaudeSkills = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    skillsSrc="${config.home.homeDirectory}/skills"
    skillsDst="${config.home.homeDirectory}/.claude/skills"

    run mkdir -p $VERBOSE_ARG "$skillsDst"

    # Drop links from a previous run. Leave home-manager's own entries alone.
    for link in "$skillsDst"/*; do
      [ -L "$link" ] || continue
      case "$(readlink "$link")" in
        "$skillsSrc"/*) run rm $VERBOSE_ARG "$link" ;;
      esac
    done

    for manifest in "$skillsSrc"/*/*/SKILL.md; do
      [ -f "$manifest" ] || continue
      dir="''${manifest%/SKILL.md}"
      run ln -sfn $VERBOSE_ARG "$dir" "$skillsDst/''${dir##*/}"
    done
  '';

  programs.mcp = {
    enable = true;
    servers = {
      exa = {
        url = "https://mcp.exa.ai/mcp";
      };
      chrome-devtools = {
        command = "npx";
        args = [ "-y" "chrome-devtools-mcp@latest" ];
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

  programs.codexDesktopLinux = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    enable = true;
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
      model = "opus";
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
