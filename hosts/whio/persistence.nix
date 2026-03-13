{ impermanence
, specialArgs
, ...
}:
let
  # Destructure 'username' from the specialArgs passed from flake.nix
  inherit (specialArgs) username;
in
{

  imports = [
    impermanence.nixosModules.default
  ];

  environment.persistence."/persistent" = {
    hideMounts = true;
    # sets the mount option x-gvfs-hide on all the bind mounts
    directories = [
      "/etc/asusd"
      "/etc/agenix/" # secrets
      #"/etc/NetworkManager/system-connections"
      "/etc/nix/inputs"

      "/var/lib/agenix"
      "/var/lib/bluetooth"
      "/var/lib/docker"
      "/var/lib/flatpak"
      "/var/lib/iwd"
      "/var/lib/nixos"
      "/var/lib/sbctl" # secure boot
      "/var/lib/systemd/timers/" # cron/timers
      "/var/log" # logs and troubleshooting
      # network
      #"/var/lib/tailscale"
    ];

    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];

    # the following directories will be passed to /persistent/home/$USER
    users.${username} = {
      directories = [
        ".dotfiles"

        "Documents"
        "Downloads"
        "Music"
        "Pictures"
        "Videos"
        "VMs"

        "Projects"
        "tmp"

        ".local/share/docker"

        {
          directory = ".gnupg";
          mode = "0700";
        }

        {
          directory = ".ssh";
          mode = "0700";
        }
        # Flatpak
        ".var/app"

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
        #".config/Bitwarden"
        #".config/google-chrome"
        #".config/chromium"
        ".config/BraveSoftware"
        #".config/obsidian"

        ".local/share/flatpak"
        ".local/state"

        ".mozilla"
        # language package managers
        ".npm"

      ];
      files = [
        ".config/zsh/.zsh_history"
      ];
    };
  };

}
