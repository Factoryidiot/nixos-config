# lib/home/desktop.nix
{ pkgs
, inputs
, ...
}:

  
{
  imports = [
    ./desktop/browser.nix
    ./desktop/cliphist.nix
    ./desktop/cursor.nix
    ./desktop/hyprland.nix
    ./desktop/mako.nix
    ./desktop/swayosd.nix
    ./desktop/terminal.nix
    ./desktop/walker.nix
    ./desktop/waybar.nix
  ];

  home.packages = with pkgs; [
    #+----- Audio & Media ------------------------
    imv # Powerful Wayland image viewer
    pamixer # Audio control
    playerctl # CMD-Line to control media players
    webp-pixbuf-loader # WebP image support

    #+----- System Utilities & TUIs --------------
    bluetui # TUI for bluetooth
    gum
    htop # TUI process viewer
    impala # TUI wifi
    ncdu 

    wiremix # TUI mixer for PipeWire

    #+----- Other desktop dependencies -----------
    brightnessctl # Brightness control
    libinput # Input device library
    libnotify
    swaybg # Basic wallpaper setter for fallback

    #+----- Security and Auth --------------------
    libsecret

    #+----- GUI Apps -----------------------------
    evince # PDF Viewer
    gnome-calculator
    localsend # AirDrop alternative
    impala # Spotify client

    #+----- Screenshots & Screen Recording -------
    grim # Wayland screenshot tool
    slurp # Wayland region selector for grim
    satty # Screenshot annotation tool
    hyprpicker # Wayland color picker
    wl-clipboard # Copy to Wayland clipboard
    #    gpu-screen-recorder			# Screen recording utility

    #+----- Virtualisation -----------------------
    quickemu

    #+----- XDG & Portals ------------------------
    xdg-terminal-exec
    xdg-utils
  ];

}
