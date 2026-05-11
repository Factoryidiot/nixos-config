# ./lib/nixos/nas.nix
{
  config,
  pkgs,
  ...
}: {
  # 1. Enable ZFS Support
  boot.supportedFilesystems = [ "zfs" ];
  networking.hostId = "8425e349"; # Generate yours with: head -c4 /dev/urandom | od -A none -t x4

  # 2. Essential NAS Management Tools
  environment.systemPackages = with pkgs; [
    gptfdisk  # Provides sgdisk
    smartmontools # Check disk health/SMART data
    pciutils  # For lspci troubleshooting
    nfs-utils # If you ever want to mount NFS
    zfs-autobackup # Great for future off-site replication
  ];

  # 3. Storage Pool & File Systems
  # Note: Create the pool once manually: 
  # sudo zpool create -f tank raidz1 /dev/disk/by-id/drive1 /dev/disk/by-id/drive2 ...
  fileSystems."/storage/data" = {
    device = "tank/data";
    fsType = "zfs";
    options = [ "nofail" ]; # Prevent boot hang if pool is missing
  };

  # 4. Avahi for Network Discovery (mDNS)
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      userServices = true;
    };
  };

  # 5. Declarative Samba (Windows Shares)
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
      socket options = TCP_NODELAY IPTOS_LOWDELAY
      min protocol = SMB2
    '';
    shares = {
      data = {
        path = "/storage/data";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "factory"; # Use your username here
      };
    };
  };

  # 6. Automated Maintenance
  services.zfs = {
    autoScrub.enable = true;      # Weekly health checks
    autoSnapshot = {
      enable = true;              # Automatic "Time Machine" style snapshots
      flags = "-k -p --utc";
      monthly = 1;
    };
  };

}
