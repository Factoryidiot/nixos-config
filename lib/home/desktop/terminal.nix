{
  config
  , pkgs
  , ...
}: {
  programs.alacritty = {
    enable = true;
  };

  xdg.configFile = {
    "alacritty/alacritty.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/alacritty/alacritty.toml";
  };

  home.packages = with pkgs; [
    eza

    nerd-fonts.jetbrains-mono
  ];
}
