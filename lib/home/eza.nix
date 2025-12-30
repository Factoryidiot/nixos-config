# lib/home/eza.nix
{ ... }:
{
  # Enable eza and its Zsh integration for automatic aliases and completions
  programs.eza = {
    enable = true;
    git = true; # Add git status columns
    icons = true; # Enable file-type icons
    enableZshIntegration = true;
  };
}
