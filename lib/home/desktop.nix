{
  config
  , inputs
  , lib
  , pkgs
  , nixpkgs-unstable
  , ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  imports = [
    ./desktop/alacritty.nix
    ./desktop/hyprland.nix
    #./desktop/walker.nix
    ./desktop/waybar.nix
  ];

  # Install necessary packages for a working desktop environment
  home.packages = with pkgs; [
    # Hyprland utilities (installed globally for the user)
    inputs.hyprland.packages.${system}.hyprpaper # Wallpaper utility
    nixpkgs-unstable.hyprlock # Lock screen
    nixpkgs-unstable.hypridle # Idle daemon
    
    # Common terminal
    alacritty

    # Other desktop dependencies
    swaybg # Basic wallpaper setter for fallback
    jq # Needed for many Waybar scripts
    pamixer # Audio control
    brightnessctl # Brightness control
    # You can add more here (e.g., foot, wezterm, firefox, etc.)
  ];

  # Set up environment variables required by Hyprland and Wayland
  home.sessionVariables = {
    # Specify the terminal emulator
    TERMINAL = "alacritty";
    # Tell GTK apps to use the correct theme engine
    NIXOS_OZONE_WL = "1";
  };
}
