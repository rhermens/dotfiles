{ pkgs, lib, ... }:
{
  homebrew = lib.mkIf pkgs.stdenv.isDarwin {
    brews = [ ];
    casks = [ "microsoft-office" "microsoft-teams" ];
  };


  home-manager.users.roy = { ... }: {
    home.packages = with pkgs; [
      slack
      acli
    ];
  };
}
