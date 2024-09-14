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
     debug = {
      disable_logs = false;
      enable_stdout_logs = true;
    };
    enable = true;
    exec-once = [
      "hyprpaper"
      "mako"
    ];
   settings = {
      monitor = ",1920x1080,auto,1";
      "$mod" = "SUPER";
      bind = [
        "$mod, Return, exec, kitty"
        "$mod, Q, killactive"
      ];
    };
    # package = pkgs.hyprland;
  };


}
