# lib/home/tmux.conf
{
  config
  , lib
  , ...
}: {

  programs.tmux = {
    enable = true;
  };

  # Link the configuration file from your dotfiles directory
  xdg.configFile = {
    "tmux/tmux.conf".source = lib.mkForce (config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/tmux/tmux.conf");
  };


}
