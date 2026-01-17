# lib/home/desktop/walker.nix
{ config, inputs, lib, ... }:
{

  imports = [
    inputs.walker.homeManagerModules.default
  ];

  programs.walker = {
    enable = true;
    runAsService = true; # Recommended for faster startups
  };

  xdg.configFile = {
    "elephant/desktopapplications.toml".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/elephant/desktopapplications.toml";
    "walker/config.toml".source =
      lib.mkDefault (config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/walker/config.toml");
    "walker/themes/default/layout.xml".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/walker/themes/default/layout.xml";
    "walker/themes/default/style.css".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/walker/themes/default/style.css";
   };

}
