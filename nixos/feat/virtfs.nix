{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    cifs-utils
  ];

  services = {
    gvfs = {
      enable = true;
      package = lib.mkForce pkgs.gnome.gvfs;
    };
    samba.enable = true;
    tumbler.enable = true;
    gnome.gnome-keyring.enable = true;
  };
}
