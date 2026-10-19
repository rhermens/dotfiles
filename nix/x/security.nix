{ lib, pkgs, ... }:
{
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
  } // lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
    polkitPolicyOwners = [ "roy" ];
  };
}
