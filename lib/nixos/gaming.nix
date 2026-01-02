{ config
, lib
, pkgs
, ...
}: {

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
    #discord

    # Game launchers
    #lutris

    # Performance and hardware monitoring
    #goverlay
  ];

  # NixOS-level configuration for Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Enable Gamemode (NixOS service)
  programs.gamemode.enable = true;

  # For vkBasalt, setting environment variables system-wide.
  # Note: It's generally better to set these per-game via launch options
  # or a tool like Goverlay, but for system-wide enabling:
  environment.sessionVariables = {
    ENABLE_VKBASALT = "1"; # Enable vkBasalt if gaming is enabled
  };

  # You can also enable mangohud this way if desired, but user removed it.
  # environment.sessionVariables = {
  #   MANGOHUD = lib.mkIf config.gaming.enable "1";
  # };
}
