{ pkgs, lib, ... }:
{
  homebrew = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    brews = [ ];
    casks = [ "microsoft-office" "microsoft-teams" ];
  };
}
