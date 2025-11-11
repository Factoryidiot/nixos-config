{
  config
  , pkgs
  #, inputs
  , ...
}: {


  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;

    #package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    #portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  packages = with pkgs; [
    hyprland
  ];

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
      ];
    };
  };
  xdg.configFile."hypr/hypridle.conf".source = ./hypridle.conf;
  xdg.configFile."hypr/hyprlock.conf".source = ./hyprlock.conf;
  xdg.configFile."hypr/hyprpaper.conf".source = ./hyprpaper.conf;

}
