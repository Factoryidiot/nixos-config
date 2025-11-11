{
  config
  , pkgs
  ...
}: {

  packages = with pkgs; [
    waybar
  ];

  xdg.configFile."waybar/".source = ./config.jsonc;
  xdg.configFile."waybar/".source = ./style.css;

}
