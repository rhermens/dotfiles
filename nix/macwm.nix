{ config, pkgs, home-manager, ... }:
{
  home-manager.users.roy = { config, ... }: {
    home.file = {
      ".hammerspoon".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/wm/.config/hammerspoon";
    };
  };
}
