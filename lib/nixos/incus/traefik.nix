{ ... }:

{
  virtualisation.incus.instances.tahi-traefik = {
    image = "images:debian/12";
    profiles = [ "default" ];
    config = {
      "boot.autostart" = "true";
      "user.user-data" = ''
        #cloud-config
        packages:
          - curl
          - tar
        write_files:
          - path: /etc/traefik/traefik.yml
            content: |
              entryPoints:
                web: {address: ":80"}
                traefik: {address: ":8080"}
              api: {insecure: true, dashboard: true}
              providers:
                file: {directory: /etc/traefik/conf.d/, watch: true}
          - path: /etc/traefik/conf.d/traefik-dashboard.yml
            content: |
              http:
                routers:
                  dashboard:
                    rule: "Host(`traefik.lan`)"
                    middlewares: [dash-redirect]
                    service: noop
                middlewares:
                  dash-redirect:
                    regex: "^http://traefik.lan/?$"
                    replacement: "http://traefik.lan:8080/dashboard/"
                services:
                  noop: {loadBalancer: {servers: [{url: "http://127.0.0.1"}]}}
        runcmd:
          - [ sh, -c, "curl -L https://github.com/traefik/traefik/releases/download/v3.0.0/traefik_v3.0.0_linux_amd64.tar.gz | tar -xz -C /usr/local/bin traefik" ]
          - [ systemctl, restart, traefik ]
      '';
    };
  };
}
