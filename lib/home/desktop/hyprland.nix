# lib/home/desktop/hyprland.nix
{ config
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
    "hypr/looknfeel.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/hypr/looknfeel.conf";
    "hypr/monitors.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/hypr/monitors.conf";
    "hypr/windows.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/hypr/windows.conf";

    # Wallpaper utility
    #"hypr/hyprpaper.conf".source = ./hypr/hyprpaper.conf;
  };

  # Set up environment variables required by Desktop
  home.sessionVariables = {
    TERMINAL = "alacritty"; # Specify the terminal emulator
    NIXOS_OZONE_WL = "1"; # Tell GTK apps to use the correct theme engine
    XDG_CURRENT_DESKTOP = "Hyprland";
    WLR_RENDERER = "vulkan";
  };

}
