{ config, pkgs, hp-tracerled, home-manager, ... }:
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

  home-manager.users.roy = { config, ... }: {
    services.swayosd = {
      enable = true;
    };

    home.file = {
      ".config/hypr".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/wm/.config/hypr";
      ".config/waybar".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/wm/.config/waybar";
      ".config/swayosd".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/wm/.config/swayosd";
    };
  };
}
