# lib/nixos/virtualisation.nix
{ pkgs, ... }:
{
  # Docker daemon is not needed for rootless docker
  virtualisation.docker.enable = false;

  # Enable rootless Docker
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
}
