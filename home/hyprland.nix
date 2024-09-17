{
  ags,
  anyrun,
  # config,
  #lib,
  pkgs,
  ...
}:
{
  imports = [ ags.homeManagerModules.ags ];

  home.packages = with pkgs; [
    #ags
    chromium
    fuzzel
    hyprland
    mako
    #rofi
    #waybar
    wayland
    xdg-desktop-portal-hyprland

  ];

  # https://github.com/Aylur/ags
  programs.ags = {
    enable = true;
  };

  # https://github.com/kirottu/anyrun
  programs.anyrun = {
    enable = true;
  };

  # https://codeberg.org/dnkl/fuzzel
  # https://mark.stosberg.com/fuzzel-a-great-dmenu-and-rofi-altenrative-for-wayland/
  programs.fuzzel = {
    enable = true;
  };

  #programs.rofi = {
  #  enable = true;
  #};

  #programs.waybar = {
  #  enable = true;
  #  settings = {
  #    mainBar = {
  #      layer = "top";
  #      position = "top";
  #      height = 30;
  #      modules-left = [ "hyprland/workspaces" ];
  #      modules-center = [ "clock" ];
  #      modules-right = [];
  #      "clock" = {
  #        format = "{:%b %d %R}";
  #      };
  #    };
  #  };
  #  style = ''
  #    #clock {
  #      padding-left: 16px;
  #      padding-right: 16px;
  #      border-radius: 0px 0px 0px 0px;
  #      transition: none;
  #      color: #ffffff;
  #      background: #383c4a;
  #    }
  #  '';
  #};

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
    xwayland.enable = true;
  };

}
