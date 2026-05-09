{
  pkgs,
  hostname,
  ...
}:
let
  containerName = "${hostname}-traefik";

  cloudConfig = pkgs.writeText "cloud-init.yml" ''
    #cloud-config
    packages:
      - curl
      - xz-utils

    write_files:
      - path: /etc/traefik/traefik.yml
        content: |
          entryPoints:
            web: {address: ":80"}
          api: {insecure: true, dashboard: true}
          providers:
            file: {directory: /etc/traefik/conf.d/, watch: true}

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
  systemd.services.init-traefik-container = {
    description = "Ensure ${containerName} container exists and is configured";
    after = [ "incus.service" "incus.socket" ];
    requires = [ "incus.socket" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      # Wait for Incus
      until ${pkgs.incus}/bin/incus info >/dev/null 2>&1; do sleep 1; done

      # 1. 'init' creates the container but keeps it STOPPED
      if ! ${pkgs.incus}/bin/incus list --format csv -c n | grep -qx "${containerName}"; then
        ${pkgs.incus}/bin/incus init images:debian/12/cloud ${containerName} --profile default
      fi

      # 2. Update config
      ${pkgs.incus}/bin/incus config set ${containerName} user.user-data - < ${cloudConfig}
    '';
  };
}
