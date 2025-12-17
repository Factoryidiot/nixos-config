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
    #+---- Audio -----------------------
    pamixer				# Audio control
    playerctl				# CMD-Line to control media players

    # Other desktop dependencies
    swaybg	# Basic wallpaper setter for fallback
    brightnessctl # Brightness control

    #+---- Security and Auth -----------
    libsecret

    #+---- Shell -----------------------
    bat					# Cat clone with syntax highlighting and Git integration
    eza					# Replacement for `ls`
    fastfetch				# System information fetch tool
    fd					# Simple, fast and user-friendly alternative to `find`
    fzf					# Command line fuzzy finder
    jq					# Needed for many Waybar scripts
    ripgrep				# Search tool
    terminaltexteffects			# Screensaver 
    zoxide				# `cd` command tool


    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-terminal-exec
  ];

}
