{
  ags,
  anyrun,
  config,
  pkgs,
  username,
  ...
}:
let 
  home = config.home.homeDirectory;
  hyprland_root = "${home}/.config/hypr";
in
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
  programs.hyprlock.enable = true;

  services = {
    hypridle.enable = true;
    hyprpaper.enable = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      bind = [
        ## Actions
        "$mod, W, exec, killall fuzzel || fuzzel" # application menu

        ## Applications
        "$mod, Return, exec, kitty"               # Terminal
        ## Windows
        "$mod, Q, killactive"
        "$mod, T, togglefloating" 
        "$mod, F, fullscreen"

        "$mod, H, movefocus, l"                   # Move focus left
        "$mod, J, movefocus, d"                   # Move focus down
        "$mod, K, movefocus, u"                   # Move focus up
        "$mod, L, movefocus, l"                   # Move focus right

        "$mod SHIFT, H, resizeactive, -100 0"     # Decrease window width
        "$mod SHIFT, J, resizeactive, 0 100"      # Increase window height
        "$mod SHIFT, K, resizeactive, 0 -100"     # Decrease window height
        "$mod SHIFT, L, resizeactive, 100 0"      # Increase window width
        ## Workspaces
        "$mod, 1, workspace, 1"                   # Open workspace 1
        "$mod, 2, workspace, 2"                   # Open workspace 2
        "$mod, 3, workspace, 3"                   # Open workspace 3
        "$mod, 4, workspace, 4"                   # Open workspace 4
        "$mod, 5, workspace, 5"                   # Open workspace 5

        "$mod SHIFT, 1, movetoworkspace, 1"       # Move active window to workspace 1
        "$mod SHIFT, 2, movetoworkspace, 2"       # Move active window to workspace 2
        "$mod SHIFT, 3, movetoworkspace, 3"       # Move active window to workspace 3
        "$mod SHIFT, 4, movetoworkspace, 4"       # Move active window to workspace 4
        "$mod SHIFT, 5, movetoworkspace, 5"       # Move active window to workspace 5

        "$mod, Tab, workspace, m+1"               # Open the next workspace
        "$mod SHIFT, Tab, workspace, m-1"         # Open the previous workspace
      ];
      bindl = [
        ## Laptop lid switch suspend
        ", switch:Lid Switch, exec, systemctl suspend"
      ];
      binds = {
        workspace_back_and_forth = true;
        allow_workspace_cycles = true;
        pass_mouse_when_bound = true;
      };
      cursor = {
        no_hardware_cursors = true;
      };
      debug = {
        disable_logs = false;
        enable_stdout_logs = true;
      };
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      env = [
        "HYPRLAND_ROOT, ${hyprland_root}"
        "AGS_CONFIG, ${hyprland_root}/ags/config.js"
        "NIXOS_OZONE_WL,1"                              # for any ozone-based browser & electron apps to run on wayland
        "MOZ_ENABLE_WAYLAND,1"                          # for firefox to run on wayland
        "MOZ_WEBRENDER,1"
        "WLR_DRM_DEVICES,/dev/dri/card1:/dev/dri/card0"  # Use GPU0 before GPU1
        ## Misc
        "_JAVA_AWT_WM_NONREPARENTING,1"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        ## Nvidia
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "GBM_BACKEND,nvidia-drm"
        "LIBVA_DRIVER_NAME,nvidia"
        ## Wayland
        "GDK_BACKEND,wayland"
        "QT_QPA_PLATFORM,wayland"
        "SDL_VIDEODRIVER,wayland"
        "XDG_SESSION_TYPE,wayland"
      ];
      exec-once = [
        # "ags"
        # "hyprpaper"
      ];
      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
        workspace_swipe_distance = 500;
        workspace_swipe_invert = true;
        workspace_swipe_min_speed_to_force = 30;
        workspace_swipe_cancel_ratio = 0.5;
        workspace_swipe_create_new = true;
        workspace_swipe_forever = true;
      };
      # monitor = ",1920x1080,auto,1";
      monitor = ",preferred,auto,1";
    };
    xwayland.enable = true;
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
      ];
    };
    configFile = {
      "hypr/hypridle.conf" = {
        source = ./hyprland/hypridle.conf;
      };
      "hypr/hyprlock.conf" = {
        source = ./hyprland/hyprlock.conf;
      };
      "hypr/hyprpaper.conf" = {
        source = ./hyprland/hyprpaper.conf;
      };
    };
  };
}
