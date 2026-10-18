{ lib, pkgs, ... }:
{
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = lib.mkIf pkgs.stdenv.isLinux [ "roy" ];
  };
}
