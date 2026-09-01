{ config, pkgs, ... }:
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
    pkgs.ghc

    pkgs.typescript-language-server
    pkgs.haskell-language-server
    pkgs.lua-language-server
    pkgs.vtsls
    pkgs.vscode-langservers-extracted
    pkgs.gopls
    pkgs.nixd
    pkgs.basedpyright
    pkgs.ruff

    pkgs.python314Packages.pylatexenc

    pkgs.lazygit
    pkgs.gh
    pkgs.delta

    pkgs.mongodb-compass
    pkgs.mongosh
    pkgs.mongodb-tools

    pkgs.sentry-cli
    pkgs.awscli2
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
    "${config.home.homeDirectory}/.cargo/bin"
  ];

  home.sessionVariables = {
    GITHUB_TOKEN = "\$(gh auth token)";
  };

  programs.mise = {
    enable = true;
    enableZshIntegration = true;
  };
}
