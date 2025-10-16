{
  impermanence
  , ...
}: {

  imports = [
    impermanence.nixosModules.impermanence
  ];

  # NOTE: The Btrfs subvolumes /var/log and /var/lib are already
  # defined in disko.nix as separate mountpoints, which makes them persistent
  # relative to the / subvolume. We do not need to list them here.
  environment.persistence."/persistent" = {
    # sets the mount option x-gvfs-hide on all the bind mounts
    hideMounts = true;
    directories = [
      "/etc/NetworkManager/system-connections"
      "/etc/ssh"
      "/etc/nix/inputs"
      "/etc/secureboot" # lanzaboote - secure boot
      "/etc/agenix/"    # my secrets

      # Removed /var/log and /var/lib as they should be defined as
      # separate Btrfs subvolumes in disko.nix for persistence.
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
        ".steam"

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
