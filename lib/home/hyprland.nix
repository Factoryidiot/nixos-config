{
  config
  , pkgs
  , inputs
  , ...
}:
let
  # Access the hyprland input via the inputs specialArg passed from flake.nix
  hyprlandInput = inputs.hyprland;
  system = pkgs.stdenv.hostPlatform.system;
in
{
  # 1. Enable Hyprland program using the correct Home Manager option
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true; # Always a good idea for compatibility

    # Use the hyprland package provided by the flake input for version pinning
    package = hyprlandInput.packages.${system}.hyprland;

    # Set the session type, usually the same as your system (x86_64-linux)
    #extraConfig = ''
    #  # Source the main configuration file managed by home-manager
    #  source = ~/.config/hypr/hyprland.conf
    #'';
  };

  # 2. Configure XDG desktop portal for better application compatibility
  xdg.portal = {
    enable = true;
    # Use the dedicated Hyprland portal implementation
    wlr.enable = false; # Disable the default wlroots portal if it's enabled globally
    extraPortals = with pkgs; [
      (hyprlandInput.packages.${system}.xdg-desktop-portal-hyprland)
    ];
  };

  # 3. Configure all required configuration files
  xdg.configFile = {
    # Main Hyprland configuration
    "hypr/autostart.conf".source = ./dotfiles/hypr/autostart.conf;
    "hypr/bindings.conf".source = ./dotfiles/hypr/bindings.conf;
    "hypr/env.conf".source = ./dotfiles/hypr/env.conf;
    "hypr/hypridle.conf".source = ./dotfiles/hypr/hypridle.conf;
    "hypr/hyprland.conf".source = ./dotfiles/hypr/hyprland.conf;
    "hypr/hyprlock.conf".source = ./dotfiles/hypr/hyprlock.conf;
    "hypr/hyprsunset.conf".source = ./dotfiles/hypr/hyprsunset.conf;
    "hypr/input.conf".source = ./dotfiles/hypr/input.conf;
    "hypr/monitors.conf".source = ./dotfiles/hypr/monitors.conf;
    


    # Wallpaper utility
    #"hypr/hyprpaper.conf".source = ./hypr/hyprpaper.conf;
  };

  # 4. Install necessary packages for a working desktop environment
  home.packages = with pkgs; [
  ];

  # Set up a few basic environment variables for Hyprland to function well
  home.sessionVariables = {
    # Specify the terminal to be used by Hyprland keybinds
    TERMINAL = "alacritty";
    # Tell applications to use Wayland natively where possible
    QT_QPA_PLATFORM = "wayland";
    GDK_BACKEND = "wayland,x11";
  };
}
