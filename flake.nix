{
  description = "NIXOS Configuration Flake";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://nix-gaming.cachix.org"
      "https://hyprland.cachix.org"
      "https://walker.cachix.org"
      "https://walker-git.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM="
      "walker-git.cachix.org-1:vmC0ocfPWh0S/vRAQGtChuiZBTAe4wiKDeyyXM0/7pM="
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
    home-manager = {
      # Updated to use the release branch from your second file
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    impermanence.url = "github:nix-community/impermanence";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.3";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-gaming.url = "github:fufexan/nix-gaming";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    elephant = {
      url = "github:abenz1267/elephant";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    walker = {
      url = "github:abenz1267/walker";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.elephant.follows = "elephant";
    };
  };

  outputs = inputs@{
    nixpkgs
    , home-manager
    , hyprland
    , impermanence
    , lanzaboote
    , nixpkgs-unstable
    , self
    , walker
    , ...
  }:
    let
      system = "x86_64-linux"; # The system type we will use

      # Pass inputs and self to all configurations for easy access
      specialArgs = {
        inherit hyprland impermanence inputs lanzaboote nixpkgs-unstable self;
      };
 
      # Common modules for all systems (DRY principle)
      commonModules = [
        # Common home-manager configuration
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            backupFileExtension = "backup";
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = specialArgs;
          };
        }
      ];

      # Helper function to create a NixOS configuration
      mkNixosSystem = { name, username, modules }:
        let
          hostname = name;
          hostArgs = specialArgs // { inherit hostname username; };

          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };

        in
          nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = hostArgs; # Pass the combined args
            modules = commonModules
              ++ modules
              ++ [
                # Allow unfree packages for this system configuration
                ({ pkgs, ... }: {
                  nixpkgs.config.allowUnfree = true;
                })
                # This connects Home Manager to the specified user.
                # The user itself (password, groups) should be defined
                # in the host's module (e.g., ./hosts/whio/default.nix)
                ({ ... }: {
                  home-manager.users.${username} = import ./users/${username}/home.nix;
                })
              ];
          };

    in {
      nixosConfigurations = {
        whio = mkNixosSystem {
          name = "whio";
          username = "rhys";
          modules = [
            ./hosts/whio/default.nix
            # ./secrets/default.nix # Uncommented for clarity
            {
              system.stateVersion = "25.05";
            }
          ];
        };

        whio-test = mkNixosSystem {
          name = "whio-test";
          username = "rhys";
          modules = [
            ./hosts/whio-test/default.nix
            #./secrets/default.nix
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
