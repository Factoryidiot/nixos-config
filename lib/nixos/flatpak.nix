{ inputs
, ...
}: {

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

}
