{
  description = "NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hp-tracerled.url = "github:rhermens/hp-tracerled-rs";
  };

  outputs = { self, nixpkgs, home-manager, hp-tracerled, ... }@inputs: {
    nixosConfigurations = {
      omen = nixpkgs.lib.nixosSystem {
        modules = [
          { nixpkgs.hostPlatform = "x86_64-linux"; }
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
