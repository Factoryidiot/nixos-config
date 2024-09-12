{
  pkgs,
  ...
}: {

  fonts = {
    enableDefaultPackages = false;
    fontDir.enable = true;

    packages = with pkgs; [
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
      powerline-sysmbols
    ];
    fontconfig.defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font" ];
    };
  };

}
