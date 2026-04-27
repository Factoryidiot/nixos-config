# ./lib/nixos/nas.nix
{ config, pkgs, ... }:

{
  # 1. Enable ZFS Support
  boot.supportedFilesystems = [ "zfs" ];
  networking.hostId = "8425e349"; # Generate yours with: head -c4 /dev/urandom | od -A none -t x4

  # 2. Automated Maintenance
  services.zfs = {
    autoScrub.enable = true;      # Weekly health checks
    autoSnapshot = {
      enable = true;              # Automatic "Time Machine" style snapshots
      flags = "-k -p --utc";
      monthly = 1;
    };
  };

  # 3. Storage Pool & File Systems
  # Note: Create the pool once manually: 
  # sudo zpool create -f tank raidz1 /dev/disk/by-id/drive1 /dev/disk/by-id/drive2 ...
  fileSystems."/storage/data" = {
    device = "tank/data";
    fsType = "zfs";
  };

  # 4. Declarative Samba (Windows Shares)
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    extraConfig = ''
      workgroup = WORKGROUP
      server string = Tahi NAS
      netbios name = tahi
      security = user 
      # Disable printers
      load printers = no
      printing = bsd
      printcap name = /dev/null
      disable spoolss = yes
    '';
    shares = {
      data = {
        path = "/storage/data";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "rhys"; # Use your username here
      };
    };
  };

  # 5. Avahi for Network Discovery (mDNS)
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      userServices = true;
    };
  };
}
