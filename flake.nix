{
  description = "NIXOS Configuration Flake";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://nix-gaming.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
    ];
  };

  inputs = {
    # Primary stable channel, all inputs follow this unless otherwise noted
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    
    agenix = {
      url = "github:ryan4yin/ragenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    preservation.url = "github:nix-community/preservation";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-gaming.url = "github:fufexan/nix-gaming";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = inputs@{
    nixpkgs
    , home-manager
    , disko
    , lanzaboote
    , preservation
    , self
    , ...
  }:
    let
      username = "rhys";
      system = "x86_64-linux";
      
      # Pass inputs and self to all configurations for easy access
      specialArgs = {
        inherit username inputs lanzaboote preservation self;
      };

      # Common modules for all systems (DRY principle)
      commonModules = [
        disko.nixosModules.disko
        home-manager.nixosModules.home-manager
        {
          # Common home-manager configuration
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = specialArgs;
          home-manager.users.${username} = import ./users/${username}/home.nix;
        }
      ];

      # Helper function to create a NixOS configuration
      mkNixosSystem = { name, modules }:
        nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = commonModules ++ modules;
        };

    in {
      # Define system configurations using the helper function
      nixosConfigurations = {
        nixos-qemu = mkNixosSystem {
          name = "nixos-qemu";
          modules = [
            ./hosts/nixos-qemu
            ./hosts/nixos-qemu/disko.nix
            {
              # Host-specific argument for disko
              _module.args.disks = [ "/dev/vda" "/dev/vdb" ];
            }
          ];
        };

        whio = mkNixosSystem {
          name = "whio";
          modules = [
            ./hosts/whio/default.nix
            # ./secrets/default.nix # Uncommented for clarity
          ];
        };

        whio-qemu = mkNixosSystem {
          name = "whio-qemu";
          modules = [
            ./hosts/whio-qemu/default.nix
            {
              # QEMU disk is always /dev/vda
              _module.args.disks = [ "/dev/vda" ];
              # Ensure the system state version is set
              system.stateVersion = "25.05";
            }
            
          ];
        };
      };
      
      # Standard outputs for convenience
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;
      defaultPackage.${system} = self.packages.${system}.nixos-system-whio-qemu;
      packages.${system}.nixos-system-whio-qemu = self.nixosConfigurations.whio-qemu.config.system.build.toplevel;
    };
}
