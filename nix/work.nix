{ config, pkgs, lib, home-manager, ... }:
{
  homebrew = lib.mkIf pkgs.stdenv.isDarwin {
    brews = [ ];
    casks = [ "microsoft-office" "microsoft-teams" ];
  };


  home-manager.users.roy = { config, ... }: {
    home.packages = with pkgs; [
      slack
    ];
  };
}
