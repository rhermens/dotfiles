{ config, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.username = "roy";
  home.homeDirectory = "/home/roy";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  home.file = {
    neovim = {
      enable = true;
      source = ./nvim;
      target = ".config/nvim";
      recursive = true;
    };
    kitty = {
      enable = true;
      source = ./kitty;
      target = ".config/kitty";
    };
    tmux = {
      enable = true;
      source = ./tmux;
      target = ".config/tmux";
    };
    dunst = {
      enable = true;
      source = ./dunst;
      target = ".config/dunst";
    };
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.tmux
    pkgs.tldr
    pkgs.fzf
    pkgs.ripgrep
    pkgs.fd

    pkgs.obsidian
    pkgs.google-chrome

    pkgs.neovim

    pkgs.nerd-fonts.iosevka

    pkgs.asdf-vm
    pkgs.go

    pkgs.uwsm
    pkgs.xdg-desktop-portal-hyprland
    pkgs.hyprshot
    pkgs.wofi
  ];

  programs.git = {
    enable = true;
    userEmail = "royhermens@hotmail.com";
    userName = "rhermens";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    extraConfig = builtins.readFile ./hypr/hyprland.conf;
  };

  programs.waybar = {
    enable = true;
    style = ./waybar/style.css;
    settings = {
      mainBar = {
        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];
        modules-right = [
          "pulseaudio"
          "cpu"
          "memory"
          "clock"
          "tray"
        ];

        "hyprland/workspaces" = {
          all-outputs = true;
        };

        "clock" = {
          format = "{:%F %H:%M}";
        };

        "pulseaudio" = {
          format = "Vol: {volume}%";
        };

        "cpu" = {
          format = "Cpu: {usage}%";
        };

        "memory" = {
          format = "Mem: {percentage}%";
        };
      };
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      background = {
        color = "rgb(24283b)";
      };
      input-field = {
        monitor = "";
      };
    };
  };

  programs.fzf = {
    enable = true;
    changeDirWidgetCommand = "fd --type d --hidden --no-ignore --follow --exclude node_modules --exclude vendor --exclude .git";
  };

  programs.zsh = {
    enable = true;
    antidote = {
      enable = true;
      plugins = [
        "romkatv/powerlevel10k"
        "zsh-users/zsh-syntax-highlighting"
        "zsh-users/zsh-autosuggestions"
        "jeffreytse/zsh-vi-mode"
      ];
    };
    plugins = [
      {
        name = "p10k";
        file = "p10k.zsh";
        src = ./zsh;
      }
    ];

    shellAliases = {
      ll = "ls --color=auto -alF";
      vim = "nvim";
    };
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/roy/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.sessionPath = [
    "\${ASDF_DATA_DIR:-$HOME/.asdf}/shims"
  ];

  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts.monospace = [
        "Iosevka Nerd Font Mono"
      ];
    };
  };

  gtk = {
    enable = true;
    font.name = "monospace";
    theme = {
      package = pkgs.tokyonight-gtk-theme;
      name = "Tokyonight-Dark";
    };
  };

  services.hyprpolkitagent = {
    enable = true;
  };
  services.dunst = {
    enable = true;
  };
}
