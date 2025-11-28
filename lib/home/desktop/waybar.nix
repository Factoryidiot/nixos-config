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

}
