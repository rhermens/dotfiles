{
  description = "Home Manager configuration of roy";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl = {
      url = "github:nix-community/nixGL?ref=pull/187/head";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, nixgl, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations."roy" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];
        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          inherit nixgl;
        };
      };
    };
}
