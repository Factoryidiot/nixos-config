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
  pkgs-unstable = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{

  # 1. Enable Hyprlock and Hypridle as system services
  # This makes them available system-wide and manages their daemon lifecycle.

  programs.hyprland = {
    enable = true;
    withUSWM = true;
    # Package is automatically provided by hyprland.nixosModules.default
    # Currently provides: 0.51.0+date=2025-10-31_8e9add2
    package = inputs.hyprland.packages.${system}.default;
    portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
  };
  programs.hyprlock.enable = true;
  services.hypridle.enable = true;

  # 2. Set essential Wayland environment variables globally (Best Practice)
  environment.sessionVariables = {
    # Recommended for Chromium/Electron-based apps to use Wayland natively
    NIXOS_OZONE_WL = "1";
    # Sometimes necessary to prevent cursor issues on certain hardware
    WLR_NO_HARDWARE_CURSORS = "1";
    # CRITICAL for Java/AWT apps (like JetBrains IDEs) to display correctly
    _JAVA_AWT_WM_NONREPARENTING = "1";
    # Explicitly define the session type for applications that check XDG_SESSION_TYPE
    XDG_SESSION_TYPE = "wayland";
  };

  # 3. Install core Hyprland-related packages system-wide
  # Only binaries required for system services or widely used are installed here.
  environment.systemPackages = with pkgs; [
    hyprpicker
    hyprcursor
    hyprlock
    hypridle
    hyprpaper
  ];

}
