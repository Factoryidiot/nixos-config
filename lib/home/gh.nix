# lib/home/gh.nix
{ config, pkgs, lib, ... }: {

  # Ensure gh is installed
  home.packages = with pkgs; [
    gh
  ];

  # Configure git to use gh's credential helper
  programs.git = {
    enable = true;
    extraConfig = {
      "credential.helper" = "gh";
    };
    userName = "Rhys Scandlyn";
    userEmail = "rhys.scandlyn@gmail.com";
  };

}
