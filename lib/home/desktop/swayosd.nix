# lib/home/desktop/swayosd.nix
{ config, ... }:
{

  services.swayosd.enable = true;

  # Link the configuration files from the user's dotfiles directory.
  xdg.configFile = {
    "swayosd/config.toml".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/swayosd/config.toml";
    "swayosd/style.css".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/swayosd/style.css";
  };

}
