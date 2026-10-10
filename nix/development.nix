{ inputs, config, pkgs, ... }:
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
    pkgs.tailwindcss-language-server
    pkgs.vtsls
    pkgs.vue-language-server
    pkgs.vscode-langservers-extracted
    pkgs.gopls
    pkgs.nixd
    pkgs.basedpyright
    pkgs.ruff

    pkgs.vscode-js-debug
    pkgs.delve

    pkgs.python314Packages.pylatexenc

    pkgs.commitizen
    pkgs.lazygit
    pkgs.gh
    pkgs.delta
    inputs.wt.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.github-watch.packages.${pkgs.stdenv.hostPlatform.system}.default

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
