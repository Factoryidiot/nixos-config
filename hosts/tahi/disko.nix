# ./hosts/tahi/disko.nix
{
  fileSystems."/persistent".neededForBoot = true;

  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/sda"; # IMPORTANT: Update this to the actual largest disk (e.g., /dev/sdb or /dev/sdd)
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              start = "1MiB";
              end = "500MiB";
              priority = 1;
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ]; # Force creation, useful for new install
                mountpoint = "/"; # Mount the main BTRFS filesystem as root
                subvolumes = {
                  "/guix" = {
                    mountOptions = [ "compress-force=zstd:1" "noatime" ];
                    mountpoint = "/gnu";
                  };
                  "/nix" = {
                    mountOptions = [ "compress-force=zstd:1" "noatime" ];
                    mountpoint = "/nix";
                  };
                  "/persistent" = {
                    mountOptions = [ "compress-force=zstd:1" ];
                    mountpoint = "/persistent";
                  };
                  "/snapshots" = {
                    mountOptions = [ "compress-force=zstd:1" ];
                    mountpoint = "/snapshots";
                  };
                  "/swap" = {
                    mountpoint = "/swap";
                    swap.swapfile.size = "24G";
                  };
                  "/tmp" = {
                    mountOptions = [ "compress-force=zstd:1" ];
                    mountpoint = "/tmp";
                  };
                };
              };
            };
          };
        };
      };
      # The 'key-backup' disk definition has been removed.
    };
  };
}