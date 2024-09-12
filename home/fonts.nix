{
  pkgs,
  ...
}: {

  fonts = {
    enableDefaultPackages = false;
    fontDir.enable = true;

    packages = with pkgs; [
      material-design-icons
      font-awesome

      (
        nerdfonts.overide {
          fonts = [
            "nerdFontsSymbolsOnly"
            "JetBrainMono"
          ];
        };
      )
    ];
    fontconfig.defaultFonts = {
      monospace = [ "JetBrainMono Nerd Font" ];
    };
  };

}
