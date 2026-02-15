{ inputs, ... }: {
  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

  services.flatpak.enable = true;
  nix-flatpak.remotes = [{
    name = "flathub";
    location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
  }];

  nix-flatpak.installations = [{
    app-id = "io.github.kolunmi.Bazaar";
  }];
}
