# ./lib/nixos/nvidia.nix
{ config
, ...
}: {

  hardware = {

    graphics = {
      enable = true;
      enable32Bit = true;
    };

    nvidia = {
      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/os-specific/linux/nvidia-x11/default.nix
      # package = config.boot.kernelPackages.nvidiaPackages.stable;
      # required by most wayland compositors!
      modesetting.enable = true;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of 
      # supported GPUs is at: 
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
      # Only available from driver 515.43.04+
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      open = false;

      package = config.boot.kernelPackages.nvidiaPackages.stable;
      # package = config.boot.kernelPackages.nvidiaPackages.beta;
      # package = config.boot.kernelPackages.nvidiaPackages.production;

      # Nvidia power management.
      # finegrained is disabled to prevent D3cold PCIe resume latency/freezes on Wayland compositors.
      powerManagement = {
        enable = true;
        finegrained = false;
      };

      prime = {
        # Make sure to use the correct Bus ID values for your system!
        amdgpuBusId = "PCI:65:0:0";
        nvidiaBusId = "PCI:01:0:0";

        offload = {
          enable = true;
          enableOffloadCmd = true; # command: nvidia-offload 
        };
      };
    };
  };

  # for Nvidia GPU
  services.xserver.videoDrivers = [ "nvidia" ]; # will install nvidia-vaapi-driver by default

}
