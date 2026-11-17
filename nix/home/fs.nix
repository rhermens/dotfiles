{ config, lib, pkgs, ... }:
let
  retentionDays = 7;
  retentionMinutes = toString (retentionDays * 24 * 60);
in
{
  # Keep ~/tmp private and clean its contents after seven days of inactivity.
  systemd.user.tmpfiles.rules = lib.mkIf pkgs.stdenv.hostPlatform.isLinux [
    "d %h/tmp 0700 - - ${toString retentionDays}d -"
  ];

  launchd.agents.tmp-cleanup = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    enable = true;
    config = {
      ProgramArguments = [
        (toString (pkgs.writeShellScript "cleanup-home-tmp" ''
          set -euo pipefail
          tmpDir=${lib.escapeShellArg "${config.home.homeDirectory}/tmp"}

          if [[ -L "$tmpDir" ]]; then
            printf 'Refusing to clean symlink: %s\n' "$tmpDir" >&2
            exit 1
          fi

          ${pkgs.coreutils}/bin/mkdir -p -m 0700 -- "$tmpDir"
          ${pkgs.coreutils}/bin/chmod 0700 -- "$tmpDir"

          # Match tmpfiles' access/modification/change checks; ignore directory ctime.
          # Delete only empty directories and never follow symlinks or cross filesystems.
          ${pkgs.findutils}/bin/find -P "$tmpDir" \
            -xdev -depth -mindepth 1 -ignore_readdir_race \
            -amin +${retentionMinutes} -mmin +${retentionMinutes} \
            \( -type d -o -cmin +${retentionMinutes} \) \
            \( ! -type d -o -empty \) -delete
        ''))
      ];
      RunAtLoad = true;
      StartInterval = 86400;
      ProcessType = "Background";
    };
  };
}
