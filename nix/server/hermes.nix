{ config, pkgs, ... }:
{
  sops.secrets."hermes/env" = {
    owner = "hermes";
  };
  sops.secrets."hermes/session_token" = {
    owner = "hermes";
  };

  users.users.roy.extraGroups = [ config.services.hermes-agent.group ];
  users.users.hermes.openssh.authorizedKeys.keys =
    config.users.users.roy.openssh.authorizedKeys.keys;

  # Desktop-managed SSH uses python3 for remote startup checks.
  environment.systemPackages = [ pkgs.python3 ];

  services.hermes-agent = {
    enable = true;
    environmentFiles = [
      config.sops.secrets."hermes/env".path
    ];
    addToSystemPackages = true;
    backend = {
      mode = "serve";
      host = "127.0.0.1";
      port = 9119;
      sessionTokenFile = config.sops.secrets."hermes/session_token".path;
    };

    settings = {
      a2a_agents.omen = {
        url = "http://omen:9900";
        auth = {
          type = "bearer";
          token = "\${env:A2A_BEARER_TOKEN}";
        };
        timeout = 300;
      };
      a2a_agents.MBP-Roy = {
        url = "http://mbp-roy:9900";
        auth = {
          type = "bearer";
          token = "\${env:A2A_BEARER_TOKEN}";
        };
        timeout = 300;
      };

      platform_toolsets.cli = [ "hermes-cli" "a2a" ];
    };

    mcpServers = {
      home-assistant = {
        url = "https://hm.rh-development.nl/api/mcp";
        auth = "oauth";
      };
    };
  };
}
