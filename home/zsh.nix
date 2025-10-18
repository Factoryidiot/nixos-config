{
  lib
  , pkgs
  , ...
}: {

  home.file.".p10k.zsh" = {
    source = ./zsh/p10k.zsh;
    executable = true;
  };

  home.file.".p10k-portable.zsh" = {
    source = ./zsh/p10k-portable.zsh;
    executable = true;
  };

  programs.zsh = {
    enable = true;

    autosuggestion.enable = true;
    enableCompletion = true;
    history = {
      ignoreAllDups = true;
    };
    initContent = ''

        if [ "$TERM" = "linux" ]; then
          # Use 8 colors and ASCII.
          source ~/.p10k-portable.zsh
          fastfetch
          ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=black,bold'
        else
          source ~/.p10k.zsh
        fi

    '';
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" ];
    };
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
    syntaxHighlighting.enable = true;
  };

}
