# ./lib/nixos/default.nix
{
  ...
}:
{

  imports = [
    ./core.nix
    ./pihole.nix
    ./traefik.nix
  ];

}
