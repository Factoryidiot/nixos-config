{ config, lib, pkgs, ... }:

let
  # Define a list of common redistributable libraries for Windows games
  # running under Wine/Proton. These are system-wide dependencies.
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
    d3dcompiler_47

    # Other common runtimes
    corefonts
    libgdiplus
  ];
in
{
  options.gaming.enable = lib.mkEnableOption "Enable system-wide gaming configuration";

  config = lib.mkIf config.gaming.enable {
    environment.systemPackages = with pkgs; [
      # Core gaming utilities
      steam
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

    # NixOS-level configuration for Steam
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      # Steam's own package is already included in systemPackages,
      # so no need to override it here with extraPkgs again,
      # as those are for the runtime environment of the Steam client itself.
      # The override was more relevant for home-manager's specific steam package.
    };

    # Enable Gamemode (NixOS service)
    services.gamemode.enable = true;

    # For vkBasalt, setting environment variables system-wide.
    # Note: It's generally better to set these per-game via launch options
    # or a tool like Goverlay, but for system-wide enabling:
    environment.sessionVariables = {
      ENABLE_VKBASALT = lib.mkIf config.gaming.enable "1"; # Enable vkBasalt if gaming is enabled
    };

    # You can also enable mangohud this way if desired, but user removed it.
    # environment.sessionVariables = {
    #   MANGOHUD = lib.mkIf config.gaming.enable "1";
    # };
  };
}
