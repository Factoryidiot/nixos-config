{
  pkgs,
  ...
}: {

  fonts = {
    enableDefaultPackages = false;
    fontDir.enable = true;

    packages = with pkgs; [
      bibata-cursors
      font-awesome
      material-design-icons
      (
        nerdfonts.override {
          fonts = [
            "NerdFontsSymbolsOnly"
            "JetBrainsMono"
          ];
       }
      )
      powerline-fonts
      powerline-symbols
    ];
    fontconfig.defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font" ];
    };
  };

}
