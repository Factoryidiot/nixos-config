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
  # 1. Enable Hyprland program
  programs.hyprland = {
    enable = true;
    xwayland.enable = true; # Always a good idea for compatibility

    # Use the hyprland package provided by the flake input for version pinning
    package = hyprlandInput.packages.${system}.hyprland;

    # Set the session type, usually the same as your system (x86_64-linux)
    extraConfig = ''
      # Source the main configuration file managed by home-manager
      source = ~/.config/hypr/hyprland.conf
    '';
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
    "hypr/hyprland.conf" = {
      source = ./hypr/hyprland.conf;
      # You can also use text to inject dynamic Nix-managed values:
      # text = builtins.readFile ./hypr/hyprland.conf + ''
      #   $terminal = ${pkgs.alacritty}/bin/alacritty
      # '';
    };

    # Idleness management (dimming, locking)
    "hypr/hypridle.conf".source = ./hypr/hypridle.conf;

    # Screen locking application
    "hypr/hyprlock.conf".source = ./hypr/hyprlock.conf;

    # Wallpaper utility
    "hypr/hyprpaper.conf".source = ./hypr/hyprpaper.conf;
  };

  # 4. Install necessary packages for a working desktop environment
  home.packages = with pkgs; [
    # --- Omarchy-inspired Utilities and Enhancements ---
    wofi # Application launcher
    wl-clipboard # Wayland clipboard tools (wl-copy, wl-paste)
    swappy # Screenshot editor/annotator
    pavucontrol # Graphical volume mixer

    # --- Core Hyprland Dependencies ---
    polkit-kde-agent # Required for the system tray and other desktop features (used in exec-once)
    brightnessctl # For screen brightness
    pamixer # For volume control
    dunst # Notification daemon
    swaybg # Simple wallpaper utility (if not using hyprpaper)

    # --- Utilities ---
    slurp # Select a region of the screen (used for screenshots)
    grim # Screenshot tool
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
