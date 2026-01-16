# lib/home/desktop/hyprland.nix
{ config, inputs, lib, pkgs, ... }:
let

  # Access the hyprland input via the inputs specialArg passed from flake.nix
  hyprlandInput = inputs.hyprland;
  system = pkgs.stdenv.hostPlatform.system;

in
{

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    systemd.enable = false;
    xwayland.enable = true;
  };

  # Link the configuration file from your dotfiles directory
  xdg.configFile = {
    # Main Hyprland configuration
    "hypr/autostart.conf".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/hypr/autostart.conf";
    "hypr/keybindings.conf".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/hypr/keybindings.conf";
    "hypr/envs.conf".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/hypr/envs.conf";
    "hypr/hypridle.conf".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/hypr/hypridle.conf";
    "hypr/hyprland.conf".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/hypr/hyprland.conf";
    "hypr/hyprlock.conf".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/hypr/hyprlock.conf";
    "hypr/hyprsunset.conf".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/hypr/hyprsunset.conf";
    "hypr/input.conf".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/hypr/input.conf";
    "hypr/looknfeel.conf".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/hypr/looknfeel.conf";
    "hypr/monitors.conf".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/hypr/monitors.conf";
    "hypr/windows.conf".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/hypr/windows.conf";

    # Wallpaper utility
    #"hypr/hyprpaper.conf".source = ./hypr/hyprpaper.conf;
  };

  # Set up environment variables required by Desktop
  home.sessionVariables = {
    TERMINAL = "alacritty"; # Specify the terminal emulator
    WLR_RENDERER = "vulkan";
  };

}
