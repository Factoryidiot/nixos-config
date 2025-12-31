{
  pkgs
  , ...
}: {

  programs.fzf = {
    enable = true;
    enableZshIntegration = true; # Adds keybindings and completions
    defaultCommand = "fd --type f --hidden --exclude .git"; # Use fd, exclude hidden files and .git
  };

}
