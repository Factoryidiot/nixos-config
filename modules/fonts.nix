{
  pkgs
  , ...
}: {

  fonts = {
    enableDefaultPackages = false;
    fontDir.enable = true;

    packages = with pkgs; [
      bibata-cursors
      cascadia-code
      #fira-code
      #fira-code-symbols
      #font-awesome
      ia-writer-duospace
      ia-writer-quattro
      #liberation_ttf
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-se
      noto-fonts-emoji
      noto-fonts-extra
      #material-design-icons
      #(
      #  nerdfonts.override {
      #    fonts = [
      #      "NerdFontsSymbolsOnly"
      #      "JetBrainsMono"
      #    ];
      # }
      #)
      powerline-fonts
      powerline-symbols
    ];
    fontconfig.defaultFonts = {
      emoji = [ "Noto Color Emoji" ];
      monospace = [ "JetBrainsMono Nerd Font" "Noto Color Emoji" "Noto Sans Mono" ];
      sansSerif = [ "Noto Color Emoji"  "Noto Sans" ];
      serif = [ "Noto Color Emoji" "Noto Serif" ];
      # useEmbeddedBitmaps = true;
    };
  };

}
