# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ lib, config, pkgs, inputs, ... }:
{

  imports =
    [ # Include the results of the hardware scan.
      inputs.home-manager.nixosModules.default
    ];

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
    };
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      useOSProber = true;
    };
  };

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    defaultUserShell = pkgs.zsh;
    users.roy = {
      isNormalUser = true;
      description = "Roy";
      extraGroups = [ "networkmanager" "wheel" "docker" ];
      packages = with pkgs; [];
      shell = pkgs.zsh;
    };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    openzone-cursors
    kitty
    neovim
    git
    zsh
    pkg-config
    gcc
    unzip
    wget
    cifs-utils
    pavucontrol
    file-roller
  ];

  programs.zsh.enable = true;
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  programs.steam.enable = true;

  programs.nix-ld = {
    enable = true;
  };

  virtualisation.docker.enable = true;

  services = {
    gvfs = {
      enable = true;
      package = lib.mkForce pkgs.gnome.gvfs;
    };
    samba.enable = true;
    envfs.enable = true;
    tumbler.enable = true;
    gnome.gnome-keyring.enable = true;
  };

  system.stateVersion = "25.05"; # Did you read the comment?
}
