# ./lib/nixos/gaming.nix
{ pkgs
, ...
}: {

  # For vkBasalt, set per-game via launch options (e.g. in Steam) or Goverlay/MangoHud.
  # Avoid setting ENABLE_VKBASALT globally as it injects into all Vulkan processes and compositors.
  # environment.sessionVariables = {
  #   ENABLE_VKBASALT = "1";
  # };

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
