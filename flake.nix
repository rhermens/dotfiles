{
  description = "NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Last nixpkgs revision with tmux 3.7c; tmux 3.8 segfaults in choose-tree.
    nixpkgs-tmux.url = "github:nixos/nixpkgs/3d5072d4576db81df6e1c7fc23eadec306677491";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
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
    wt = {
      url = "github:rhermens/wt";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    github-stream= {
      url = "github:rhermens/github-stream";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agents = {
      url = "github:rhermens/.agents";
    };
    qmd = {
      url = "git+https://github.com/tobi/qmd?ref=refs/tags/v2.8.3";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-watch = {
      url = "github:rhermens/git-watch";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jira-stream = {
      url = "github:rhermens/jira-stream";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    exiled-exchange-2 = {
      url = "github:rhermens/exiled-exchange-2-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, sops-nix, nixpkgs-tmux, determinate, nix-darwin, home-manager, lanzaboote, hp-tracerled, git-watch, ... }@inputs:
    let
      tmuxPin = {
        nixpkgs.overlays = [
          (final: prev: {
            tmux = (import nixpkgs-tmux {
              system = prev.stdenv.hostPlatform.system;
              config = prev.config;
            }).tmux;
          })
        ];
      };
    in
    {
      nixosConfigurations = {
        omen = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            tmuxPin
            {
              nixpkgs.hostPlatform = "x86_64-linux";
              nixpkgs.config.cudaSupport = true;
            }
            ./nix/configuration-omen.nix
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops
            hp-tracerled.nixosModules.default
            lanzaboote.nixosModules.lanzaboote
            git-watch.nixosModules.default
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.roy = {
                imports = [ ./nix/home-core.nix ./nix/home/ai.nix ./nix/home/development.nix ./nix/home/notes.nix ./nix/home/media-editing.nix ];
              };
            }
          ];
        };
        msi = nixpkgs.lib.nixosSystem {
          modules = [
            tmuxPin
            {
              nixpkgs.hostPlatform = "x86_64-linux";
              nixpkgs.config.cudaSupport = true;
            }
            ./nix/configuration-msi.nix
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops
            git-watch.nixosModules.default
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.roy = {
                imports = [ ./nix/home-core.nix ./nix/home/ai.nix ];
              };
            }
          ];
        };
        server = nixpkgs.lib.nixosSystem {
          modules = [
            tmuxPin
            {
              nixpkgs.hostPlatform = "x86_64-linux";
            }
            ./nix/configuration-server.nix
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.roy = {
                imports = [ ./nix/home-core.nix ];
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
            tmuxPin
            determinate.darwinModules.default
            ./nix/configuration-darwin.nix
            home-manager.darwinModules.home-manager
            git-watch.darwinModules.default
            sops-nix.darwinModules.sops
            determinate.homeManagerModules.default
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.roy = {
                imports = [ ./nix/home-core.nix ./nix/home-darwin.nix ./nix/home/ai.nix ./nix/home/development.nix ./nix/home/notes.nix ./nix/home/work.nix ];
                home.homeDirectory = "/Users/roy";
              };
            }
          ];
        };
      };
    };
}
