{
  config
  , pkgs
  , ...
}: {

  programs.tmux = {
    enable = true;
  };

  xdg.configFile."tmux/config.jsonc".source = ./config.jsonc;

}
