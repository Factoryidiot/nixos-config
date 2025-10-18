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

  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot = {

    lanzaboote = {
      enable = true;
      pkiBundle = "/mnt/var/lib/sbctl";
    };

  };

}
