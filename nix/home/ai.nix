{ config, inputs, lib, pkgs, ... }:
{
  imports = [
    inputs.agents.homeManagerModules.default
  ];

  home.packages = [
    pkgs.nodejs
    pkgs.python3

    pkgs.python314Packages.langfuse

    pkgs.llmfit
    (pkgs.chatgpt.override {
      # The Cargo hook now requires these system libraries instead of bundled copies.
      codex = pkgs.codex.overrideAttrs (old: {
        buildInputs = old.buildInputs ++ [
          pkgs.aws-lc
          pkgs.oniguruma
          pkgs.sqlite
          pkgs.zstd
        ];
      });
      # Tectonic's Rust dependencies require system AWS-LC in this nixpkgs revision.
      tectonic-unwrapped = pkgs.tectonic-unwrapped.overrideAttrs (old: {
        buildInputs = old.buildInputs ++ [ pkgs.aws-lc ];
      });
    })
    inputs.qmd.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  home.file = {
    ".claude/themes".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/ai/.claude/themes";
    ".pi/agent/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/ai/.pi/agent/settings.json";
    ".pi/web-search.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/ai/.pi/web-search.json";
    ".pi/agent/extensions".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/ai/.pi/agent/extensions";
    ".pi/agent/themes".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/ai/.pi/agent/themes";
    ".pi/agent/mcp.json".source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/mcp/mcp.json";
  };

  sops.secrets = {
    "langfuse/public_key" = {};
    "langfuse/secret_key" = {};
  };

  home.sessionVariables = {
    PI_JEV_AUTO = "1";
    LANGFUSE_PUBLIC_KEY = "$(cat '${config.sops.secrets."langfuse/public_key".path}')";
    LANGFUSE_SECRET_KEY = "$(cat '${config.sops.secrets."langfuse/secret_key".path}')";
    LANGFUSE_BASE_URL = "https://cloud.langfuse.com";
  };

  # Claude Code discovers skills at <skills-dir>/<skill>/SKILL.md, but ~/skills
  # groups them as <category>/<skill>/SKILL.md. Flatten each leaf into
  # ~/.claude/skills so they are found.
  home.activation.flattenClaudeSkills = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    skillsSrc="${config.home.homeDirectory}/.agents/skills"
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
        args = [
          "-y"
          "chrome-devtools-mcp@latest"
          "--autoConnect"
        ];
      };
      atlassian = {
        url = "https://mcp.atlassian.com/v2/mcp";
      };
    };
  };

  services.ollama = {
    enable = true;
    environmentVariables = {
      OLLAMA_CONTEXT_LENGTH = "32768";
    };
  };

  programs.pi-coding-agent = {
    enable = true;
    context = ./../../ai/AGENTS.md;
    models = {
      providers = {
        ollama = {
          api = "openai-completions";
          apiKey = "ollama";
          baseUrl = "http://127.0.0.1:11434/v1";
          models = [
            {
              id = "gemma4:e4b";
              contextWindow = 32768;
              reasoning = true;
              input = [ "text" "image" ];
              samplingParams = {
                temperature = 0.4;
              };
            }
          ];
        };
      };
    };
  };

  programs.claude-code = {
    enable = true;
    enableMcpIntegration = true;
    context = ./../../ai/AGENTS.md;
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
      nixd = {
        command = "nixd";
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
      disableClaudeAiConnectors = true;
      attribution = false;
      hooks = {
        Stop = [
          {
            matcher = "*";
            hooks = [
              {
                type = "command";
                command = ../../terminal/.config/tmux/session-option-notify.sh;
              }
              {
                type = "command";
                command = ../../terminal/.config/tmux/window-notify.sh;
              }
              {
                type = "command";
                command = ../../ai/.claude/hooks/langfuse_hook.py;
              }
            ];
          }
        ];
      };
    };
  };
}
