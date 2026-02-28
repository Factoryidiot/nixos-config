# lib/nixos/virtualisation.nix
{ pkgs
, username
,  ...
}:
{

  environment.systemPackages = with pkgs; [
    docker-buildx
    nvidia-container-toolkit
  ];

  hardware.nvidia-container-toolkit.enable = true;

  users.users.${username}.extraGroups = [ "docker" ];

  virtualisation.docker = {
    enable = true;

    autoPrune.enable = true;
    daemon.settings = {
      dns = [ "8.8.8.8" "8.8.4.4" ];
      features = {
        cdi = true;
      };
      registry-mirrors = [ "https://mirror.gcr.io" ];
    };
    storageDriver = "btrfs";
  };

}
