{ config, pkgs, hp-tracerled, ... }:
{
  programs.hyprland = {
    enable = true;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
    withUWSM = true;
  };

  programs.waybar.enable = true;

  environment.systemPackages = with pkgs; [
    capitaine-cursors
    hyprpaper
    hyprlauncher
    hyprpwcenter
    hyprshutdown
    hyprpolkitagent
    grim
    slurp
    swappy
  ];

  services.hypridle.enable = true;

  security.polkit = {
    enable = true;
  };
}
