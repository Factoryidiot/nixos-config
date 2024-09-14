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
    
      "clock" = {
        format = "{:%b %d}";
      }




    };
  };

  services = {
    # hypridle.enable = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      debug = {
        disable_logs = false;
        enable_stdout_logs = true;
      };
      exec-once = [
        "hyprpaper"
        "mako"
        "waybar"
      ];
      monitor = ",1920x1080,auto,1";
      bind = [
        "$mod, Return, exec, kitty"
        "$mod, Q, killactive"
      ];
    };
    xwayland = true;
  };

}
