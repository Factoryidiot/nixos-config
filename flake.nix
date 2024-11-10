{
  description = "NIXOS Configuration Flake";

  nixConfig = {
    extra-substituters = [
      "https://anyrun.cachix.org"
      "https://nix-community.cachix.org" 
      "https://nix-gaming.cachix.org"
    ];
    extra-trusted-public-keys = [
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    agenix = {
      url = "github:ryan4yin/ragenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags.url = "github:Aylur/ags";
    anyrun = {
      url = "github:anyrun-org/anyrun";
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
    nix-gaming.url = "github:fufexan/nix-gaming";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ disko, home-manager, impermanence, lanzaboote, nixos-hardware, nixpkgs, nixvim, self, ... }:
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

            ./hosts/whio/default.nix
            ./hosts/whio/disko.nix
            ./hosts/whio/persistence.nix
            ./hosts/whio/secureboot.nix

#            ./secrets/default.nix

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
