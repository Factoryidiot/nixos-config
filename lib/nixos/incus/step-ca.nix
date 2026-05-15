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

    write_files:
      - path: /etc/network/interfaces.d/eth0
        permissions: '0644'
        content: |
          auto eth0
          iface eth0 inet static
              address 172.16.1.204/24
              gateway 172.16.1.1
              dns-nameservers 172.16.1.202 172.16.1.203

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
        # The 'CA_PASSWORD' string here is just a placeholder for sed
        echo "CA_PASSWORD" > $STEPPATH/password.txt
        chmod 600 $STEPPATH/password.txt
        
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
      # 1. Create a persistent password on the HOST if it doesn't exist
      # This stays on Tahi, not in your Nix config.
      PW_FILE="/var/lib/incus/secrets/${containerName}-pass.txt"
      mkdir -p /var/lib/incus/secrets
      if [ ! -f "$PW_FILE" ]; then
        ${pkgs.openssl}/bin/openssl rand -base64 32 > "$PW_FILE"
        chmod 600 "$PW_FILE"
      fi
      CA_PASS=$(cat "$PW_FILE")

      # 2. Swap the placeholder in the cloud-config before sending to Incus
      # This way the Nix Store version only has the word "CA_PASSWORD"
      TEMP_CONFIG=$(mktemp)
      sed "s/CA_PASSWORD/$CA_PASS/g" ${cloudConfig} > $TEMP_CONFIG

      # 3. Standard Incus Init
      if ! ${pkgs.incus}/bin/incus list --format csv -c n | grep -qx "${containerName}"; then
        ${pkgs.incus}/bin/incus init images:debian/12/cloud ${containerName} --profile default

        # We keep the MAC address hard-pinned, but strip the unmanaged IP flag
        ${pkgs.incus}/bin/incus config device add ${containerName} eth0 nic \
          nictype=bridged \
          parent=br0 \
          hwaddr=${hostMAC}
      fi

      ${pkgs.incus}/bin/incus config set ${containerName} user.user-data - < $TEMP_CONFIG
      ${pkgs.incus}/bin/incus start ${containerName} || true

      rm $TEMP_CONFIG
    '';

  };
}
