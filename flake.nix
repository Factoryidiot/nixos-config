{
  description = "NIXOS Configuration Flake";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://nix-gaming.cachix.org"
      "https://hyprland.cachix.org"
      "https://walker.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM="
    ];
  };

  inputs = {
    # Primary stable channel, all inputs follow this unless otherwise noted
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    agenix.url = "github:ryan4yin/ragenix";
    home-manager = {
      # Updated to use the release branch from your second file
      url = "github:nix-community/home-manager/release-25.11";
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
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    terminaltexteffects = {
      url = "github:ChrisBuilds/terminaltexteffects/release-0.14.2";
      flake = false;
    };
    elephant.url = "github:abenz1267/elephant";
    walker = {
      url = "github:abenz1267/walker";
      inputs.elephant.follows = "elephant";
    };
  };

  outputs =
    inputs@{ agenix
    , home-manager
    , hyprland
    , impermanence
    , lanzaboote
    , nixpkgs
    , nixpkgs-unstable
    , nixvim
    , terminaltexteffects
    , walker
    , self
    , ...
    }:
    let
      system = "x86_64-linux"; # The system type we will use

      # Pass inputs and self to all configurations for easy access
      specialArgs = {
        #inherit agenix hyprland impermanence inputs lanzaboote nixpkgs-unstable self terminaltexteffects;
        inherit agenix hyprland impermanence inputs lanzaboote nixpkgs-unstable nixvim self;
      };

      # Common modules for all systems (DRY principle)
      commonModules = [
        ./lib/nixos/secrets.nix
        # Common home-manager configuration
        home-manager.nixosModules.home-manager
        ({ config, ... }: {
          home-manager = {
            backupFileExtension = "backup";
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = specialArgs // { secrets = config.age.secrets; };
          };
        })
      ];

      # Helper function to create a NixOS configuration
      mkNixosSystem = { name, username, modules }:
        let
          hostname = name;
          hostArgs = specialArgs // { inherit hostname username; };

          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [ ];
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

    in
    {
      nixosConfigurations = {
        whio = mkNixosSystem {
          name = "whio";
          username = "rhys";
          modules = [
            ./hosts/whio/default.nix
            {
              system.stateVersion = "25.11";
            }
          ];
        };

        whio-vm = mkNixosSystem {
          name = "whio-vm";
          username = "rhys";
          modules = [
            ./hosts/whio-vm/default.nix
            {
              system.stateVersion = "25.11";
            }
          ];
        };

      };

      # Standard outputs for convenience
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;
      defaultPackage.${system} = self.packages.${system}.nixos-system-whio-vm;
      packages.${system} = {
        nixos-system-whio-vm = self.nixosConfigurations.whio-vm.config.system.build.toplevel;
        nixos-system-whio = self.nixosConfigurations.whio.config.system.build.toplevel;
      };

    };
}
