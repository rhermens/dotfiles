{ inputs, config, lib, pkgs, ... }:
let
  upstream = inputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.default;

  # Upstream nix/pnpm-deps-hash only matches Linux: pnpm-workspace.yaml has no
  # supportedArchitectures, so pnpm fetches host-specific optional binaries.
  # Inject the Darwin hash into fetchPnpmDeps via hermes-agent.nix's callPackage arg.
  darwinPnpmDepsHash = "sha256-0DFhYHo5HDps1hz6Haqv3cQfA1ug10LL/ohxKZGSDlw=";
  darwinPackage = upstream.override (prev: {
    electron = import ../darwin/hermes-electron.nix {
      inherit inputs pkgs;
      username = config.home.username;
    };
    callPackage =
      fn: args:
      let
        f = if builtins.isFunction fn then fn else import fn;
        fetchPnpmDeps = prev.callPackage ({ fetchPnpmDeps }: fetchPnpmDeps) { };
      in
      prev.callPackage fn (
        args
        // lib.optionalAttrs ((lib.functionArgs f) ? fetchPnpmDeps) {
          fetchPnpmDeps = a: fetchPnpmDeps (a // { hash = darwinPnpmDepsHash; });
        }
      );
  });
in
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
    package = lib.mkIf pkgs.stdenv.isDarwin darwinPackage;
    environmentFiles = [
      config.sops.secrets."hermes/env".path
    ];
    gateway.enable = true;

    settings = {
      model = {
        provider = "openai-codex";
        base_url = "https://chatgpt.com/backend-api/codex";
        default = "gpt-6.1-sol";
      };
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
