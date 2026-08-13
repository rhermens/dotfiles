{ config, inputs, pkgs, lib, ... }:
{
  home.username = "roy";
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

  home.packages = [
    (if pkgs.stdenv.isDarwin then pkgs.glibtool else pkgs.libtool)
    pkgs.gcc
    pkgs.delta

    pkgs.tmux
    pkgs.tree-sitter
    pkgs.neovim
    pkgs.zsh
    pkgs.antidote
    pkgs.fzf
    pkgs.ripgrep
    pkgs.fd
    pkgs.tldr
    pkgs.jq
    pkgs.fastfetch
    pkgs.killall

    pkgs.obsidian
    pkgs.discord
    pkgs.nerd-fonts.lilex
    pkgs.nerd-fonts.symbols-only
    pkgs.slack

    (if pkgs.stdenv.isDarwin then pkgs.ghostty-bin else pkgs.ghostty)

    pkgs.google-chrome
    inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  home.file = {
    ".config/git".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/core/.config/git";
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim/.config/nvim";
    ".config/tmux".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/terminal/.config/tmux";
    ".config/ghostty".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/terminal/.config/ghostty";
    ".config/wt".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/dev/.config/wt";
    ".tool-versions".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/dev/.tool-versions";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    SSH_AUTH_SOCK = "${config.home.homeDirectory}/.1password/agent.sock";
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
    initContent = lib.mkBefore ''# Enable Powerlevel10k instant prompt. Keep this close to the top of .zshrc.
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
    '';
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

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  services.git-watch = {
    notes = {
      enable = true;
      logLevel = "debug";
      path = "~/notes";
    };
  };
}
