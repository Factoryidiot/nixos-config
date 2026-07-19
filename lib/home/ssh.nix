# lib/home/ssh.nix
{
  ...
}: {

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "github.com" = {
        #identityFile = "/etc/ssh/ssh_host_ed25519_key";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
      };
    
      "*" = {
        # Add any global preferences here, or leave empty to stay lean
      };
    };
  };

}
