{
  pkgs,
  ...
}: {

  programs.zsh = {
    enable = true;

    autosuggestion.enable = true;
    enableCompletion = true;
    history = {
      ignoreAllDups = true
    };
    syntaxHighlighting.enable = true;
  };

}
