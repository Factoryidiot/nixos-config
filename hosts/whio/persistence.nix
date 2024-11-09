{
  impermanence
  , ...
}: {

  imports = [
    impermanence.nixosModules.impermanence
  ];

  # There are two ways to clear the root filesystem on every boot:
  ##  1. use tmpfs for /
  ##  2. (btrfs/zfs only)take a blank snapshot of the root filesystem and revert to it on every boot via:
  ##     boot.initrd.postDeviceCommands = ''
  ##       mkdir -p /run/mymount
  ##       mount -o subvol=/ /dev/disk/by-uuid/UUID /run/mymount
  ##       btrfs subvolume delete /run/mymount
  ##       btrfs subvolume snapshot / /run/mymount
  ##     '';
  #
  #  See also https://grahamc.com/blog/erase-your-darlings/

  # NOTE: impermanence only mounts the directory/file list below to /persistent
  # If the directory/file already exists in the root filesystem, you should
  # move those files/directories to /persistent first!
  environment.persistence."/persistent" = {
    # sets the mount option x-gvfs-hide on all the bind mounts
    # to hide them from the file manager
    hideMounts = true;
    directories = [
      "/etc/NetworkManager/system-connections"
      "/etc/ssh"
      "/etc/nix/inputs"
      "/etc/secureboot" # lanzaboote - secure boot
      # my secrets
      "/etc/agenix/"

      "/var/log"
      "/var/lib"

      # created by modules/nixos/misc/fhs-fonts.nix
      # for flatpak apps
      # "/usr/share/fonts"
      # "/usr/share/icons"
    ];
    files = [
      "/etc/machine-id"
    ];

    # the following directories will be passed to /persistent/home/$USER
    users.rhys = {
      directories = [
        "Documents"
        "Downloads"
        "Music"
        "Pictures"
        "Projects/Nixos/nixos-config"
        "tmp"
        "Videos"

        {
          directory = ".gnupg";
          mode = "0700";
        }
        {
          directory = ".ssh";
          mode = "0700";
        }

        # misc
        ".config/pulse"
        ".pki"
        ".steam" # steam games

        # cloud native
        #{
        #  # pulumi - infrastructure as code
        #  directory = ".pulumi";
        #  mode = "0700";
        #}
        {
          directory = ".aws";
          mode = "0700";
        }
        #{
        #  directory = ".docker";
        #  mode = "0700";
        #}

        # .config
        ".config/Bitwarden"
        ".config/google-chrome"
        ".config/obsidian"
        #".config/remmina"      # remote desktop
        #".config/freerdp"      # remote desktop


        # neovim / remmina / flatpak / ...
        ".local/share"
        ".local/state"

        ".mozilla"
        # language package managers
        ".npm"

        # neovim plugins(copilot)
        #".config/github-copilot"
      ];
      files = [
        ".zsh_history"
      ];
    };
  };
}
