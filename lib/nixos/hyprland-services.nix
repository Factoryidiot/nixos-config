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
  #pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${system};
in
{

# This makes them available as system daemons managed by NixOS.
  programs.hyprlock = pkgs-unstable.hyprlock;
  services.hypridle = pkgs-unstable.hypridle;

  programs.hyprland = {
    enable = true;
    withUWSM = true;

    package = inputs.hyprland.packages.${system}.default;
    portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;

  };

  environment.sessionVariables = {
    hyprpaper
    hyprlock
    hypridle
  };

  # Install core Hyprland-related packages system-wide
  environment.systemPackages = with pkgs; [
    # Ensure all graphical programs use Wayland where possible
    NIXOS_OZONE_WL = "1";
    # Set the backend for Hyprland's portal 
    XDG_CURRENT_DESKTOP = "Hyprland"; 
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
  ];

}
