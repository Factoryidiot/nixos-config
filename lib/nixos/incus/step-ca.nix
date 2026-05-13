# ./lib/nixos/incus/step-ca.nix
{
  pkgs,
  hostname,
  ...
}:
let
  containerName = "${hostname}-ca";
  
  # Manual configuration - choosing an IP for the CA
  ipAddr = {
    tahi = "172.16.1.204"; 
  };
  hostIP = ipAddr."${hostname}";

  macAddr = {
    tahi = "10:66:6a:c4:5f:6d";
  };
  hostMAC = macAddr."${hostname}";

  cloudConfig = pkgs.writeText "ca-cloud-init.yml" ''
    #cloud-config
    packages:
      - curl
      - wget
      - jq

    runcmd:
      # 1. Install Step-CLI and Step-CA
      - wget https://github.com/smallstep/cli/releases/download/v0.26.1/step-cli_0.26.1_amd64.deb
      - dpkg -i step-cli_0.26.1_amd64.deb
      - wget https://github.com/smallstep/certificates/releases/download/v0.26.0/step-ca_0.26.0_amd64.deb
      - dpkg -i step-ca_0.26.0_amd64.deb

      # 2. Initialize the CA (Non-interactive)
      - |
        export STEPPATH=/var/lib/step-ca
        mkdir -p $STEPPATH
        echo "your-strong-password" > $STEPPATH/password.txt
        step ca init --name "Tahi Internal CA" \
          --provisioner "admin@tahi.lan" \
          --dns "ca.lan" \
          --dns "${hostIP}" \
          --address ":443" \
          --password-file $STEPPATH/password.txt \
          --provisioner-password-file $STEPPATH/password.txt

      # 3. Enable the ACME provisioner (so Traefik can talk to it)
      - step ca provisioner add acme --type ACME --password-file /var/lib/step-ca/password.txt

      # 4. Create Systemd Service
      - |
        cat <<EOF > /etc/systemd/system/step-ca.service
        [Unit]
        Description=step-ca service
        After=network.target

        [Service]
        Environment=STEPPATH=/var/lib/step-ca
        ExecStart=/usr/bin/step-ca /var/lib/step-ca/config/ca.json --password-file=/var/lib/step-ca/password.txt
        Restart=always
        User=root

        [Install]
        WantedBy=multi-user.target
        EOF

      - systemctl daemon-reload
      - systemctl enable --now step-ca
  '';

in
{
  systemd.services."init-${containerName}" = {
    description = "Ensure ${containerName} (Step-CA) exists and is configured";
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
    '';
  };
}
