{
  config
  , nixpkgs
  , pkgs
  , ...
}: {

  environment.systemPackages = with pkgs; [
    waybar
  ];

  xdg.configFile."waybar/config.jsonc".source = ./config.jsonc;
  xdg.configFile."waybar/style.css".source = ./style.css;

}
