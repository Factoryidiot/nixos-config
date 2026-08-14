# ./hosts/kea/disko.nix
{

  fileSystems."/persistent".neededForBoot = true;
  fileSystems."/storage".neededForBoot = true;

  disko.devices = {
    disk = {
      # SSD (NVMe / SATA SSD) - OS, Root, Nix Store, Persistent System & Configs
      main = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted_ssd";
                settings = {
                  fallbackToPassword = true;
                  allowDiscards = true;
                };
                initrdUnlock = false;
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
                extraOpenArgs = [
                  "--timeout 10"
                ];
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
                    "@swap" = {
                      mountpoint = "/swap";
                      swap.swapfile.size = "24G";
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

      # HDD / Secondary Disk - General Storage, Steam Games, Large Media & VMs
      storage = {
        type = "disk";
        device = "/dev/sdb";
        content = {
          type = "gpt";
          partitions = {
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted_storage";
                settings = {
                  fallbackToPassword = true;
                  allowDiscards = true;
                };
                initrdUnlock = false;
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
                extraOpenArgs = [
                  "--timeout 10"
                ];
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "/" = {
                      mountOptions = [ "subvolid=5" ];
                      mountpoint = "/storage_pool";
                    };
                    "@storage" = {
                      mountOptions = [ "compress-force=zstd:3" "noatime" ];
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
