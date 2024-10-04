{

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
    antidote = {
      enable = true;
      plugins = [''
        romkatv/powerlevel10k kind:fpath
      ''];
    };
  };

}
