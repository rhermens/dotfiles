{ config, pkgs, lib, home-manager, ... }:
{
  homebrew = {
    enable = true;
    enableZshIntegration = true;
    brews = [ "docker" "docker-compose" "autoraise" ];
    casks = [ "linearmouse" "displaylink" "docker-desktop" "hammerspoon" "monitorcontrol" ];
  };

  home-manager.users.roy = { config, ... }: {
    home.packages = with pkgs; [
      slack
      teams
      microsoft-office
    ];
  };
}
