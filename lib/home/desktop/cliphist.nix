# lib/home/desktop/cliphist.nix
{ config
, lib
, pkgs
, ...
}:
{
  services.cliphist = {
    enable = true;
  };

  home.packages = with pkgs; [
    cliphist
  ];

  # Optional: Add keybindings for cliphist in Hyprland
  wayland.windowManager.hyprland.settings = {
    "$mod, V" = "exec, cliphist list | walker | cliphist decode | wl-copy";
  };
}
