{
  lib,
  pkgs,
  ...
}: {

  home.file.".p10k.zsh" = {
    source = ./.p10k.zsh;
    executable = true;
  };

  programs.zsh = {
    enable = true;

    autosuggestion.enable = true;
    enableCompletion = true;
    history = {
      ignoreAllDups = true;
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" ];
    };
    syntaxHighlighting.enable = true;

    zplug = {
      enable = true;
      plugins = [{
        name = "romkatv/powerlevel10k";
        tags = [ "as:theme" "depth:1" ];
      }];
    };

    #plugins = [
    #  {
    #    name = "powerlevel10k";
    #    src = pkgs.zsh-powerlevel10k;
    #    file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    #  }
    #  {
    #    name = "powerlevel10k-config";
    #    src = ./zsh;
    #    file = "p10k.zsh";
    #  }
    #];
  };

}
