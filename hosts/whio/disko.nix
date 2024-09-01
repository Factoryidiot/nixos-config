{

  filesystems."/persistent".neededForBoot = true;

  fileSystems."/dev/disk/by-uuid/4efd0169-587a-46d6-b3df-abe9199d8765" = {
    device = "/dev/disk/by-label/CRYPT";
    fsType = "ext4";
    options = [ "ro" ];
  };

  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = { 
              start = "1MiB";
              end = "128MiB";
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
                  # keyFile = "/dev/disk/by-label/CRYPT"; # The keyfile is stored on a USB stick
                  # The maximum size of the keyfile is 8192 KiB
                  # type `cryptsetup --help` to see the compiled-in key and passphrase maximum sizes
                  passwordFile = "/tmp/secret.key";
                  keyFileSize = 512 * 64; # match the `bs * count` of the `dd` command
                  keyFileOffset = 512 * 128; # match the `bs * skip` of the `dd` command
                  fallbackToPassword = true;
                  allowDiscards = true;
                };
                additionalKeyFiles = [];
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
                      mountOptions = [ "compress-force=zstd:1" "noatime" ];
                      mountpoint = "/";
                    };
                    "@nix" = {
                      mountOptions = [ "compress-force=zstd:1" "noatime" ];
                      mountpoint = "/nix";
                    };
                    "@tmp" = {
                      mountOptions = [ "compress-force=zstd:1" "noatime" ];
                      mountpoint = "/tmp";
                    };
                    "@persistent" = {
                      mountOptions = [ "compress-force=zstd:1" "noatime" ];
                      mountpoint = "/persistent";
                    };
                    "@snapshots" = {
                      mountOptions = [ "compress-force=zstd:1" "noatime" ];
                      mountpoint = "/snapshots";
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
