{ config, pkgs, ... }:
{
  sops.secrets."hermes/env" = {
    owner = "hermes";
  };
  sops.secrets."hermes/session_token" = {
    owner = "hermes";
  };

  sops.templates."hermes-github.env" = {
    owner = "hermes";
    mode = "0400";
    content = ''
      GITHUB_MCP_TOKEN=${config.sops.placeholder.github_pat}
    '';
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
      config.sops.templates."hermes-github.env".path
    ];
    addToSystemPackages = true;
    backend = {
      mode = "serve";
      host = "127.0.0.1";
      port = 9119;
      sessionTokenFile = config.sops.secrets."hermes/session_token".path;
    };

    mcpServers = {
      github = {
        url = "https://api.githubcopilot.com/mcp";
        headers.Authorization = "Bearer \${env:GITHUB_MCP_TOKEN}";
      };
      home-assistant = {
        url = "https://hm.rh-development.nl/api/mcp";
        auth = "oauth";
      };
    };
  };
}
