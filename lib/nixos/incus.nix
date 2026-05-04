# ./lib/nixos/incus.nix
{
  username,
  ...
}:
{

  networking = {
    bridges."br0" = {
      interfaces = [ "enp2s0f0" ];
      rstp = false;
    };
    firewall.trustedInterfaces = [ "br0" ];
    interfaces = {
      br0.useDHCP = true;
      enp2s0f0.useDHCP = false;
    };
    nftables.enable = true;
  };

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
