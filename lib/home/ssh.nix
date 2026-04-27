# lib/home/ssh.nix
{
  config,
  lib,
  ...
}: {

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "github.com" = {
        identityFile = "/etc/ssh/ssh_host_ed25519_key";
        identitiesOnly = true;
      };
    
      "*" = {
        # Add any global preferences here, or leave empty to stay lean
      };
    };
  };

}
