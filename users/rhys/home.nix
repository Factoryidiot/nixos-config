{ pkgs, ... }:

{
  imports = [
    ../../home/default.nix
  ];

  programs.git = {
    userName = "Rhys";
    userEmail = "rhys.scandlyn@gmail.com";
  };
}
