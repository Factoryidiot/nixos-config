# /lib/nixos/secureboot.nix
{ lanzaboote
, lib
, pkgs
, ...
}: {

  imports = [
    lanzaboote.nixosModules.lanzaboote
  ];

  environment.systemPackages = with pkgs; [
    sbctl
    tpm2-tss
  ];

  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  #+----- Impermanence Persistence -------------
  # Modular persistence: persist Secure Boot signing keys and PKI bundle
  environment.persistence."/persistent" = {
    directories = [
      "/var/lib/sbctl"
    ];
  };

}
