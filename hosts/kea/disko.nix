{
  fileSystems."/persistent".neededForBoot = true;

  disko.devices = {
    disk = {
      # SSD - OS & High-Speed Apps/Games
      main = {
        type = "disk";
        device = "/dev/sda";
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
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted_ssd";
                settings.fallbackToPassword = true;
                settings.allowDiscards = true;
                extraFormatArgs = [
                  "--type luks2"
                  "--cipher aes-xts-plain64"
                  "--hash sha512"
                  "--iter-time 5000"
                  "--key-size 256"
                  "--pbkdf argon2id"
                  "--use-random"
                  "--verify-passphrase"
                ];
                extraOpenArgs = [ "--timeout 10" ];
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "/" = {
                      mountOptions = [ "subvolid=5" ];
                      mountpoint = "/btr_pool";
                    };
                    "@guix" = {
                      mountOptions = [ "compress-force=zstd:1" "noatime" ];
                      mountpoint = "/gnu";
                    };
                    "@nix" = {
                      mountOptions = [ "compress-force=zstd:1" "noatime" ];
                      mountpoint = "/nix";
                    };
                    "@persistent" = {
                      mountOptions = [ "compress-force=zstd:1" ];
                      mountpoint = "/persistent";
                    };
                    "@snapshots" = {
                      mountOptions = [ "compress-force=zstd:1" ];
                      mountpoint = "/snapshots";
                    };
                    "@tmp" = {
                      mountOptions = [ "compress-force=zstd:1" ];
                      mountpoint = "/tmp";
                    };
                  };
                };
              };
            };
          };
        };
      };

      # HDD - Cold Storage & Massive Game Library
      storage = {
        type = "disk";
        device = "/dev/sdb";
        content = {
          type = "gpt";
          partitions = {
            # Dedicated Swap Partition matching your current layout
            swap = {
              size = "20G";
              content = {
                type = "swap";
                discardPolicy = "both";
              };
            };
            # The remaining 900+ GB for bulk storage
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted_hdd";
                settings.fallbackToPassword = true;
                extraFormatArgs = [
                  "--type luks2"
                  "--cipher aes-xts-plain64"
                  "--hash sha512"
                  "--iter-time 5000"
                  "--key-size 256"
                  "--pbkdf argon2id"
                  "--use-random"
                  "--verify-passphrase"
                ];
                extraOpenArgs = [ "--timeout 10" ];
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "@storage" = {
                      mountOptions = [ "compress-force=zstd:3" "noatime" ]; # Higher compression for slow mechanical storage
                      mountpoint = "/storage";
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
