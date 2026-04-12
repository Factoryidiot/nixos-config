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
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    agenix.url = "github:ryan4yin/ragenix";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      #url = "github:hyprwm/Hyprland/75f6435f70dee8f8b685a02c52db7ba16f5db39c";
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    impermanence.url = "github:nix-community/impermanence";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/";
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
    , self
    , ...
    }:
    let
      system = "x86_64-linux"; # The system type we will use
      pkgs = nixpkgs.legacyPackages.${system};

      specialArgs = {
        inherit agenix hyprland impermanence inputs lanzaboote nixpkgs-unstable nixvim self;
      };

      commonModules = [
        agenix.nixosModules.default
        ./lib/nixos/secrets.nix
        home-manager.nixosModules.home-manager
        ({ config, ... }: {
          home-manager = {
            backupFileExtension = "backup";
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = specialArgs // { secrets = config.age.secrets; };
          };
        })
        ({ ... }: {
          nixpkgs.overlays = [
            self.overlays.gemini-cli
          ];
        })
      ];

      mkNixosSystem = { name, username, modules, isServer ? false }:
        let
          hostname = name;
          hostArgs = specialArgs // { inherit hostname username isServer; };
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = hostArgs; # Pass the combined args
          modules = commonModules
            ++ modules
            ++ [
            ({ ... }: {
              nixpkgs.config.allowUnfree = true;
              home-manager.users.${username} = import ./users/${username}/default.nix {
                inherit (hostArgs) isServer;
                inherit (specialArgs) agenix inputs lib; # Explicitly inherit agenix, inputs, and lib from specialArgs
              };
            })
          ];
        };
    in
    {

      overlays.gemini-cli = final: prev: {
        gemini-cli = inputs.nixpkgs-unstable.legacyPackages.${system}.gemini-cli;
      };

      devShells.${system}.default = pkgs.mkShell {
        packages = [
          agenix.packages.${system}.default
          pkgs.nixpkgs-fmt
        ];
      };

      nixosConfigurations = {
        whio = mkNixosSystem {
          name = "whio";
          username = "factory";
          isServer = false;
          modules = [
            ./hosts/whio/default.nix
            {
              system.stateVersion = "25.11";
            }
          ];
        };

        tahi = mkNixosSystem {
          name = "tahi";
          username = "factory";
          isServer = true;
          modules = [
            ./hosts/tahi/default.nix
            {
              system.stateVersion = "25.11";
            }
          ];
        };

      };

      # Standard outputs for convenience
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;
      packages.${system} = {
        nixos-system-tahi = self.nixosConfigurations.tahi.config.system.build.toplevel;
        nixos-system-whio = self.nixosConfigurations.whio.config.system.build.toplevel;
      };

    };

}
