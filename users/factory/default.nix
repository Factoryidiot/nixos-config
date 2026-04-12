
{ 
  isServer,
  ... 
}:

{
  imports = [
    ./core.nix # Common configurations

    # Conditionally import desktop or server configurations
    (if isServer then ./server.nix else ./desktop.nix)
  ];
}
