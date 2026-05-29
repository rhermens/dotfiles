{
  description = "NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      omen = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nix/configuration-omen.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.roy = ./nix/home.nix;
          }
        ];
      };
    };

    homeConfigurations = {
      "roy" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { system = "aarch64-darwin"; config.allowUnfree = true; };
        extraSpecialArgs = { inherit inputs; };
        modules = [
          ./nix/home.nix
          { home.homeDirectory = "/Users/roy"; }
        ];
      };
    };
  };
}
