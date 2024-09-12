{
  pkgs,
  lib,
  ...
}: {

  hardware.graphics = {
    enable = true;
    # enable32Bit = true; # needed by nvidia-docker
  };

  hardware = { 
    nvidia = {
      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/os-specific/linux/nvidia-x11/default.nix
      # package = config.boot.kernelPackages.nvidiaPackages.stable;
      # required by most wayland compositors!
      modesetting.enable = true;
      powerManagement.enable = true;
    };
    nvidia-container-toolkit.enable = true;
  };

  # for Nvidia GPU
  services.xserver.videoDrivers = [ "nvidia" ]; # will install nvidia-vaapi-driver by default



}
