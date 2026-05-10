{
  pkgs,
  hostname,
  ...
}:
let
  containerName = "${hostname}-unbound";

  ipAddr = {
    tahi = "172.16.1.203";
  };
  hostIP = ipAddr."${hostname}";

  macAddr = {
    tahi = "10:66:6a:dd:cc:bb";
  };
  hostMAC = macAddr."${hostname}";

  cloudConfig = pkgs.writeText "cloud-init.yml" ''
    #cloud-config
    packages:
      - unbound
      - curl
      - dnsutils

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
  '';

in
{
  systemd.services."init-${containerName}" = {
    description = "Initialize ${containerName} recursive DNS";
    after = [ "incus.service" "incus.socket" ];
    requires = [ "incus.socket" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

script = ''
      # 1. Wait for Incus to be ready
      until ${pkgs.incus}/bin/incus info >/dev/null 2>&1; do sleep 1; done

      # 2. Initialize and Start container
      if ! ${pkgs.incus}/bin/incus list --format csv -c n | grep -qx "${containerName}"; then
        ${pkgs.incus}/bin/incus init images:debian/12/cloud ${containerName} --profile default
      fi

      ${pkgs.incus}/bin/incus config set ${containerName} volatile.eth0.hwaddr ${hostMAC}
      ${pkgs.incus}/bin/incus config set ${containerName} user.user-data - < ${cloudConfig}
      ${pkgs.incus}/bin/incus start ${containerName} || true

      # 3. Provisioning & Environment Setup
      # Ensure directories exist; /run/unbound is volatile and needs recreation after container restarts
      ${pkgs.incus}/bin/incus exec ${containerName} -- mkdir -p /etc/unbound /var/lib/unbound /run/unbound
      
      # Ensure the 'unbound' system user exists
      ${pkgs.incus}/bin/incus exec ${containerName} -- sh -c "id -u unbound >/dev/null 2>&1 || useradd -r -s /usr/sbin/nologin unbound"

      # 4. Bootstrap Root Hints & DNSSEC Anchor
      ${pkgs.incus}/bin/incus exec ${containerName} -- sh -c "
        if [ ! -s /var/lib/unbound/root.hints ]; then
          curl -s -k -o /var/lib/unbound/root.hints https://www.internic.net/domain/named.cache
        fi
      "
      # Initialize the root key (crucial for the 'ad' flag)
      ${pkgs.incus}/bin/incus exec ${containerName} -- unbound-anchor -a /var/lib/unbound/root.key || true

      # 5. Inject Recursive Configuration
      ${pkgs.incus}/bin/incus exec ${containerName} -- sh -c "cat <<'EOF' > /etc/unbound/unbound.conf
server:
    interface: 0.0.0.0
    port: 53
    do-ip4: yes
    do-udp: yes
    do-tcp: yes
    do-ip6: no

    # Access Control
    access-control: 172.16.1.0/24 allow
    access-control: 127.0.0.0/8 allow

    # Operational Paths
    directory: \"/etc/unbound\"
    username: \"unbound\"
    pidfile: \"/run/unbound/unbound.pid\"
    chroot: \"\"
    root-hints: \"/var/lib/unbound/root.hints\"
    
    # DNSSEC: Use ONLY auto-trust-anchor-file to prevent 'presented twice' errors
    auto-trust-anchor-file: \"/var/lib/unbound/root.key\"
    module-config: \"validator iterator\"

    # Privacy and Security
    hide-identity: yes
    hide-version: yes
    harden-glue: yes
    harden-dnssec-stripped: yes
    use-caps-for-id: yes
    qname-minimisation: yes

    # Performance
    prefetch: yes
    num-threads: 1
EOF"

      # 6. Final Cleanup & Permissions
      # Wipe Debian's default conf snippets to prevent logic overrides
      ${pkgs.incus}/bin/incus exec ${containerName} -- rm -rf /etc/unbound/unbound.conf.d/*
      ${pkgs.incus}/bin/incus exec ${containerName} -- chown -R unbound:unbound /etc/unbound /var/lib/unbound /run/unbound
      ${pkgs.incus}/bin/incus exec ${containerName} -- systemctl disable --now systemd-resolved || true

      # 7. Service Kickstart
      ${pkgs.incus}/bin/incus exec ${containerName} -- systemctl restart unbound
    '';

  };
}
