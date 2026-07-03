{ config, pkgs, lib, ... }:
{
  home.packages = [
    pkgs.acli
    pkgs.llm-agents.hermes-agent
    pkgs.llm-agents.hermes-desktop
    pkgs.lmstudio
  ];

  home.file = {
    ".pi/agent/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/ai/.pi/agent/settings.json";
    ".agents/skills".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/ai/skills";
    ".hermes/config.yaml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/ai/hermes/config.yaml";
    ".lmstudio/mcp.json".source =
      config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/mcp/mcp.json";
  } // lib.optionalAttrs pkgs.stdenv.isDarwin {
    "Applications/Hermes Desktop.app/Contents/Info.plist".text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>CFBundleName</key>
        <string>Hermes Desktop</string>

        <key>CFBundleDisplayName</key>
        <string>Hermes Desktop</string>

        <key>CFBundleExecutable</key>
        <string>hermes-desktop</string>

        <key>CFBundleIdentifier</key>
        <string>com.rous.hermes-desktop</string>

        <key>CFBundleIconFile</key>
        <string>${pkgs.llm-agents.hermes-desktop}/share/icons/hicolor/512x512/apps/hermes-desktop.png</string>

        <key>CFBundleVersion</key>
        <string>1.0</string>

        <key>CFBundlePackageType</key>
        <string>APPL</string>
      </dict>
      </plist>
    '';

    "Applications/Hermes Desktop.app/Contents/MacOS/hermes-desktop" = {
      executable = true;
      text = ''
        #!${pkgs.runtimeShell}
        exec ${pkgs.llm-agents.hermes-desktop}/bin/hermes-desktop "$@"
      '';
    };
  };

  xdg.desktopEntries = lib.mkIf pkgs.stdenv.isLinux {
    lm-studio = {
      name = "LM Studio";
      exec = "${pkgs.lmstudio}/bin/lm-studio";
      terminal = false;
      categories = [ "Development" "Utility" ];
    };
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
    context = ./../ai/AGENTS.md;
    package = pkgs.llm-agents.pi;
  };

  programs.claude-code = {
    enable = true;
    package = pkgs.llm-agents.claude-code;
    enableMcpIntegration = true;
    context = ./../ai/AGENTS.md;
    skills = ./../ai/skills;
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
