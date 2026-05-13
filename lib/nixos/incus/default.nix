# ./lib/nixos/default.nix
{
  ...
}:
{

  imports = [
    ./core.nix
    ./pihole.nix
    ./step-ca.nix
    ./traefik.nix
    ./unbound.nix
  ];

}
