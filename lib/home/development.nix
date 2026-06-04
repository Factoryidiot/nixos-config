# lib/home/development.nix
{
  pkgs,
  ...
}: {

  home.packages = with pkgs; [

    #+----- Docker -------------------------------
    docker-compose
    lazydocker

    #+----- Git ----------------------------------
    github-cli
    lazygit

    #+----- Language Runtimes & Tools ------------
    devenv
  ];

}
