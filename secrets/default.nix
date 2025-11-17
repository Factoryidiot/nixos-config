# secrets/default.nix
{ 
  inputs
  , ...
}: {

  imports = [
    inputs.agenix.nixosModules.default
    ./secrets.nix # This file will list all your secrets
  ];

  # Tell agenix to use the host's existing SSH key for decryption
  # This key is already persisted in /persistent/etc/ssh
  age.identityPaths = [
    "/etc/ssh/ssh_host_ed25519_key"
    "/etc/ssh/ssh_host_rsa_key"
  ];

}
