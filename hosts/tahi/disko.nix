# ./hosts/tahi/disko.nix
{

  fileSystems."/persistent".neededForBoot = true;

  disko.devices = {
    disk = {
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
                name = "crypted";
                settings = {
                  keyFile = "/boot/secret.key"; # Keyfile for automatic unlock
                  fallbackToPassword = false; # No password prompt on boot
                  allowDiscards = true;
                };
                initrdUnlock = true; # Ensure initrd handles the unlock
                # additionalKeyFiles = [];
                extraFormatArgs = [
                  "--type luks2"
                  "--cipher aes-xts-plain64"
                  "--hash sha512"
                  "--iter-time 5000"
                  "--key-size 256"
                  "--pbkdf argon2id"
                  "--use-random" # use true random data from /dev/random, will block until enough entropy is available
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
    };
  };

}
