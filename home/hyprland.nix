{
  ags,
  anyrun,
  pkgs,
  ...
}:
{
  imports = [
    ags.homeManagerModules.ags
    anyrun.homeManagerModules.anyrun
  ];

  home.packages = with pkgs; [
    bitwarden
    chromium
    fuzzel
    hyprland
    obsidian
    #mako
    #rofi
    #waybar
    wayland
    xdg-desktop-portal-hyprland
  ];

  # https://github.com/Aylur/ags
  programs.ags = {
    # enable = true;
  };

  # https://github.com/kirottu/anyrun
  programs.anyrun = {
    # enable = true;
  };

  # https://codeberg.org/dnkl/fuzzel
  # https://mark.stosberg.com/fuzzel-a-great-dmenu-and-rofi-altenrative-for-wayland/
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font="JetBrainsMono:size=10";
        layer="overlay";
        prompt="❯   ";
        width=25;
      };
      border.radius=17;
      border.width=1;
      colors.background="1D1011FF";
      colors.match="FFB2BCFF";
      colors.selection="574144FF";
      colors.text="F7DCDEFF";
      dmenu.exit-immediately-if-empty=true;
    };
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
      env = [
        "NIXOS_OZONE_WL,1" # for any ozone-based browser & electron apps to run on wayland
        "MOZ_ENABLE_WAYLAND,1" # for firefox to run on wayland
        "MOZ_WEBRENDER,1"
        # misc
        "_JAVA_AWT_WM_NONREPARENTING,1"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "QT_QPA_PLATFORM,wayland"
        "SDL_VIDEODRIVER,wayland"
        "GDK_BACKEND,wayland"
      ];
      exec-once = [
        # "ags"
        # "hyprpaper"
      ];
      monitor = ",1920x1080,auto,1";
      bind = [
        "$mod, Return, exec, kitty"
        "$mod, Q, killactive"
        "$mod, W, exec, killall fuzzel || fuzzel"
      ];
    };
    xwayland.enable = true;
  };

}
