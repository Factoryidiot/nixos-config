{
  config
  , pkgs
  , ...
}: {
  programs.alacritty = {
    enable = true;
    # We do not define settings here because we source the TOML file below.
  };

  # Link the configuration file from your dotfiles directory
  xdg.configFile."alacritty/alacritty.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/alacritty/alacritty.toml";

  # Optional: Install Nerd Fonts if you haven't already (Alacritty often needs them for icons)
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
}
