# /lib/nixos/xdg.nix
{ pkgs, ... }: {
  # Enable the XDG portal service and configure backends
  xdg.portal = {
    enable = true;
    # We need to specify the backends.
    # xdg-desktop-portal-gtk is for GTK applications.
    # xdg-desktop-portal-hyprland is for Hyprland (wayland).
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];
    # This is to fix the warning with xdg-desktop-portal 1.17+
    config.common.default = "*";
  };
}
