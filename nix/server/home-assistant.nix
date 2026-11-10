{ lib, config, pkgs, ... }:
let 
  quirk = ./home-assistant-quirks/co2bj_shbwrllktmp0w8oa.py;
  configDir = config.services.home-assistant.configDir;
in
{
  services.home-assistant = {
    enable = true;
    package = pkgs.home-assistant.override {
      packageOverrides = final: prev: {
        # Essent requires this header on its public pricing API.
        # https://github.com/home-assistant/core/issues/172905
        essent-dynamic-pricing = prev.essent-dynamic-pricing.overridePythonAttrs (old: {
          postPatch = (old.postPatch or "") + ''
            substituteInPlace src/essent_dynamic_pricing/client.py \
              --replace-fail 'headers={"Accept": "application/json"},' \
                'headers={"Accept": "application/json", "x-request-origin": "client"},'
          '';
        });
      };
    };
    extraComponents = [
      "analytics"
      "essent"
      "homewizard"
      "tuya"
    ];
    themes = with pkgs.home-assistant-themes; [
      catppuccin
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
            }
          ];
          conditions = [
            {
              condition = "template";
              value_template = "{{ states('person.roy') not in ['home'] }}";
            }
          ];
          actions = [
            {
              action = "vacuum.start";
              target.entity_id = "vacuum.robot_vacuum_self_emptying";
            }
          ];
          mode = "single";
        }
        {
          id = "huis_lamps_schedule";
          alias = "Huis lamps brightness schedule";
          triggers = [
            {
              trigger = "time";
              at = "06:00:00";
            }
            {
              trigger = "time";
              at = "17:00:00";
            }
            {
              trigger = "time";
              at = "20:00:00";
            }
            {
              trigger = "state";
              entity_id = [ "light.huis_lamp_1" "light.huis_lamp_2" ];
              to = "on";
            }
          ];
          actions = [
            {
              repeat = {
                for_each = [ "light.huis_lamp_1" "light.huis_lamp_2" ];
                sequence = [
                  {
                    "if" = [
                      {
                        condition = "template";
                        value_template = "{{ is_state(repeat.item, 'on') }}";
                      }
                    ];
                    "then" = [
                      {
                        action = "light.turn_on";
                        target.entity_id = "{{ repeat.item }}";
                        data.brightness_pct = "{{ 50 if 6 <= now().hour < 17 else (20 if 17 <= now().hour < 20 else 1) }}";
                      }
                    ];
                  }
                ];
              };
            }
          ];
          mode = "queued";
        }
      ];
    };
  };

  networking = {
    firewall.allowedTCPPorts = [
      8123
    ];
  };

  services.nginx = {
    recommendedProxySettings = true;
    virtualHosts = {
      "hm.rh-development.nl" = {
        forceSSL = true;
        enableACME = true;
        extraConfig = ''
          proxy_buffering off;
        '';
        locations."/" = {
          proxyPass = "http://[::1]:8123";
          proxyWebsockets = true;
        };
      };
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
