# ./modules/nixos/security-defaults.nix
{ ...
}: {

  # System-level Firewall
  networking.firewall.enable = true;

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
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
    # Open the port in the system firewall
    openFirewall = true;
  };

}
