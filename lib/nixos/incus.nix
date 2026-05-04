# ./lib/nixos/incus.nix
{
  username,
  ...
}:
{

  users.users.${username}.extraGroups = [ "incus-admin" ]; # Add user to incus-admin group

  virtualisation.incus = {
    enable = true;

    preseed = {
      profiles = [
        {
          name = "default";
          devices = {
            eth0 = {
              name = "eth0";
              nictype = "bridged";
              parent = "br0";
              type = "nic";
            };
            root = {
              path = "/";
              pool = "default";
              size = "35GiB";
              type = "disk";
            };
          };
        }
      ];
      storage_pools = [
        {
          name = "default";
          driver = "dir";
          config = {
            source = "/var/lib/incus/storage-pools/default";
          };
        }
      ];
    };

  };

}
