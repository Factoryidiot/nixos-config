{
  config,
  lib,
  pkgs,
  ...
}: {
  boot = {
    kernelParams = [
      "video=DP-1:2560x1440@144"
      "video=DP-2:2560x1440@144"
    ];
  #  initrd.kernelModules = lib.mkAfter [
  #    "nvidia"
  #    "nvidia_modeset"
  #    "nvidia_uvm"
  #    "nvidia_drm"
  #  ];
  };
 
  hardware = {

    graphics = {
      enable = true;
      # driSupport32Bit = true;
      extraPackages = with pkgs; [ amdvlk ];
      extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
      enable32Bit = true; # needed by nvidia-docker
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

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption issues or application crashes after waking
      # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
      # of just the bare essentials.
      powerManagement.enable = true;
      powerManagement.finegrained = true;

      prime = {
        # Make sure to use the correct Bus ID values for your system!
        amdgpuBusId = "PCI:65:0:0";
        nvidiaBusId = "PCI:01:0:0";
 
        offload = {
          enable = true;
          enableOffloadCmd =  true; # command: nvidia-offload 
        };
        # reverseSync.enable = true;
      };

   };

  };

  # for Nvidia GPU
  services.xserver.videoDrivers = [ "amdgpu" "nvidia" ]; # will install nvidia-vaapi-driver by default

}
