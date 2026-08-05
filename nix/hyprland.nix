{ pkgs, ... }:
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
    nautilus
  ];

  services.gvfs.enable = true;

  services.hypridle.enable = false;
  programs.hyprlock.enable = false;

  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --theme 'border=#292e42;text=#c0caf5;prompt=#c0caf5;time=#7aa2f7;action=#c0caf5;button=#292e42;container=#1a1b26;input=#c0caf5' --cmd 'uwsm start hyprland-uwsm.desktop'";
        user = "greeter";
      };
    };
  };

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
