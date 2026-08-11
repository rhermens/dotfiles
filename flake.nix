{
  description = "NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helium = {
      url = "github:AlvaroParker/helium-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hp-tracerled = {
      url = "github:rhermens/hp-tracerled-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-watch = {
      url = "github:rhermens/git-watch";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, determinate, nix-darwin, home-manager, helium, lanzaboote, hp-tracerled, git-watch, ... }@inputs:
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
            lanzaboote.nixosModules.lanzaboote
            git-watch.nixosModules.default
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.roy = {
                imports = [ ./nix/home.nix ./nix/ai.nix ./nix/development.nix ];
              };
            }
          ];
        };
        msi = nixpkgs.lib.nixosSystem {
          modules = [
            {
              nixpkgs.hostPlatform = "x86_64-linux";
              nixpkgs.config.cudaSupport = true;
            }
            ./nix/configuration-msi.nix
            home-manager.nixosModules.home-manager
            git-watch.nixosModules.default
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.roy = {
                imports = [ ./nix/home.nix ./nix/ai.nix ];
              };
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
            git-watch.darwinModules.default
            determinate.homeManagerModules.default
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.roy = {
                imports = [ ./nix/home.nix ./nix/home-darwin.nix ./nix/ai.nix ./nix/development.nix ];
                home.homeDirectory = "/Users/roy";
              };
            }
          ];
        };
      };
    };
}
