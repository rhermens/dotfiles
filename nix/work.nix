{ config, pkgs, lib, home-manager, ... }:
{
  homebrew = {
    brews = [ ];
    casks = [ "microsoft-office" ];
  };

  home-manager.users.roy = { config, ... }: {
    home.packages = with pkgs; [
      slack
      teams
      microsoft-office
    ];
  };
}
