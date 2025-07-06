{
  description = "Home Manager configuration of roy";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
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
          ./configuration.nix
          {
            networking.hostName = "omen";
          }
        ];
      };

      homeConfigurations.roy = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [ ./home.nix ];
      };
    };
}
