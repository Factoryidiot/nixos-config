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

  #programs.wayland.enable = true;

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
    kitty
    hyprpicker
    hyprcursor
    hyprlock
    hypridle
    hyprpaper
  ];

}
