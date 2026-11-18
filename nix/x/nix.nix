{ lib, pkgs, ... }:
{
  programs.nh = {
    enable = true;
  } // lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
    clean.enable = true;
  };
}
