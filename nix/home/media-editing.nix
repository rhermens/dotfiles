{ pkgs, ... }:
{
  home.packages = [
    pkgs.ardour
    pkgs.davinci-resolve
    pkgs.yt-dlp
  ];
}
