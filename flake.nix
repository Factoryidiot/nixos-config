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
    agenix = {
      url = "github:ryan4yin/ragenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };  
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  # outputs = inputs@{ agenix, disko, home-manager, lanzaboote, nixpkgs, self, ... }:
  outputs = inputs@{ disko, home-manager, impermanence, lanzaboote, nixos-hardware, nixpkgs, self, ... }:
    let
      username = "rhys";
      specialArgs =
        inputs
        // { 
         inherit username;
        };
      system = "x86_64-linux";
    in {
      nixosConfigurations = {

        nixos-qemu = nixpkgs.lib.nixosSystem {
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
        };

        whio = nixpkgs.lib.nixosSystem {
          inherit specialArgs;

          modules = [
            disko.nixosModules.disko
            impermanence.nixosModules.impermanence
            lanzaboote.nixosModules.lanzaboote

            ./hosts/whio/default.nix
            ./hosts/whio/disko.nix
            ./hosts/whio/impermanence.nix
            ./hosts/whio/secureboot.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = inputs // specialArgs;
              home-manager.users.${username} = import ./users/${username}/home.nix;
            }
          ];
        };

      }; # nixosConfigurations
    };

}
