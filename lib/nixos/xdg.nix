# /lib/nixos/xdg.nix
{ pkgs
, ...
}: {

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk # Fallback for file picker, print dialogs, etc.
    ];
    config = {
      common.default = [ "gtk" ];
      hyprland.default = [ "hyprland" "gtk" ];
    };
  };

}
