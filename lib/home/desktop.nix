# lib/home/desktop.nix
{ pkgs
  # , terminaltexteffects
, inputs
, nixpkgs-unstable
, ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  unstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };

  tte-latest = pkgs.python3Packages.buildPythonApplication {
    pname = "terminaltexteffects";
    version = "0.14.0";
    format = "pyproject";

    src = inputs.terminaltexteffects;

    # Dependencies required to build/run
    nativeBuildInputs = with pkgs.python3Packages; [
      hatchling
    ];

    # If it has runtime dependencies, add them here. 
    # v0.14.2 is mostly self-contained but requires standard python libs.
    propagatedBuildInputs = with pkgs.python3Packages; [
      # Add any specific python deps if the build fails, 
      # but usually poetry-core handles the internal structure.
      pydantic
    ];

    doCheck = false;
  };

in
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
    tte-latest
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

    #+----- XDG & Portals ------------------------
    quickemu

    #+----- XDG & Portals ------------------------
    xdg-terminal-exec
    xdg-utils
  ];

}
