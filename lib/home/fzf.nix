{ pkgs, ... }:

{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true; # Adds keybindings and completions
    changeDirWidget = true; # Enables **fcd** (fzf change directory)
    defaultCommand = "fd --type f --hidden --exclude .git"; # Use fd, exclude hidden files and .git
    extraOptions = [
      "--ansi" # Enable ANSI color codes
      "--layout=reverse" # Show fzf window at the top
      "--info=inline" # Show info line above the prompt
      "--height=40%" # Set height of the fzf window
    ];
  };

  home.packages = with pkgs; [
    fd # fzf needs fd for the defaultCommand
  ];
}
