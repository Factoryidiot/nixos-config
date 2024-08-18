{ pkgs, ... }:

{
  imports = [
    ../../home/default.nix
  ];

  programs.git = {
    userName = "Factoryidiot";
    userEmail = "rhys.scandlyn@gmail.com";
  };
}
