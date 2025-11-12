{
  config
  , pkgs
  , specialArgs
  , ...
}:
  let
  inherit (specialArgs) username;
in
 {

  programs.fastfetch = {
    enable = true;
  };

  xdg.configFile."fastfetch/" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/${username}/.dotfiles/fastfetch/";
    recursive = true;
  };

}
