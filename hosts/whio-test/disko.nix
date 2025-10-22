# nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode disko ./disko.nix
{
  # This sets the BTRFS volume itself as the root of the volume to be mounted at /mnt.
  # The actual root of the OS is the @root subvolume mounted at /
  disko.devices = {
    disk = {
      vda = {
        type = "disk";
        device = "/dev/vda";
        content = {
          type = "gpt";
          partitions = {
            # 1. EFI System Partition (ESP)
            ESP = {
              start = "1MiB";
              end = "500MiB";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };

            # 2. LUKS Encrypted Partition (Uses the rest of the disk)
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                #passwordFile = "/tmp/secret.key";
                # NOTE: passwordFile is typically only used by 'disko --mode format'
                # to set the initial password, not for unlocking during boot.
                # It will be ignored after the initial install.
                settings = {
                  allowDiscards = true;
                  #fallbackToPassword = true;
                };
                # Setting this to true is required for TPM/Passphrase unlock in the initrd
                initrdUnlock = true;
                extraFormatArgs = [
                  "--type luks2"
                  "--cipher aes-xts-plain64"
                  "--hash sha512"
                  "--iter-time 5000"
                  "--key-size 256"
                  "--pbkdf argon2id"
                  # '--use-random' will block; remove it if installation hangs
                  # "--use-random"
                  "--verify-passphrase"
                ];
                # 'extraOpenArgs' is for opening the volume (e.g., in initrd)
                extraOpenArgs = [
                   "--allow-discards"
                ];

                content = {
                  type = "btrfs";
                  # -f to force formatting
                  extraArgs = [ "-f" ];
                  
                  # The main Btrfs volume is mounted at /mnt (disko default) 
                  # and contains all the subvolumes.
                  # We define the root (/) and /nix mountpoints here.
                  subvolumes = {
                    # The actual NixOS root partition
                    "@root" = {
                      mountOptions = [ "compress-force=zstd:1" "noatime" ];
                      mountpoint = "/";
                    };
                    # The Nix store
                    "@nix" = {
                      mountOptions = [ "compress-force=zstd:1" "noatime" ];
                      mountpoint = "/nix";
                    };
                    # The home directory
                    "@home" = {
                      mountOptions = [ "compress-force=zstd:1" "noatime" ];
                      mountpoint = "/home";
                    };
                    # The persistent data subvolume
                    "@persistent" = {
                      mountOptions = [ "compress-force=zstd:1" "noatime" ];
                      mountpoint = "/persistent";
                    };
                    # Other standard subvolumes
                    "@tmp" = {
                      mountOptions = [ "compress-force=zstd:1" "noatime" ];
                      mountpoint = "/tmp";
                    };
                    "@var_log" = {
                      mountOptions = [ "compress-force=zstd:1" "noatime" ];
                      mountpoint = "/var/log";
                    };
                    # Snapshots volume (unmounted, for use with tools like Btrfs-assist)
                    "@snapshots" = {
                      mountOptions = [ ];
                      mountpoint = null; # Unmounted
                    };
                    "@swap" = {
                      mountpoint = "/swap";
                      swap.swapfile.size = "8G";
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
