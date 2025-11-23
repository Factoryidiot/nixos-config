# lib/nixos/hyprland-services.nix
{
  config
  , inputs
  , lib
  , pkgs
  , ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{

# This makes them available as system daemons managed by NixOS.
  programs.hyprlock = {
    enable = true;
    package = pkgs-unstable.hyprlock;
  };
  services.hypridle = {
    enable = true;
    package = pkgs-unstable.hypridle;
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;

    package = inputs.hyprland.packages.${system}.default;
    portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;

  };

  environment.sessionVariables = {
  };

  # Install core Hyprland-related packages system-wide
  environment.systemPackages = with pkgs; [
  ];

}
