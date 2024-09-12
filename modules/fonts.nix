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
        nerdfonts.override {
          fonts = [
            "NerdFontsSymbolsOnly"
            "JetBrainMono"
          ];
       }
      )
    ];
    fontconfig.defaultFonts = {
      monospace = [ "JetBrainMono Nerd Font" ];
    };
  };

}
