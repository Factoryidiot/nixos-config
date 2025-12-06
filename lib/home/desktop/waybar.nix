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

  xdg.configFile 
  let
    symlink = file: config.lib.file.mkOutOfStoreSymlink file;
    dotfiles = "${config.home.homeDirectory}/.dotfiles";
  in
  lib.mkDefault {
    "waybar/config.jsonc".source = symlink "${dotfiles}/waybar/config.jsonc";
    "waybar/style.css".source = symlink "${dotfiles}/waybar/style.css";
  };

}
