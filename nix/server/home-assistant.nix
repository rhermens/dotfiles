{ lib, config, pkgs, ... }:
let 
  quirk = ./home-assistant-quirks/co2bj_shbwrllktmp0w8oa.py;
  configDir = config.services.home-assistant.configDir;
in
{
  services.home-assistant = {
    enable = true;
    extraComponents = [
      "analytics"
      "tuya"
    ];
    config = {
      default_config = {};
      "automation ui" = "!include automations.yaml";
      automation = [
        {
          id = "vacuum_interval";
          alias = "Vacuum interval";
          triggers = [
            {
              trigger = "time";
              at = "13:00:00";
              weekday = [ "mon" "tue" "thu" "fri" ];
            }
          ];
          conditions = [];
          actions = [
            {
              action = "vacuum.start";
              target.device_id = "2ecc458c2d48fee71eade0239bb822a8";
            }
          ];
          mode = "single";
        }
      ];
    };
  };

  systemd.services.home-assistant = {
    preStart = ''
      ${pkgs.coreutils}/bin/install -Dm644 \
      ${quirk} \
      ${lib.escapeShellArg "${configDir}/tuya_quirks/co2bj_shbwrllktmp0w8oa.py"}
    '';
    restartTriggers = [ quirk ];
  };
}
