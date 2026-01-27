# lib/home/desktop/swayosd.nix
{ config
, pkgs
, ... 
}: let
  swayosd-watchdog = pkgs.writeShellScriptBin "swayosd-watchdog" ''
    # Kill any existing instances first
    ${pkgs.procps}/bin/pkill swayosd-server || true
    
    echo "SwayOSD Watchdog started..."
    while true; do
      # We run the server directly. 
      # Optional: Added env var to stop vkBasalt from cluttering your logs.
      ENABLE_VKBASALT=0 ${pkgs.swayosd}/bin/swayosd-server
      
      echo "SwayOSD crashed with exit code $?. Restarting in 1 second..."
      sleep 1
    done
  '';
in
{

  services.swayosd.enable = false;

  home.packages = with pkgs; [
    swayosd
    swayosd-watchdog
  ];

  # Link the configuration files from the user's dotfiles directory.
  xdg.configFile = {
    "swayosd/config.toml".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/swayosd/config.toml";
    "swayosd/style.css".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/swayosd/style.css";
     "swayosd/theme.css".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/swayosd/theme.css";
 };

}
