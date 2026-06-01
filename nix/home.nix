{ config, pkgs, lib, ... }:
{
  home.username = "roy";
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

  home.packages = [
    pkgs.gcc
    pkgs.rustup

    pkgs.tmux
    pkgs.tree-sitter
    pkgs.neovim
    pkgs.zsh
    pkgs.antidote
    pkgs.fzf
    pkgs.ripgrep
    pkgs.fd
    pkgs.tldr
    pkgs.fastfetch

    pkgs.obsidian
    pkgs.discord
    pkgs.slack
    pkgs.nerd-fonts.lilex

    (if pkgs.stdenv.isDarwin then pkgs.ghostty-bin else pkgs.ghostty)

    pkgs.lazygit
    pkgs.mongodb-compass
    pkgs.gh
    pkgs.google-chrome
  ];


  home.file = {
    ".config/opencode".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/ai/.config/opencode";
    ".config/git".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/core/.config/git";
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim/.config/nvim";
    ".config/tmux".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/terminal/.config/tmux";
    ".config/ghostty".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/terminal/.config/ghostty";
    ".config/wt".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/dev/.config/wt";
    ".tool-versions".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/dev/.tool-versions";
  } // lib.optionalAttrs pkgs.stdenv.isLinux {
    ".config/hypr".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/wm/.config/hypr";
    ".config/waybar".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/wm/.config/waybar";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.cargo/bin"
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    SSH_AUTH_SOCK = "${config.home.homeDirectory}/.1password/agent.sock";
    GITHUB_TOKEN = "\$(gh auth token)";
    NIX_BUILD_SHELL = "zsh";
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings."*" = {
      IdentityAgent = "${config.home.homeDirectory}/.1password/agent.sock";
    };
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls --color=auto -lah";
    };
    plugins = [
      {
        name = "p10k";
        file = "p10k.zsh";
        src = ../terminal/.zsh/plugins;
      }
    ];
    antidote = {
      enable = true;
      plugins = [
        "romkatv/powerlevel10k"
        "zsh-users/zsh-syntax-highlighting"
        "zsh-users/zsh-autosuggestions"
        "jeffreytse/zsh-vi-mode"
      ];
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.mise = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.mcp = {
    enable = true;
    servers = {
      jira = {
        type = "http";
        url = "https://mcp.atlassian.com/v1/mcp";
      };
      github = {
        type = "http";
        url = "https://api.githubcopilot.com/mcp/readonly";
        headers = {
          Authorization = "Bearer {env:GITHUB_TOKEN}";
        };
      };
      mongodb = {
        command = "npx";
        args = [ "-y" "mongodb-mcp-server@latest" "--readOnly" ];
        env = {
          MDB_MCP_CONNECTION_STRING = "mongodb://localhost:27017";
        };
      };
    };
  };

  programs.claude-code = {
    enable = true;
    package = pkgs.claude-code;
    enableMcpIntegration = true;
    settings = {
      theme = "auto";
      editorMode = "vim";
      skipAutoPermissionPrompt = true;
      permissions.defaultMode = "auto";
      hooks = {
        SessionStart = [
          {
            hooks = [{
              type = "command";
              command = ''f="AGENTS.md"; [ -f "$f" ] && jq -n --rawfile content "$f" '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":("Contents of AGENTS.md:\n\n" + $content)}}' 2>/dev/null || true'';
            }];
          }
          {
            hooks = [{
              type = "command";
              command = ''node "${config.home.homeDirectory}/Projects/Claude-Code-Agent-Monitor/scripts/hook-handler.js" SessionStart'';
            }];
          }
        ];
        PreToolUse = [{
          matcher = "*";
          hooks = [{
            type = "command";
            command = ''node "${config.home.homeDirectory}/Projects/Claude-Code-Agent-Monitor/scripts/hook-handler.js" PreToolUse'';
          }];
        }];
        PostToolUse = [{
          matcher = "*";
          hooks = [{
            type = "command";
            command = ''node "${config.home.homeDirectory}/Projects/Claude-Code-Agent-Monitor/scripts/hook-handler.js" PostToolUse'';
          }];
        }];
        Stop = [{
          matcher = "*";
          hooks = [{
            type = "command";
            command = ''node "${config.home.homeDirectory}/Projects/Claude-Code-Agent-Monitor/scripts/hook-handler.js" Stop'';
          }];
        }];
        SubagentStop = [{
          matcher = "*";
          hooks = [{
            type = "command";
            command = ''node "${config.home.homeDirectory}/Projects/Claude-Code-Agent-Monitor/scripts/hook-handler.js" SubagentStop'';
          }];
        }];
        Notification = [
          {
            matcher = "*";
            hooks = [{
              type = "command";
              command = ''node "${config.home.homeDirectory}/Projects/Claude-Code-Agent-Monitor/scripts/hook-handler.js" Notification'';
            }];
          }
          {
            matcher = "*";
            hooks = [{
              type = "command";
              command = "~/.config/tmux/session-notify.sh";
            }];
          }
        ];
        SessionEnd = [{
          hooks = [{
            type = "command";
            command = ''node "${config.home.homeDirectory}/Projects/Claude-Code-Agent-Monitor/scripts/hook-handler.js" SessionEnd'';
          }];
        }];
        UserPromptSubmit = [{
          hooks = [{
            type = "command";
            command = ''node "${config.home.homeDirectory}/Projects/Claude-Code-Agent-Monitor/scripts/hook-handler.js" UserPromptSubmit'';
          }];
        }];
      };
    };
  };

  home.activation.cloneAgentMonitor = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d "${config.home.homeDirectory}/Projects/Claude-Code-Agent-Monitor" ]; then
      ${pkgs.git}/bin/git clone https://github.com/hoangsonww/Claude-Code-Agent-Monitor \
        "${config.home.homeDirectory}/Projects/Claude-Code-Agent-Monitor"
    fi
  '';
}
