# lib/nixos/virtualisation.nix
{ pkgs, specialArgs, ... }:
let
  inherit (specialArgs) username;
in
{
  # Enable Docker
  virtualisation.docker = {
    enable = true;
    package = pkgs.docker;
  };

  # Add user to the docker group so they can use it without sudo
  users.extraGroups.docker.members = [ username ];
}
