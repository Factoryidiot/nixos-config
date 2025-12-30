# lib/nixos/secrets.nix
{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    inputs.agenix.nixosModules.default
  ];

  # Configure agenix
  age.identityPaths = [
    # The identity of the host, for decryption
    "/etc/ssh/ssh_host_ed25519_key"
  ];
}
