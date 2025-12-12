# lib/home/desktop.nix
{
  pkgs
  , ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  imports = [
    ./desktop/browser.nix
    ./desktop/hyprland.nix
    ./desktop/mako.nix
    ./desktop/terminal.nix
    ./desktop/walker.nix
    ./desktop/waybar.nix
  ];

  # Install necessary packages for a working desktop environment
  home.packages = with pkgs; [

    # Other desktop dependencies
    swaybg # Basic wallpaper setter for fallback
    jq # Needed for many Waybar scripts
    pamixer # Audio control
    brightnessctl # Brightness control

    # You can add more here (e.g., foot, wezterm, firefox, etc.)
 
    xdg-desktop-portal
    xdg-desktop-portal-gtk
  ];

}
