# lib/nixos/maintenance.nix
{ lib
, specialArgs
, ...
}:
let
  inherit (specialArgs) username;
in
{
  nix = {
    settings = {
      accept-flake-config = true;
      experimental-features = [ "nix-command" "flakes" ];
      # Add the user to the trusted list for better performance
      trusted-users = [ username "@wheel" ];
      substituters = [
        "https://cache.nixos.org"
      ];
    };

    # Garbage Collection
    gc = {
      automatic = lib.mkDefault true;
      dates = lib.mkDefault "weekly";
      options = lib.mkDefault "--delete-older-than 7d";
    };
  };
}
