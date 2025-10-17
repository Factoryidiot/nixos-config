{
  preservation
  , ...
}: {

  imports = [
    preservation.nixosModules.default
  ];

  preservation.enable = true;

  boot.initrd.systemd.enable = true;


  # NOTE: The Btrfs subvolumes /var/log and /var/lib are already
  # defined in disko.nix as separate mountpoints, which makes them persistent
  # relative to the / subvolume. We do not need to list them here.
  preservation.preserveAt."/persistent" = {
    # sets the mount option x-gvfs-hide on all the bind mounts
    directories = [
      "/etc/NetworkManager/system-connections"
      "/etc/ssh"
      "/etc/nix/inputs"
      "/etc/secureboot" # lanzaboote - secure boot
      "/etc/agenix/"    # my secrets

      "/var/log"

      "/var/lib/nixos"
      "/var/lib/systemd"
      {
        directory = "/var/lib/private";
        mode = "0700";
      }

      "/var/flatpak"

      # network
      #"/var/lib/tailscale"
      "/var/lib/bluetooth"
      "/var/lib/NetworkManager"
      "/var/lib/iwd"
    ];

    file = [
      files = "/etc/machine-id"
      initrd = true;
    ];

    # the following directories will be passed to /persistent/home/$USER
    users.rhys = {
      directories = [
        "Documents"
        "Downloads"
        "Music"
        "Pictures"
        "Videos"

        # Work
        "Projects/Nixos/nixos-config"
        "tmp"

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

        # Games
        ".steam"
        ".local/share/Steam"

        # cloud native
        {
          directory = ".aws";
          mode = "0700";
        }

        # .config
        ".config/Bitwarden"
        ".config/google-chrome"
        ".config/obsidian"
        #".config/remmina"
        #".config/freerdp"

        # neovim / remmina / flatpak / ...
        ".local/share/flatpak"
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
