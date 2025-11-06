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
    
    preservation.url = "github:nix-community/preservation";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = inputs@{
    nixpkgs
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
      ];

      # Helper function to create a NixOS configuration
      mkNixosSystem = { name, modules }:
        let
          hostname = name;                                        # The hostname for this system is the same as its name in the flake
          hostArgs = specialArgs // { inherit hostname; }; # Merge the global special arguments with the host-specific ones (hostname)
        in
          nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = hostArgs;
            modules = commonModules ++ modules;
        };

    in {
      nixosConfigurations = {
        whio = mkNixosSystem {
          name = "whio";
          modules = [
            ./whio/default.nix
            # ./secrets/default.nix # Uncommented for clarity
            {
              system.stateVersion = "25.05";
            }
          ];
        };

        whio-test = mkNixosSystem {
          name = "whio-test";
          modules = [
            ../hosts/whio-test/default.nix
            ./configuration.nix
            {
              # Ensure the system state version is set
              system.stateVersion = "25.05";
            }
          ];
        };
      };

      # Standard outputs for convenience
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;
      defaultPackage.${system} = self.packages.${system}.nixos-system-whio-test;
      packages.${system}.nixos-system-whio-test = self.nixosConfigurations.whio-test.config.system.build.toplevel;

    };

}
