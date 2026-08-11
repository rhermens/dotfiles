{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    sbctl
  ];

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    autoGenerateKeys.enable = true;
    autoEnrollKeys.enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
}
