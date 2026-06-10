{ config, pkgs, home-manager, ... }:
{
  home-manager.users.roy = { config, ... }: {
    programs.aerospace = {
      enable = true;
      launchd.enable = true;
    };

    home.file = {
      ".config/aerospace".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/wm/.config/aerospace";
    };
  };
}
