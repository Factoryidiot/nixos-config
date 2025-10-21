{
  description = "NIXOS Install Flake";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    # Primary stable channel, all inputs follow this unless otherwise noted
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    
   disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
   preservation.url = "github:nix-community/preservation";
  };

  outputs = inputs@{
    nixpkgs
    , disko
    , preservation
    , self
    , ...
  }:
    let
      username = "rhys";
      system = "x86_64-linux";
     
      # Pass inputs and self to all configurations for easy access
      specialArgs = {
        inherit username inputs preservation self;
      };

      # Common modules for all systems (DRY principle)
      commonModules = [
        ./configuration.nix
        disko.nixosModules.disko
      ];

      # Helper function to create a NixOS configuration
      mkNixosSystem = { name, modules }:
        nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = commonModules ++ modules;
        };

    in {
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
            ../hosts/whio-qemu/default.nix
            ../hosts/whio-qemu/disko.nix        # Disk partitioning and Btrfs setup
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
