{
  config
  , ...
}: {

  programs.fastfetch.enable = true;

  xdg.configFile = {
    "fastfetch/config.jsonc".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/fastfetch/config.jsonc";
  };

}
