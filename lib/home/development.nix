# lib/home/development.nix
{ pkgs, ... }:
{
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
