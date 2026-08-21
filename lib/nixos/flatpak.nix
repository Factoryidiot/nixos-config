{ inputs
, specialArgs ? { }
, ...
}:
let
  inherit (specialArgs) username;
in
{

  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

  services.flatpak = {
    enable = true;
    overrides = {
      "md.obsidian.Obsidian" = {
        Environment = {
          ELECTRON_OZONE_PLATFORM_HINT = "auto";
        };
      };
    };
    packages = [
      "io.github.kolunmi.Bazaar"
      "md.obsidian.Obsidian"
      "com.github.tchx84.Flatseal"
    ];
    remotes = [{
      name = "flathub";
      location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    }];
  };

  #+----- Impermanence Persistence -------------
  # Modular persistence: persist Flatpak system runtimes and per-user application state
  environment.persistence."/persistent" = {
    directories = [
      "/var/lib/flatpak"
    ];
    users.${username} = {
      directories = [
        ".local/share/flatpak"
        ".var/app"
      ];
    };
  };

}
