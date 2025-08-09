{
  description = "Home Manager configuration of roy";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-fsnotify = {
      url = "github:rhermens/git-fsnotify";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, git-fsnotify, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.msi = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./nixos/hardware-laptop.nix
          ./nixos/hw/nvidia.nix
          ./nixos/hw/laptop.nix
          ./nixos/feat/gaming.nix
          ./nixos/feat/downloading.nix
          ./nixos/feat/virtfs.nix
          ./configuration.nix
          {
            networking.hostName = "msi";
          }
        ];
      };

      nixosConfigurations.omen = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./nixos/hardware-omen.nix
          ./nixos/hw/nvidia.nix
          ./nixos/feat/downloading.nix
          ./nixos/feat/gaming.nix
          ./nixos/feat/sound-engineering.nix
          ./nixos/feat/virtfs.nix
          ./configuration.nix
          {
            networking.hostName = "omen";
          }
        ];
      };

      homeConfigurations.roy = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [ ./home.nix git-fsnotify.homeManagerModules.${system}.git-fsnotify ];
      };
    };
}
