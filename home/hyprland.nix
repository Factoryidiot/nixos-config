{
  config
  , pkgs
  , username
  , ...
}:
let 
  home = config.home.homeDirectory;
  hyprland_root = "${home}/.config/hypr";
in
{
  imports = [
  ];

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
        "$mod, W, exec, killall fuzzel || fuzzel"
                                              # application menu

        ## Applications
        "$mod, Return, exec, kitty"           # Terminal

        ## Layouts


        ## Windows
        "$mod, Q, killactive"
        "$mod, T, togglefloating" 
        "$mod, F, fullscreen"

        "$mod, H, movefocus, l"               # Move focus left
        "$mod, J, movefocus, d"               # Move focus down
        "$mod, K, movefocus, u"               # Move focus up
        "$mod, L, movefocus, l"               # Move focus right

        "$mod CTRL, H, movewindow, l"         # Move focus left
        "$mod CTRL, J, movewindow, d"         # Move focus down
        "$mod CTRL, K, movewindow, u"         # Move focus up
        "$mod CTRL, L, movewindow, l"         # Move focus right

        "$mod SHIFT, H, resizeactive, -100 0" # Decrease window width
        "$mod SHIFT, J, resizeactive, 0 100"  # Increase window height
        "$mod SHIFT, K, resizeactive, 0 -100" # Decrease window height
        "$mod SHIFT, L, resizeactive, 100 0"  # Increase window width

        ## Workspaces
        "$mod, 1, workspace, 1"               # Open workspace 1
        "$mod, 2, workspace, 2"               # Open workspace 2
        "$mod, 3, workspace, 3"               # Open workspace 3
        "$mod, 4, workspace, 4"               # Open workspace 4
        "$mod, 5, workspace, 5"               # Open workspace 5

        "$mod SHIFT, 1, movetoworkspace, 1"   # Move active window to workspace 1
        "$mod SHIFT, 2, movetoworkspace, 2"   # Move active window to workspace 2
        "$mod SHIFT, 3, movetoworkspace, 3"   # Move active window to workspace 3
        "$mod SHIFT, 4, movetoworkspace, 4"   # Move active window to workspace 4
        "$mod SHIFT, 5, movetoworkspace, 5"   # Move active window to workspace 5

        "$mod, Tab, workspace, m+1"           # Open the next workspace
        "$mod SHIFT, Tab, workspace, m-1"     # Open the previous workspace

        # Function keys

        ## Monitor brightness
        ", XF86MonBrightnessDown, exec, brightnessctl -q s 10%-"
                                              # Reduce brightness by 10%
        ", XF86MonBrightnessUp, exec, brightnessctl -q s 10%+"
                                              # Increase brightness by 10%

        ## Keyboard brightness
        ", XF86KbdBrightnessDown, exec, brightnessctl -d smc::kbd_backlight s 10-"
                                              # Decrease brightness by 10%
        ", XF86KbdBrightnessUp, exec, brightnessctl -d smc::kbd_backlight s 10+"
                                              # Increase brightness by 10%

        ## Audio (speaker)
        ", XF86AudioLowerVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-"  
                                              # Unmute and reduce volume by 5%
        ", XF86AudioRaiseVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+"  
                                              # Unmute and increase volume by 5% 
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
                                              # Toggle mute

        ## Audio (microphone)
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
                                              # Toggle microphone

        ## Player controls 
        # ", XF86AudioPlay, exec, playerctl play-pause"                             # Audio play pause
        # ", XF86AudioPause, exec, playerctl pause"                                 # Audio pause
        # ", XF86AudioNext, exec, playerctl next"                                   # Audio next 
        # ", XF86AudioPrev, exec, playerctl previous"                               # Audio previous

        ## Misc
        ", XF86Calculator, exec, gnome-calculator"
                                              # Calculator
        #", code:62, exec, hyprshot -m region"
                                              # Snipping tool
        ", print, exec, hyprshot -m active"   # Screenshot: active window
        "CTRL, print, exec, hyprshot -m output"
                                              # Screenshot: entire window
        ", XF86Lock, exec, hyprlock"          # Lock screen
        ", XF86Sleep, exec, systemctl suspend"# Sleep / suspend device
        # ", XF86Rfkill, exec,  "             # todo: Flight mode
        # ", XF86TouchpadToggle, exec, "      # todo: Touchpad lock

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
        ## Aquamarine
        "AQ_DRM_DEVICES,/dev/dri/card1"       # use only AMDGPU

        "HYPRLAND_ROOT, ${hyprland_root}"
        "AGS_CONFIG, ${hyprland_root}/ags/config.js"
        "NIXOS_OZONE_WL,1"                    # for any ozone-based browser & electron apps to run on wayland
        ## Mozilla
        "MOZ_ENABLE_WAYLAND,1"                # for firefox to run on wayland
        "MOZ_WEBRENDER,1"
        ## cursor
        "HYPRCURSOR_THEME,Bibata-Modern-Ice"
        "HYPRCURSOR_SIZE,24"
        ## Misc
        "_JAVA_AWT_WM_NONREPARENTING,1"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        ## Nvidia
        #"__GLX_VENDOR_LIBRARY_NAME,nvidia"
        #"GBM_BACKEND,nvidia-drm"
        #"LIBVA_DRIVER_NAME,nvidia"
        ## Wayland
        "GDK_BACKEND,wayland"
        "QT_QPA_PLATFORM,wayland"
        "SDL_VIDEODRIVER,wayland"
        "XDG_SESSION_TYPE,wayland"
      ];
      exec-once = [
        "hyprctl setcursor Bibata-Modern-Ice 24"
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
      master = {
        new_status = "master";  # master / slave
        new_on_top = false;
        mfact = 0.5;
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
