{ disks ? [ "/dev/vda" ], ... }:

{

  disko.devices = {
    disk = {
      vda = {
        type = "disk";
        device = builtins.elemAt disks 0;
        content = {
          type = "gpt";
          partitions = [
            {
              name = "ESP";
              start = "1MiB";
              end = "128MiB";
              priority = 1;
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            }
            {
              name = "ROOT";
              start = "128MiB";
              end = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                  };
                  "/nix" = {
                    mountOptions = [ "compress=zstd" "noatime" ];
                    mountpoint = "/nix";
                  };
                };
              };
            }
          ];
        };
      };
      vdb = {
        device = builtins.elemAt disks 1;
        type = "disk";
        content = {
          type = "table";
          format = "gpt";
          partitions = [
            {
              name = "HOME";
              start = "1MiB";
              end = "100%";
              content = {
                format = "btrfs";
                mountOptions = [ "compress=zstd" ];
                mountpoint = "/home";
              };
            }
          ];
        };
      };
    };
  };

}
