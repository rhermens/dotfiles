{ pkgs, ... }:
{
  home.packages = [
    pkgs.obsidian
  ];

  services.git-watch = {
    notes = {
      enable = true;
      logLevel = "debug";
      path = "~/notes";
    };
  };
}
