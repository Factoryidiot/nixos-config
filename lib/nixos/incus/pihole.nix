{
  pkgs,
  hostname,
  ...
}:
let
  containerName = "${hostname}-pihole";

  cloudConfig = pkgs.writeText "cloud-init.yml" ''
    #cloud-config
    packages:
      - curl
      - debconf-utils

    write_files:
      # 1. Pre-configure Pi-hole for non-interactive installation
      - path: /etc/pihole/setupVars.conf
        content: |
          PIHOLE_INTERFACE=eth0
          PIHOLE_DNS_1=1.1.1.2
          PIHOLE_DNS_2=9.9.9.9
          QUERY_LOGGING=true
          INSTALL_WEB_INTERFACE=true
          INSTALL_WEB_SERVER=true
          LIGHTTPD_ENABLED=true
          CACHE_SIZE=10000

    runcmd:
      - |
        cat <<EOF > /etc/systemd/network/10-cloud-init-eth0.network
        [Match]
        Name=eth0
        [Network]
        DHCP=ipv4
        [DHCPv4]
        ClientIdentifier=mac
        EOF
      - systemctl restart systemd-networkd

      - until ping -c 1 pi-hole.net; do sleep 2; done
      - curl -L https://install.pi-hole.net | bash /dev/stdin --unattended

      - systemctl stop dhcpcd || true
      - systemctl disable dhcpcd || true
  '';

in
{
  systemd.services."init-${containerName}" = {
    description = "Initialize ${containerName} (Manual DHCP Step Required)";
    after = [ "incus.service" ];
    requires = [ "incus.socket" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      # 1. Create the container if it doesn't exist
      if ! ${pkgs.incus}/bin/incus list --format csv -c n | grep -qx "${containerName}"; then
        ${pkgs.incus}/bin/incus init images:debian/12/cloud ${containerName} --profile default
      fi

      # 2. Apply the cloud-config
      ${pkgs.incus}/bin/incus config set ${containerName} user.user-data - < ${cloudConfig}
      
    '';
  };
}
