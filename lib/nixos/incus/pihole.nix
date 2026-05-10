{
  pkgs,
  hostname,
  ...
}:
let
  containerName = "${hostname}-pihole";
  traefikContainer = "${hostname}-traefik";

  ipAddr = { #Mmanual configuration
    tahi = "172.16.1.202";
  };
  hostIP = ipAddr."${hostname}";

  macAddr = { #Manual configuration
    tahi = "10:66:6a:bb:eb:ec";
  };
  hostMAC = macAddr."${hostname}";

  cloudConfig = pkgs.writeText "cloud-init.yml" ''
    #cloud-config
    packages:
      - curl
      - debconf-utils

    write_files:
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
    description = "Initialize ${containerName} and link to Traefik";
    # Ensure this runs after Traefik's own init service
    after = [ "incus.service" "init-${traefikContainer}.service" ];
    requires = [ "incus.socket" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      until ${pkgs.incus}/bin/incus info >/dev/null 2>&1; do sleep 1; done

      if ! ${pkgs.incus}/bin/incus list --format csv -c n | grep -qx "${containerName}"; then
        ${pkgs.incus}/bin/incus init images:debian/12/cloud ${containerName} --profile default
      fi

      ${pkgs.incus}/bin/incus config set ${containerName} volatile.eth0.hwaddr ${hostMAC}

      ${pkgs.incus}/bin/incus config set ${containerName} user.user-data - < ${cloudConfig}
      ${pkgs.incus}/bin/incus start ${containerName} || true

      # 3. Wait for Traefik's config dir and inject rule
      # We use a simple check; if Traefik is 'after' us, it should be ready.
      ${pkgs.incus}/bin/incus exec ${traefikContainer} -- mkdir -p /etc/traefik/conf.d
      
      ${pkgs.incus}/bin/incus exec ${traefikContainer} -- sh -c "cat <<'EOF' > /etc/traefik/conf.d/pihole.yml
http:
  routers:
    pihole:
      rule: \"Host(\`pihole.lan\`)\"
      service: pihole-service
      entryPoints:
        - web
  services:
    pihole-service:
      loadBalancer:
        servers:
          - url: "http://${hostIP}/admin/"
EOF"
    '';
  };
}
