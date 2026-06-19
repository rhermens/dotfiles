{ config, pkgs, ... }:
{
  home.file = {
    ".hammerspoon".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/wm/.config/hammerspoon";
  };
}
