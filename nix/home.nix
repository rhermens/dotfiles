{ config, pkgs, ... }:
{
  home.username = "roy";
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

  home.packages = [
    pkgs.gcc
    pkgs.rustup

    pkgs.tmux
    pkgs.ghostty
    pkgs.tree-sitter
    pkgs.neovim
    pkgs.zsh
    pkgs.antidote
    pkgs.fzf
    pkgs.ripgrep
    pkgs.fd
    pkgs.tldr

    pkgs._1password-gui
    pkgs._1password-cli
    pkgs.obsidian
    pkgs.google-chrome
    pkgs.discord
    pkgs.slack
    pkgs.iosevka

    pkgs.claude-code
    pkgs.mise
    pkgs.mongodb-compass
    pkgs.gh
    pkgs.docker
    pkgs.docker-compose
  ];


  home.file = {
    ".config/opencode".source = config.lib.file.mkOutOfStoreSymlink ../ai/.config/opencode;
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink ../nvim/.config/nvim;
    ".config/tmux".source = config.lib.file.mkOutOfStoreSymlink ../terminal/.config/tmux;
    ".config/ghostty".source = config.lib.file.mkOutOfStoreSymlink ../terminal/.config/ghostty;
    ".config/git".source = config.lib.file.mkOutOfStoreSymlink ../core/.config/git;
  };

  programs.zsh = {
    enable = true;
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
}
