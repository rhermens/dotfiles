{ lib, pkgs, ... }:
{
  # Keep ~/tmp private and clean its contents after seven days of inactivity.
  systemd.user.tmpfiles.rules = lib.mkIf pkgs.stdenv.hostPlatform.isLinux [
    "d %h/tmp 0700 - - 7d -"
  ];
}
