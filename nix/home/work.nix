{ pkgs, ... }:
{
  home.packages = with pkgs; [
    slack
    acli
  ];
}
