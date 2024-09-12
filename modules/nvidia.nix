{
  config,
  lib,
  pkgs,
  ...
}: {

  hardware = {

    graphics = {
      enable = true;
      # enable32Bit = true; # needed by nvidia-docker
    };

    nvidia = {
      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/os-specific/linux/nvidia-x11/default.nix
      # package = config.boot.kernelPackages.nvidiaPackages.stable;
      # required by most wayland compositors!
      modesetting.enable = true;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of 
      # supported GPUs is at: 
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
      # Only available from driver 515.43.04+
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      open = false;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption issues or application crashes after waking
      # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
      # of just the bare essentials.
      powerManagement.enable = false;
      prime = {
        reverseSync.enable = true;
        allowExternalGpu = false;

        # Make sure to use the correct Bus ID values for your system!
        nvidiaBusId = "PCI:01:0:0";
        amdgpuBusId = "PCI:101:0:0";
      };


      # Enable the Nvidia settings menu,
	    # accessible via `nvidia-settings`.
      nvidiaSettings = true;
    };

    # nvidia-container-toolkit.enable = true;

  };

  # for Nvidia GPU
  services.xserver.videoDrivers = [ "nvidia" ]; # will install nvidia-vaapi-driver by default



}