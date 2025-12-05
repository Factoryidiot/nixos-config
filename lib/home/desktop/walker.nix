{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.walker.homeManagerModules.default
  ];

  programs.walker = {
    enable = true;
    config = {};
    runAsService = true; # Recommended for faster startups
  };

  # Link the configuration file from your dotfiles directory
  xdg.configFile."walker/config.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/walker/config.toml";
  xdg.configFile."elephant/config.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/elephant/desktopapplications.toml";
}
