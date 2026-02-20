{ inputs
, ... 
}: {

  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

  services.flatpak = {
    enable = true;
    packages = [
      "com.bitwarden.desktop"
      "io.github.kolunmi.Bazaar"
      "md.obsidian.Obsidian"
    ];
    remotes = [{
      name = "flathub";
      location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    }];
  };

}
