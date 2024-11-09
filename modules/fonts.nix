{
  pkgs
  , ...
}: {

  fonts = {
    enableDefaultPackages = false;
    fontDir.enable = true;

    packages = with pkgs; [
      bibata-cursors
      font-awesome
      liberation_ttf
      noto-fonts
      noto-fonts-emoji
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
      emoji = [ "Noto Color Emoji" ];
      monospace = [ "JetBrainsMono Nerd Font" "Noto Color Emoji" "Noto Sans Mono" ];
      sanSerif = [ "Noto Color Emoji"  "Noto Sans" ];
      serif = [ "Noto Color Emoji" "Noto Serif" ];
    };
  };

}
