{
  impermanence
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
      "/etc/NetworkManager/system-connections"
      "/etc/ssh"
      "/etc/nix/inputs"
      "/etc/secureboot" # lanzaboote - secure boot
      "/etc/agenix/"    # secrets

      "/var/lib/nixos"
      "/var/lib/flatpak"

      # network
      #"/var/lib/tailscale"
      "/var/lib/bluetooth"
      "/var/lib/NetworkManager"
      "/var/lib/iwd"
    ];

    files = [
      "/etc/machine-id"
    ];

    # the following directories will be passed to /persistent/home/$USER
    users.${username} = {
      directories = [
        "Documents"
        "Downloads"
        "Music"
        "Pictures"
        "Videos"

        ".dotfiles"

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
        ".config/chromium"
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
