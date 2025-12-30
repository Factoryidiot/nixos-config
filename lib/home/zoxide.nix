# lib/home/zoxide.nix
{ ... }:
{
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true; # Automatically hooks zoxide into Zsh and creates 'z' alias
  };
}
