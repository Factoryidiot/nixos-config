 lib/nixos/hyprland-services.nix
{ pkgs, ... }:

{
  # 1. Enable Hyprlock and Hypridle as system services
  # This makes them available system-wide and manages their daemon lifecycle.
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
