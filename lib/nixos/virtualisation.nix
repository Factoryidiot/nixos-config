# lib/nixos/virtualisation.nix
{ config
, lib
, pkgs
,  ...
}:
{

  environment.systemPackages = with pkgs; [
    docker-buildx
    nvidia-container-toolkit
  ];

  hardware.nvidia-container-toolkit.enable = true;

  virtualisation.docker = {
    enable = true;

    autoPrune.enable = true;
    daemon.settings = {
      #default-runtime = "nvidia";
      dns = [ "8.8.8.8" "8.8.4.4" ];
      features = {
        cdi = true;
      };
      registry-mirrors = [ "https://mirror.gcr.io" ];
      #runtimes = {
      #  nvidia = {
      #    path = "${pkgs.nvidia-container-toolkit}/bin/nvidia-container-toolkit";
      #  };
      #};
    };
    storageDriver = "overlay2";
  };

}
