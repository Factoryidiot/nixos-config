# /lib/nixos/xdg.nix
{ pkgs
, ...
}: {

  xdg.portal = {
    enable = true;
    config.common.default = "*"; # This is to fix the warning with xdg-desktop-portal 1.17+

    configPackages = with pkgs; [
      xdg-desktop-portal-gtk # xdg-desktop-portal-gtk is for GTK applications.
      xdg-desktop-portal-hyprland # xdg-desktop-portal-hyprland is for Hyprland (wayland).
    ];
  };

}
