{ pkgs, ... }:

{
  imports = [
    ../../home/core.nix

    ../../home/fastfetch.nix
    ../../home/git.nix

  ];

  programs.git = {
    userName = "Factoryidiot";
    userEmail = "rhys.scandlyn@gmail.com";
  };
}
