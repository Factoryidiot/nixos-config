# lib/home/zsh.nix
{ config
, lib
, ...
}: {

  programs.zsh = {
    enable = true;

    history = {
      ignoreAllDups = true;
      path = "${config.programs.zsh.dotDir}/.zsh_history";
      size = 10000;
    };

    # Zsh Initialisation Content
    initContent = let
      zshEarly = lib.mkOrder 500 ''
        if [ "$TERM" = "linux" ]; then
          fastfetch
        fi
      '';
    in
     zshEarly;

  };

  #xdg.configFile = {
  #  "zsh/.p10k.zsh".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/zsh/.p10k.zsh";
  #};

}
