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

  # Link the configuration file from your dotfiles directory
  xdg.configFile = {
    "walker/config.toml".source = 
	lib.mkForce (config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/walker/config.toml");
    "elephant/desktopapplications.toml".source = 
	config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/elephant/desktopapplications.toml";
  };

}
