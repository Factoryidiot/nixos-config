# ./lib/nixos/gaming.nix
{ pkgs
, specialArgs ? { }
, ...
}:
let
  inherit (specialArgs) username;
in
{

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
  hardware.steam-hardware.enable = true;
  hardware.uinput.enable = true;

  programs.steam = {
    enable = true;
    dedicatedServer.openFirewall = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
    remotePlay.openFirewall = true;
  };

  programs.gamemode.enable = true;

  #+----- Impermanence Persistence -------------
  # Modular persistence: when this gaming module is included, persist Steam data and libraries.
  environment.persistence."/persistent" = {
    users.${username} = {
      directories = [
        ".steam"
        ".local/share/Steam"
      ];
    };
  };

  # You can also enable mangohud this way if desired, but user removed it.
  # environment.sessionVariables = {
  #   MANGOHUD = lib.mkIf config.gaming.enable "1";
  # };
}
