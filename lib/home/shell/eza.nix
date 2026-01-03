# lib/home/eza.nix
{ ...
}: {

  programs.eza = {
    enable = true;
    git = true; # Add git status columns
    icons = "auto"; # Enable file-type icons
  };

  programs.zsh.shellAliases = {
    ls  = "eza --icons=auto --git";
    ll  = "eza -l --icons=auto --git";
    la  = "eza -a --icons=auto --git";
    lt  = "eza --tree --icons=auto --git";
  };

}
