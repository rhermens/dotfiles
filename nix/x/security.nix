{ lib, pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    sops
    ssh-to-age
  ];

  sops = {
    defaultSopsFile = ./../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    age.keyFile = "${config.users.users.roy.home}/.config/sops/age/keys.txt";
  };

  sops.secrets.github_token = {};
  sops.templates."nix-github.conf" = {
    owner = "roy";
    mode = "0400";
    content = ''
      access-tokens = github.com=${config.sops.placeholder.github_token}
    '';
  };

  nix.extraOptions = ''
    !include ${config.sops.templates."nix-github.conf".path}
  '';

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
  } // lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
    polkitPolicyOwners = [ "roy" ];
  };
}
