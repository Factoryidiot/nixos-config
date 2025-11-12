{
  config
  , input
  , pkgs
  , specialArgs
  , ...
}:
  let
  inherit (specialArgs) username;
in
 {

  environment.systemPackages = with pkgs; [
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
