# lib/home/desktop/hyprland.nix
{
  config
  , inputs
  , lib
  , pkgs
  , ...
}:
let

  # Access the hyprland input via the inputs specialArg passed from flake.nix
  hyprlandInput = inputs.hyprland;
  system = pkgs.stdenv.hostPlatform.system;

in
{
  imports = [
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    systemd.enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland # Use the package from the main pkgs set
    ];
    # Ensure this is the preferred backend
    config.common.default = "hyprland";
  };

  # Link the configuration file from your dotfiles directory
  xdg.configFile = 
  let
    symlink = file: config.lib.file.mkOutOfStoreSymlink file;
    dotfiles = "${config.home.homeDirectory}/.dotfiles";
  in
  lib.mkDefault {
    # Main Hyprland configuration
    "hypr/autostart.conf".source = symlink "${dotfiles}/hypr/autostart.conf";
    "hypr/bindings.conf".source = symlink "${dotfiles}/hypr/bindings.conf";
    "hypr/env.conf".source = symlink "${dotfiles}/hypr/env.conf";
    "hypr/hypridle.conf".source = symlink "${dotfiles}/hypr/hypridle.conf";
    "hypr/hyprland.conf".source = symlink "${dotfiles}/hypr/hyprland.conf";
    "hypr/hyprlock.conf".source = symlink "${dotfiles}/hypr/hyprlock.conf";
    "hypr/hyprsunset.conf".source = symlink "${dotfiles}/hypr/hyprsunset.conf";
    "hypr/input.conf".source = symlink "${dotfiles}/hypr/input.conf";
    "hypr/monitors.conf".source = symlink "${dotfiles}/hypr/monitors.conf";

    # Wallpaper utility
    #"hypr/hyprpaper.conf".source = ./hypr/hyprpaper.conf;
  };

  # Set up environment variables required by Desktop
  home.sessionVariables = {
    TERMINAL = "alacritty";   # Specify the terminal emulator
    NIXOS_OZONE_WL = "1";     # Tell GTK apps to use the correct theme engine
    XDG_CURRENT_DESKTOP = "Hyprland";
  };

}
