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
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ disko, home-manager, nixpkgs, self, ... }:
    let
      username = "rhys";
      specialArgs = { inherit username; };
      system = "x86_64-linux";
    in {
      nixosConfigurations = {

        nixos-qemu = nixpkgs.lib.nixosSystem {
          # system = "x86_64-linux";
          inherit specialArgs;

          modules = [
            disko.nixosModules.disko

            ./hosts/nixos-qemu
            ./hosts/nixos-qemu/disko.nix

            {
              _module.args.disks = [ "/dev/vda" "/dev/vdb" ];
            }
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = inputs // specialArgs;
              home-manager.users.${username} = import ./users/${username}/home.nix;
            }
          ];

        whio = nixpkgs.lib.nixosSystem {
          inherit specialArgs;

          modules = [
            disko.nixosModules.disko

            ./hosts/whio
            ./hosts/whio/disko.nix

            # {
            #   _module.args.disks = [ "/dev/nvme0n1" ];
            # }
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = inputs // specialArgs;
              home-manager.users.${username} = import ./users/${username}/home.nix;
            }
          ];
        };

    };
  
}
