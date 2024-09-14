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
