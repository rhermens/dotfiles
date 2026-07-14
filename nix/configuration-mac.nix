# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ self, config, pkgs, ... }:

{
  # Determinate nix
  nix.enable = false;

  determinateNix = {
    enable = true;
    customSettings = {
      extra-substituters = [
        "https://cache.numtide.com"
      ];
      extra-trusted-public-keys = [
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      ];
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  networking.hostName = "MBP-Roy";

  system.primaryUser = "roy";
  users.users.roy = {
    name = "roy";
    home = "/Users/roy";
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    neovim
    git
  ];

  homebrew = {
    enable = true;
    enableZshIntegration = true;
    brews = [ "docker" "docker-compose" "autoraise" ];
    casks = [ "linearmouse" "displaylink" "docker-desktop" "hammerspoon" ];
  };

  programs.zsh.enable = true;

  programs._1password.enable = true;
  programs._1password-gui.enable = true;

  system.defaults.dock = {
    autohide = true;
    persistent-apps = [
      {
        app = "${pkgs.ghostty-bin}/Applications/Ghostty.app";
      }
      {
        app = "${pkgs.google-chrome}/Applications/Google Chrome.app";
      }
      {
        app = "${pkgs.obsidian}/Applications/Obsidian.app";
      }
    ];
  };

  system.defaults = {
    screencapture.target = "clipboard";
    NSGlobalDomain.AppleFontSmoothing = 0;
    CustomUserPreferences = {
      NSGlobalDomain = {
        CGFontRenderingFontSmoothingDisabled = false;
      };
    };
  };

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;
}
