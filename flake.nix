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
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ disko, flake-parts, home-manager, nixpkgs, self, ... }:
  flake-parts.lib.mkFlake { inherit inputs; } 
  {
    systems = [ "x86_64-linux" ];

    flake = let 
      username = "rhys";
      specialArgs = { inherit username; };
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {

      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.extraSpecialArgs = inputs // specialArgs;
            home-manager.users.${username} = import ./users/${username}/home.nix;
          }


        ];
      };

      nixosConfigurations.nixos-qemu = {
        nixpkgs.lib.nixosSystem {
          # inherit specialArgs;

          modules = [
            disko.nixosModules.disko

            ./hosts/nixos-qemu
            ./hosts/nixos-qemu/disko.nix

            {
              _module.args.disks = [ "/dev/vda" "/dev/vdb" ];
            }

          ];
        };
    };
  };
  
}
