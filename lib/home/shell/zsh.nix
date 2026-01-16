# lib/home/zsh.nix
{ config, lib, ... }:
{

  programs.zsh = {
    enable = true;

    autosuggestion.enable = true;

    dotDir = "${config.home.homeDirectory}/.config/zsh";

    history = {
      ignoreAllDups = true;
      path = "${config.programs.zsh.dotDir}/.zsh_history";
      size = 10000;
    };

    initContent = ''
      if [ "$TERM" = "linux" ]; then
        fastfetch
      fi
    '';

    syntaxHighlighting.enable = true;

  };

}
