# lib/nixos/btrfs.nix
{ ... }:

{

  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
  };

  services.fstrim.enable = true;

}
