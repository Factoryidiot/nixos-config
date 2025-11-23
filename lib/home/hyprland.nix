# lib/home/hyprland.nix
{
  config
  , inputs
  , pkgs
  , ...
}:
let
  # Access the hyprland input via the inputs specialArg passed from flake.nix
  hyprlandInput = inputs.hyprland;
  system = pkgs.stdenv.hostPlatform.system;
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    package = hyprlandInput.packages.${system}.hyprland;
  };

  xdg.configFile = {
    # Main Hyprland configuration
    "hypr/autostart.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/hypr/autostart.conf";
    "hypr/bindings.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/hypr/bindings.conf";
    "hypr/env.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/hypr/env.conf";
    "hypr/hypridle.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/hypr/hypridle.conf";
    "hypr/hyprland.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/hypr/hyprland.conf";
    "hypr/hyprlock.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/hypr/hyprlock.conf";
    "hypr/hyprsunset.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/hypr/hyprsunset.conf";
    "hypr/input.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/hypr/input.conf";
    "hypr/monitors.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/hypr/monitors.conf";

    # Wallpaper utility
    #"hypr/hyprpaper.conf".source = ./hypr/hyprpaper.conf;
  };

  # 4. Install necessary packages for a working desktop environment
  home.packages = with pkgs; [
  ];

  # Set up a few basic environment variables for Hyprland to function well
  home.sessionVariables = {
  };
}
