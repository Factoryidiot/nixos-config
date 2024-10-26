{
  lanzaboote
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

  boot = {
    bootspec.enable = true;

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    loader.systemd-boot.enable = lib.mkForce false;
  };

}
