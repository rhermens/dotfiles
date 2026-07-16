{ config, pkgs, lib, inputs, ... }:
let
  llmAgentsPkgs = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
  hermesDesktop = llmAgentsPkgs.hermes-desktop;
  hermesDesktopMacLauncher = pkgs.writeShellScript "hermes-desktop-mac-launcher" ''
    exec ${hermesDesktop}/bin/hermes-desktop "$@"
  '';
  hermesDesktopIcon = pkgs.runCommand "hermes-desktop.icns"
    {
      nativeBuildInputs = [ pkgs.libicns ];
    } ''
    png2icns $out ${hermesDesktop}/share/icons/hicolor/512x512/apps/hermes-desktop.png
  '';
in
{
  home.packages = [
    pkgs.acli
    pkgs.whichllm
    hermesDesktop
  ];

  home.file = {
    ".pi/agent/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/ai/.pi/agent/settings.json";
    ".agents/skills".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/ai/skills";
    ".hermes/config.yaml" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/ai/hermes/config.yaml";
      force = true;
    };
    ".hermes/memories/MEMORY.md".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/ai/MEMORY.md";
  } // lib.optionalAttrs pkgs.stdenv.isDarwin {
    "Applications/Hermes Desktop.app/Contents/Info.plist".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/ai/hermes/Hermes.plist";
    "Applications/Hermes Desktop.app/Contents/MacOS/hermes-desktop".source = hermesDesktopMacLauncher;
    "Applications/Hermes Desktop.app/Contents/Resources/hermes-desktop.icns".source = hermesDesktopIcon;
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.hermes/bin"
  ];

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
    enable = true;
    environmentVariables = {
      OLLAMA_CONTEXT_LENGTH = "32768";
    };
  };

  programs.pi-coding-agent = {
    enable = true;
    context = ./../ai/AGENTS.md;
    package = llmAgentsPkgs.pi;
  };

  programs.claude-code = {
    enable = true;
    package = llmAgentsPkgs.claude-code;
    enableMcpIntegration = true;
    context = ./../ai/AGENTS.md;
    skills = ./../ai/skills;
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
