# ./modules/nixos/security-defaults.nix
{ ...
}: {

  # System-level Firewall
  networking.firewall.enable = true;
  networking.firewall.allowedTcpPorts = [ 53317 ];
  networking.firewall.allowedUdpPorts = [ 53317 ];

  # GnuPG agent configuration for SSH and browser integration
  programs.gnupg.agent = {
    enable = true;
    enableBrowserSocket = true;
    enableExtraSocket = true;
    enableSSHSupport = true;
  };

  # Allow members of 'wheel' to use sudo without a password
  security.sudo.wheelNeedsPassword = false;

  # System-level OpenSSH service settings
  services.openssh = {
    enable = true;
    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
      {
        path = "/etc/ssh/ssh_host_rsa_key";
        type = "rsa";
        bits = 4096;
      }
    ];
    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      X11Forwarding = true;
    };
    # Open the port in the system firewall
    openFirewall = true;
  };

}
