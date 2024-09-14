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
    wayland
    xdg-desktop-portal-hyprland

  ];

  programs.rofi = {
    enable = true;
  };

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
      };
    };
  };

  services = {
    # hypridle.enable = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
    };
    # package = pkgs.hyprland;
  };


}
