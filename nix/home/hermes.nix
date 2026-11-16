{ inputs, config, ... }:
{
  imports = [
    inputs.hermes-agent.homeManagerModules.default
  ];

  sops.secrets."hermes/env" = {};

  programs.hermes-agent = {
    enable = true;
    desktop.enable = true;
  };

  services.hermes-agent = {
    enable = true;
    environmentFiles = [
      config.sops.secrets."hermes/env".path
    ];
    gateway.enable = true;

    settings = {
      a2a.trusted_peers = [ "server" ];
      platforms.a2a = {
        enabled = true;
        extra = {
          enabled = true;
          port = 9900;
        };
      };
    };
  };
}
