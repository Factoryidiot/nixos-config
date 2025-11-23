{
  config
  , pkgs
  , ...
}: {

  programs.waybar = {
    enable = true;
    # Configuration is managed via the files linked below
  };

  xdg.configFile = {
    "waybar/config.jsonc".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/waybar/config.jsonc";
    "waybar/style.css".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/waybar/style.css";
  };

  home.packages = with pkgs; [
    # Waybar dependencies for common modules (ensure these are available for a functional bar)
    networkmanagerapplet # For the Network module
    pulseaudio # For volume module (assuming you use PulseAudio)
    upower # For the Battery module
    wlogout # For the power menu module
    playerctl # For media controls
  ];

}
