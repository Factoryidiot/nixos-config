{ pkgs, lib, config, ... }:

let
  # Define a list of common redistributable libraries for Windows games
  # running under Wine/Proton. This helps avoid having to install them
  # manually with tools like winetricks or protontricks.
  proton-redist-pkgs = with pkgs; [
    # Visual C++ Runtimes
    vcredist2008
    vcredist2010
    vcredist2012
    vcredist2013
    vcredist2015
    vcredist2019
    vcredist2022

    # .NET Framework (and dependencies)
    dotnet-sdk

    # DirectX
    # dxvk is often preferred and included with Proton, but having d3dcompiler
    # can be useful for some games or tools.
    d3dcompiler_47

    # Other common runtimes
    corefonts
    libgdiplus
  ];
in
{
  options.gaming.enable = lib.mkEnableOption "Enable gaming configuration";

  config = lib.mkIf (config.gaming.enable) {
    home.packages = with pkgs; [
      # Core gaming utilities
      gamemode
      gamescope
      vkbasalt
      libstrangle # Framerate limiter

      # Tools for managing Wine/Proton environments
      protontricks
      winetricks

      # Communication for gaming
      discord

      # Game launchers
      lutris

      # Performance and hardware monitoring
      goverlay
    ] ++ proton-redist-pkgs;

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      package = pkgs.steam.override {
        extraPkgs = pkgs: with pkgs; [
          # Essential libraries for Steam client and games
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

          # Fonts for Steam and games
          source-sans
          source-serif
        ];
      };
    };

    # To use MangoHud or vkBasalt, you can set the following environment
    # variables before launching a game. For Steam, you can add them to the
    # game's launch options like so:
    #
    # MANGOHUD=1 %command%
    # or
    # ENABLE_VKBASALT=1 %command%
    # or both:
    # MANGOHUD=1 ENABLE_VKBASALT=1 %command%
    #
    # You can also use Goverlay to manage these settings graphically.
  };
}
