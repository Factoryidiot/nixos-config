# ./lib/nixos/gaming.nix
{
  pkgs,
  ...
}: {

  # For vkBasalt, setting environment variables system-wide.
  # Note: It's generally better to set these per-game via launch options
  # or a tool like Goverlay, but for system-wide enabling:
  environment.sessionVariables = {
    ENABLE_VKBASALT = "1"; # Enable vkBasalt if gaming is enabled
  };

  environment.systemPackages = with pkgs; [
    #+----- Core gaming utilities ----------------
    gamemode
    gamescope
    libstrangle # Framerate limiter
    opentrack
    steam
    vkbasalt

    # Tools for managing Wine/Proton environments
    #protontricks
    #winetricks

    # Game launchers
    #lutris

    # Performance and hardware monitoring
    #goverlay
  ];

  hardware.xpadneo.enable = true;
  
  programs.steam = {
    enable = true;
    dedicatedServer.openFirewall = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
    remotePlay.openFirewall = true;
  };

  programs.gamemode.enable = true;


  # You can also enable mangohud this way if desired, but user removed it.
  # environment.sessionVariables = {
  #   MANGOHUD = lib.mkIf config.gaming.enable "1";
  # };
}
