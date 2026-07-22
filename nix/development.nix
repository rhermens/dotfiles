{ config, pkgs, lib, ... }:
{
  home.packages = [
    pkgs.gcc
    pkgs.gnumake
    pkgs.cmake
    pkgs.rustup
    pkgs.go
    pkgs.python3
    pkgs.nodejs
    pkgs.bun

    pkgs.typescript-language-server
    pkgs.python314Packages.pylatexenc

    pkgs.delta

    pkgs.sentry-cli
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

  programs.mise = {
    enable = true;
    enableZshIntegration = true;
  };
}
