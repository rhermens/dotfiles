{
  description = "NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    llm-agents.url = "github:numtide/llm-agents.nix";
    hp-tracerled.url = "github:rhermens/hp-tracerled-rs";
  };

  outputs = { self, nixpkgs, determinate, nix-darwin, home-manager, hp-tracerled, llm-agents, ... }@inputs:
    {
      nixosConfigurations = {
        omen = nixpkgs.lib.nixosSystem {
          modules = [
            {
              nixpkgs.hostPlatform = "x86_64-linux";
              nixpkgs.config.cudaSupport = true;
              nixpkgs.overlays = [
                (final: prev: {
                  mongodb-compass = prev.mongodb-compass.overrideAttrs (old: {
                    buildCommand = builtins.replaceStrings
                      [ "wrapGAppsHook $out/bin/mongodb-compass" ]
                      [ "wrapGApp $out/bin/mongodb-compass" ]
                      old.buildCommand;
                  });
                })
              ];
            }
            ./nix/configuration-omen.nix
            home-manager.nixosModules.home-manager
            hp-tracerled.nixosModules.default
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.roy = ./nix/home.nix;
            }
          ];
        };
      };

      darwinConfigurations = {
        MBP-Roy = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs self; };

          modules = [
            determinate.darwinModules.default
            ./nix/configuration-darwin.nix
            home-manager.darwinModules.home-manager
            determinate.homeManagerModules.default
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.roy = {
                imports = [ ./nix/home.nix ./nix/home-darwin.nix ];
                home.homeDirectory = "/Users/roy";
              };
            }
          ];
        };
      };
    };
}
