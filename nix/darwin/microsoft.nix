{ pkgs, lib, ... }:
{
  homebrew = lib.mkIf pkgs.stdenv.isDarwin {
    brews = [ ];
    casks = [ "microsoft-office" "microsoft-teams" ];
  };
}
