{ config, pkgs, lib, ... }:
let
  miseVersion = "2026.6.14";
  misePlatforms = {
    x86_64-linux = {
      asset = "linux-x64-musl";
      hash = "sha256-fRKWy/aQDvdyvYfDmfUvxqiHWbi9oeeLSQiBrumHJBc=";
    };
    aarch64-linux = {
      asset = "linux-arm64-musl";
      hash = "sha256-xhp/J37eATU+ZwwfccbhrX/Vsp7vweM5QPnNiOa8cSc=";
    };
    aarch64-darwin = {
      asset = "macos-arm64";
      hash = "sha256-aQSNq7Kz81ZvkIGxOAKcaMCq50JVplevrVOmt7WnwpA=";
    };
    x86_64-darwin = {
      asset = "macos-x64";
      hash = "sha256-ql4UMR9W8Pqn/EM1zGyv+bvawL4b7vIF9S/32Qnp9pA=";
    };
  };
  misePlatform = misePlatforms.${pkgs.stdenv.hostPlatform.system}
    or (throw "Unsupported mise-bin platform: ${pkgs.stdenv.hostPlatform.system}");
  miseBin = pkgs.stdenvNoCC.mkDerivation {
    pname = "mise-bin";
    version = miseVersion;
    src = pkgs.fetchzip {
      url = "https://github.com/jdx/mise/releases/download/v${miseVersion}/mise-v${miseVersion}-${misePlatform.asset}.tar.gz";
      hash = misePlatform.hash;
    };
    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -R . $out/
      chmod +x $out/bin/mise
      runHook postInstall
    '';
    meta.mainProgram = "mise";
  };
in
{
  home.username = "roy";
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

  imports = [ ./ai.nix ];

  home.packages = [
    pkgs.gcc
    pkgs.gnumake
    pkgs.cmake
    pkgs.libtool
    pkgs.rustup
    pkgs.go
    pkgs.python3
    pkgs.nodejs
    pkgs.bun

    pkgs.tmux
    pkgs.tree-sitter
    pkgs.neovim
    pkgs.emacs
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
    pkgs.nerd-fonts.symbols-only

    (if pkgs.stdenv.isDarwin then pkgs.ghostty-bin else pkgs.ghostty)

    pkgs.lazygit
    pkgs.mongodb-compass
    pkgs.mongosh
    pkgs.mongodb-tools
    pkgs.gh
    pkgs.google-chrome
  ];

  home.file = {
    ".config/git".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/core/.config/git";
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim/.config/nvim";
    ".config/doom".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/emacs/.config/doom";
    ".config/tmux".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/terminal/.config/tmux";
    ".config/ghostty".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/terminal/.config/ghostty";
    ".config/wt".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/dev/.config/wt";
    ".tool-versions".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/dev/.tool-versions";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/.cargo/bin"
    "${config.home.homeDirectory}/.local/share/nvim/mason/bin"
    "${config.home.homeDirectory}/.config/emacs/bin"
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    SSH_AUTH_SOCK = "${config.home.homeDirectory}/.1password/agent.sock";
    GITHUB_TOKEN = "\$(gh auth token)";
    OBSIDIAN_VAULT_PATH = "${config.home.homeDirectory}/notes";
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
    package = miseBin;
    enableZshIntegration = true;
  };
}
