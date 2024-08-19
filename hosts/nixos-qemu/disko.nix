# { disks ? [ "/dev/vda" "/dev/vdb" ], ... }:
{ devices, ... }:

{

  disko.devices = {
    disk = {
      vda = {
        device = builtins.elemAt devices 0;
        type = "disk";
        content = {
          type = "table";
          format = "gpt";
          partitions = [
            {
              name = "ESP";
              start = "1MiB";
              end = "500MiB";
              bootable = "true";
              content = {
                format = "vfat";
                bootable = true;
                mountpoint = "/boot";
              };
            }
            {
              name = "ROOT";
              start = "500MiB";
              end = "100%";
              content = {
                format = "btrfs";
                mountpoint = "/";
              };
            }
          ];
        };
      };
      vdb = {
        device = builtins.elemAt devices 1;
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
                mountpoint = "/home";
              };
            }
          ];
        };
      };
    };
  };

}
