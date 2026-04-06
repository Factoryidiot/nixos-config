# ./lib/nixos/incus.nix
{
  username,
  ...
}:
{

  networking = { 
    firewall.trustedInterfaces = [ "incusbr0" ]; # Trust Incus bridge
    nftables.enable = true; # Recommended for Incus networking
  };

  users.users.${username}.extraGroups = [ "incus-admin" ]; # Add user to incus-admin group

  virtualisation.incus.enable = true;

}
