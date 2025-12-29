# lib/home/development.nix
{ pkgs, ... }:
{
  programs.gemini-cli.enable = true;

  home.packages = with pkgs; [
    # Git
    github-cli
    lazygit

    # Docker
    docker-compose
    lazydocker

    # Language Runtimes & Tools
  ];
}
