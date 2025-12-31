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
