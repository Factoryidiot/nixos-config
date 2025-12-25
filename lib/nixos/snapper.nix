# lib/nixos/snapper.nix
{ specialArgs, ... }:
let
  inherit (specialArgs) username;
in
{
  services.snapper = {
    configs."home" = {
      SUBVOLUME = "/home";
      ALLOW_USERS = [ username ];
      TIMELINE_CREATE = true;
      TIMELINE_CLEANUP = true;
      TIMELINE_LIMIT_HOURLY = 12;
      TIMELINE_LIMIT_DAILY = 7;
      TIMELINE_LIMIT_MONTHLY = 3;
      TIMELINE_LIMIT_YEARLY = 0;
    };
  };
}
