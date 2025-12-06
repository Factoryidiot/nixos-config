{
  config
  , inputs
  , lib
  , ...
}: {
  imports = [
    inputs.walker.homeManagerModules.default
  ];

  programs.walker = {
    enable = true;
    runAsService = true;  # Recommended for faster startups
  };

  # Link the configuration file from your dotfiles directory
  xdg.configFile =
  let
    symlink = file: config.lib.file.mkOutOfStoreSymlink file;
    dotfiles = "${config.home.homeDirectory}/.dotfiles";
  in
  lib.mkDefault {
    "walker/config.toml".source = symlink "${dotfiles}/walker/config.toml";
    "elephant/desktopapplications.toml".source = symlink "${dotfiles}/elephant/desktopapplications.toml";
  };
}
