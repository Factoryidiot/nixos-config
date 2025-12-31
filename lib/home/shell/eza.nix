# lib/home/eza.nix
{ ...
}: {
  # Enable eza and its Zsh integration for automatic aliases and completions
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true; # Add git status columns
    icons = "auto"; # Enable file-type icons
  };
}
