# lib/home/desktop/waybar.nix
{
  config
  , lib
  , ...
}: {

  programs.waybar = {
    enable = true;
    systemd.enable = true;
  };

  xdg.configFile = {
    "waybar/config.jsonc".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/waybar/config.jsonc";
    "waybar/style.css".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/waybar/style.css";
  };

}
