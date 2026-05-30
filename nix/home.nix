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


    pkgs.obsidian
    pkgs.discord
    pkgs.slack
    pkgs.nerd-fonts.lilex

    pkgs.claude-code
    pkgs.lazygit
    pkgs.mise
    pkgs.mongodb-compass
    pkgs.gh
    pkgs.docker
    pkgs.docker-compose
  ];


  home.file = {
    ".config/opencode".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/ai/.config/opencode";
    ".config/git".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/core/.config/git";
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim/.config/nvim";
    ".config/tmux".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/terminal/.config/tmux";
    ".config/ghostty".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/terminal/.config/ghostty";
    ".config/wt".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/dev/.config/wt";
    ".tool-versions".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/dev/.tool-versions";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.cargo/bin"
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    SSH_AUTH_SOCK = "${config.home.homeDirectory}/.1password/agent.sock";
    GITHUB_TOKEN = "\$(gh auth token)";
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings."*" = {
      IdentityAgent = "${config.home.homeDirectory}/.1password/agent.sock";
    };
  };

  dconf.settings = lib.mkIf pkgs.stdenv.isLinux {
    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "caps:ctrl_modifier" ];
    };
    "org/gnome/desktop/wm/preferences" = {
      focus-mode = "sloppy";
    };
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

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
