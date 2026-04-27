# ./lib/nixos/incus.nix
{
  username,
  ...
}:
{

  networking = {
    bridges."br0".interfaces = [ "enp3s0" ];
    firewall.trustedInterfaces = [ "br0" ];
    interfaces.br0.useDHCP = true;
    #firewall.trustedInterfaces = [ "incusbr0" ]; # Trust Incus bridge
    nftables.enable = true; # Recommended for Incus networking

  };

  users.users.${username}.extraGroups = [ "incus-admin" ]; # Add user to incus-admin group

  virtualisation.incus = {
    enable = true;

    preseed = {
      networks = [
        {
          name = "incusbr0";
          type = "bridge";
          config = {
            # Setting the bridge IP to .201
            "ipv4.address" = "172.16.1.201/24"; 
            "ipv4.nat" = "true";
            # Restricting the DHCP range to your 50 set-aside IPs
            "ipv4.dhcp.ranges" = "172.16.1.202-172.16.1.250";
            "ipv6.address" = "none"; # Keeping it simple for now
          };
        }
      ];
      profiles = [
        {
          name = "default";
          devices = {
            eth0 = {
              name = "eth0";
              nictype = "bridged";
              parent = "br0";
              #network = "incusbr0";
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
