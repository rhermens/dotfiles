{ config, pkgs, lib, ... }:
{
  services.desktopManager.gnome.enable = true;

  programs.dconf = {
    enable = true;
    profiles = {
      user.databases = [
        {
          settings = {
            "org/gnome/desktop/input-sources" = {
              xkb-options = [ "caps:ctrl_modifier" ];
            };
            "org/gnome/desktop/wm/preferences" = {
              focus-mode = "sloppy";
            };
            "org/gnome/settings-daemon/plugins/power" = {
              sleep-inactive-ac-type = "suspend";
              sleep-inactive-ac-timeout = lib.gvariant.mkInt32 1800;
            };
          };
        }
      ];
    };
  };
}
