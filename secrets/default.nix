{
  agenix
  , config
  , pkgs
  , secrets
  , ...
}:
{
  imports = [
    agenix.nixosModules.default
  ];

  age.identityPaths = [
    "/persistent/etc/ssh/ssh_host_ed25519_key"
  ];

  age.secrets = {
    "ssh" = 
    {
    
    }
  };

}
