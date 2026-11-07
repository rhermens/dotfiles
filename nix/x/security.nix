{ lib, pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    sops
    ssh-to-age
  ];

  sops = {
    defaultSopsFile = ./../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  };

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
  } // lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
    polkitPolicyOwners = [ "roy" ];
  };
}
