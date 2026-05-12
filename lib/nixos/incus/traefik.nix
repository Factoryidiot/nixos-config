# ./lib/nixos/incus/traefik.nix
{
  pkgs,
  hostname,
  ...
}:
let
  containerName = "${hostname}-traefik";

  ipAddr = { #Mmanual configuration
    tahi = "172.16.1.201";
  };
  hostIP = ipAddr."${hostname}";

  macAddr = { #Manual configuration
    tahi = "10:66:6a:c4:5f:6b";
  };
  hostMAC = macAddr."${hostname}";

  cloudConfig = pkgs.writeText "cloud-init.yml" ''
    #cloud-config
    packages:
      - curl
      - xz-utils

    write_files:
      - path: /etc/traefik/traefik.yml
        content: |
          api:
            insecure: true
            dashboard: true
          providers:
            file:
              directory: /etc/traefik/conf.d/
              watch: true

     - path: /etc/systemd/system/traefik.service
        content: |
          [Unit]
          Description=Traefik Proxy
          After=network.target
          [Service]
          ExecStart=/usr/local/bin/traefik --configfile=/etc/traefik/traefik.yml
          Restart=always
          [Install]
          WantedBy=multi-user.target

    runcmd:
      - mkdir -p /etc/traefik/conf.d/
      - [ sh, -c, "curl -L https://github.com/traefik/traefik/releases/download/v3.0.0/traefik_v3.0.0_linux_amd64.tar.gz | tar -xz -C /usr/local/bin" ]
      - chmod 755 /usr/local/bin/traefik
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
      - systemctl daemon-reload
      - systemctl enable --now traefik
  '';

in
{

  systemd.services."init-${containerName}" = {
    description = "Ensure ${containerName} container exists and is configured";
    after = [ "incus.service" "incus.socket" ];
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

      ${pkgs.incus}/bin/incus exec ${containerName} -- sh -c "cat <<'EOF' > /etc/traefik/traefik.yml
entryPoints:
  web:
    address: \":80\"
    http:
      redirections:
        entryPoint:
          to: websecure
          scheme: https
  websecure:
    address: \":443\"
api:
  dashboard: true
providers:
  file:
    directory: /etc/traefik/conf.d/
    watch: true
EOF"

      ${pkgs.incus}/bin/incus exec ${containerName} -- mkdir -p /etc/traefik/conf.d/

      # Use the same <<'EOF' pattern for the Traefik Dashboard itself
      ${pkgs.incus}/bin/incus exec ${containerName} -- sh -c "cat <<'EOF' > /etc/traefik/conf.d/traefik-dashboard.yml
http:
  routers:
    dashboard:
      rule: \"Host(\`traefik.lan\`)\"
      service: api@internal
      entryPoints:
        - websecure
      tls: {}
EOF"

      ${pkgs.incus}/bin/incus exec ${containerName} -- sh -c "cat <<'EOF' > /etc/traefik/conf.d/incus.yml
tcp:
  routers:
    incus:
      rule: \"HostSNI(\`incus.lan\`)\"
      service: incus-service
      entryPoints:
        - websecure
      tls:
        passthrough: true

  services:
    incus-service:
      loadBalancer:
        servers:
          - address: \"172.16.1.200:8443\"
EOF"

      ${pkgs.incus}/bin/incus exec ${containerName} -- systemctl restart traefik
    '';
  };
}
