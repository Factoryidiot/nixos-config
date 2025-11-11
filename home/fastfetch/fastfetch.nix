{
  config
  , pkgs
  ...
}: {

  programs.fastfetch = {
    enable = true;
  };

  xdg.configFile."waybar/".source = ./config.jsonc;

}
