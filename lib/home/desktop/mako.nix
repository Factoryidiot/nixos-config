# lib/home/desktop/waybar.nix
{ config ,...}:

{

  services.mako = {
    enable = true;
  };

  xdg.configFile = {
    "mako/mako.ini".source =
	config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/mako/mako.ini";
  };

}
