# ./modules/nixos/multimedia.nix
{ ...
}: {
  # Enable RealtimeKit for low-latency audio scheduling and XDG portal priority
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    jack.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
}
