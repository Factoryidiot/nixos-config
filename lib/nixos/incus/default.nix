# ./lib/nixos/default.nix
{
  ...
}:
{

  imports = [
    ./core.nix
    ./traefik.nix
  ];

}
