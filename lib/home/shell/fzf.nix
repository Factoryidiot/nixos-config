{ ...
}: {

  programs.fzf = {
    enable = true;
    enableZshIntegration = true; # Adds keybindings and completions
    defaultCommand = "fzf --preview 'bat --style=numbers --color-always --line-range :500 {}'";
  };

}
