# ./hosts/tahi/persistence.nix
{
  impermanence,
  specialArgs,
  ...
}:
let
  inherit (specialArgs) username;
in
{

  imports = [
    impermanence.nixosModules.default
  ];

  environment.persistence."/persistent" = {
    hideMounts = true;
    directories = [
      "/etc/agenix/" # secrets
      "/etc/nix/inputs"
      "/var/lib/agenix"
      "/var/lib/incus"
      "/var/lib/nixos"
      "/var/log" # logs and troubleshooting
    ];

    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];

    users.${username} = {
      directories = [
        "Projects"
        "VMs"
 
        # .config
        ".config/git"

        {
          directory = ".ssh";
          mode = "0700";
        }
      ];

      files = [
        # Any user specific files that need persistence can be added here
      ];
    };
  };

}
