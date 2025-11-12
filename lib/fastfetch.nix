{
  config
  , lib
  , pkgs
  , specialArgs
  , ...
}:
  let
  inherit (specialArgs) username;
in
 {

  home.packages = with pkgs; [
    fastfetch
  ];

  programs.fastfetch = {
    enable = true;
  };

  xdg.configFile."fastfetch/" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/${username}/.dotfiles/fastfetch/";
    recursive = true;
  };

}
