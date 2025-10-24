{
  preservation
  , specialArgs
  , ...
}:
let
  # Destructure 'username' from the specialArgs passed from flake.nix
  inherit (specialArgs) username;
in
{

  imports = [
    preservation.nixosModules.default
  ];

  # NOTE: The Btrfs subvolumes /var/log and /var/lib are already
  # defined in disko.nix as separate mountpoints, which makes them persistent
  # relative to the / subvolume. We do not need to list them here.
  preservation = {
    enable = true;
    preserveAt."/persistent" = {
      # sets the mount option x-gvfs-hide on all the bind mounts
      directories = [
        "/etc/NetworkManager/system-connections"
        "/etc/ssh"
        "/etc/nix/inputs"
        "/etc/secureboot" # lanzaboote - secure boot
        "/etc/agenix/"    # my secrets

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

      files = [
        {
          file = "/etc/machine-id";
          inInitrd = true;
          how = "symlink";
          configurParent = true;
        }
      ];

    # the following directories will be passed to /persistent/home/$USER
      users.${username} = {
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
          #".config/Bitwarden"
          ".config/google-chrome"
          #".config/obsidian"
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
  };

  systemd.tmpfiles.settings.preservation =
    let
      permission = {
        user = username;
        group = "users";
        mode = "0755";
      };
    in
    {
      "/home/${username}/.config".d = permission;
      "/home/${username}/.cache".d = permission;
      "/home/${username}/.local".d = permission;
      "/home/${username}/.local/share".d = permission;
      "/home/${username}/.local/state".d = permission;
      "/home/${username}/.local/state/nix".d = permission;
    };

  # systemd-machine-id-commit.service would fail but it is not relevant
  # in this specific setup for a persistent machine-id so we disable it
  #
  # see the firstboot example below for an alternative approach
  systemd.suppressedSystemUnits = [ "systemd-machine-id-commit.service" ];

  # let the service commit the transient ID to the persistent volume
  systemd.services.systemd-machine-id-commit = {
    unitConfig.ConditionPathIsMountPoint = [
      ""
      "/persistent/etc/machine-id"
    ];
    serviceConfig.ExecStart = [
      ""
      "systemd-machine-id-setup --commit --root /persistent"
    ];
  };

}
