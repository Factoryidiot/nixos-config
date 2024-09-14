{
  config,
  pkgs,
  ...
}: {

  home.packages = with pkgs; [
    chromium
    hyprland
    mako
    rofi
    waybar
    xdg-desktop-portal-hyprland

  ];

  programs.waybar = {
    enable = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    # package = pkgs.hyprland;
  };


}
