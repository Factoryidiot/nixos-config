# lib/home/desktop.nix
{ pkgs
, ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  imports = [
    ./desktop/browser.nix
    ./desktop/cliphist.nix
    ./desktop/hyprland.nix
    ./desktop/mako.nix
    ./desktop/terminal.nix
    ./desktop/walker.nix
    ./desktop/waybar.nix
  ];

  # Install necessary packages for a working desktop environment
  home.packages = with pkgs; [
    #+---- Audio & Media -------------------------
    pamixer # Audio control
    playerctl # CMD-Line to control media players
    imv # Powerful Wayland image viewer
    webp-pixbuf-loader # WebP image support

    #+---- System Utilities & TUIs ---------------
    htop # TUI process viewer
    bluetui # TUI for bluetooth

    libnotify

    #+---- Other desktop dependencies ------------
    swaybg # Basic wallpaper setter for fallback
    brightnessctl # Brightness control

    #+---- Security and Auth ---------------------
    libsecret

    #+---- Shell & CLI Tools ---------------------
    bat # Cat clone with syntax highlighting and Git integration
    eza # Replacement for `ls`
    fastfetch # System information fetch tool
    fd # Simple, fast and user-friendly alternative to `find`
    fzf # Command line fuzzy finder
    jq # Needed for many Waybar scripts
    ripgrep # Search tool
    terminaltexteffects # Screensaver
    wget # Classic command-line file downloader


    #+---- GUI Apps ------------------------------
    evince # PDF Viewer
    gnome-calculator
    localsend # AirDrop alternative

    #+---- Screenshots & Screen Recording --------
    grim # Wayland screenshot tool
    slurp # Wayland region selector for grim
    satty # Screenshot annotation tool
    hyprpicker # Wayland color picker
    wl-clipboard # Copy to Wayland clipboard
    #    gpu-screen-recorder			# Screen recording utility

    #+---- XDG & Portals -------------------------
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-terminal-exec
  ];

}
