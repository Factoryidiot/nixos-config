{
  pkgs
  , ...
}: {

  programs = {
    gamemode.enable = true;
    steam = {
      enable = true;

      package = pkgs.steam.override {
        extraPkgs = pkgs:
          with pkgs; [
            keyutils
            libkrb5
            libpng
            libpulseaudio
            libvorbis
            stdenv.cc.cc.lib
            xorg.libXcursor
            xorg.libXi
            xorg.libXinerama
            xorg.libXScrnSaver

            source-sans
            source-serif
          ];
        };
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };

}
