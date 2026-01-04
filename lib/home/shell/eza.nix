# lib/home/eza.nix
{ ...
}: {

  programs.eza = {
    enable = true;
    enableZshIntegration = true; # Adds keybindings and completions
    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
    git = true; # Add git status columns
    icons = "auto"; # Enable file-type icons
  };

  #programs.zsh.shellAliases = {
  #  ls  = "eza --icons=auto --git";
  #  ll  = "eza -l --icons=auto --git";
  #  la  = "eza -a --icons=auto --git";
  #  lt  = "eza --tree --icons=auto --git";
  #};

}
