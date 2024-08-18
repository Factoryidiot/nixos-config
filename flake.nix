{
  description = "NIXOS Configuration Flake";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org" 
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ home-manager, nixpkgs, ... }:

  {
    nixosConfigurations = {

      nixos-qemu = let
        username = "rhys";
        specialArgs = { inherit username; };
      in
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          inherit specialArgs;

          modules = [
            ./hosts/nixos-qemu
            # ./users/${username}/configuration.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = inputs;
              home-manager.users.${username} = import ./users/${username}/home.nix;
            }
          ];
        };
    };
  };
  
}
