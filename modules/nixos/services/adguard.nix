{
  config,
  lib,
  pkgs,
  homelab,
  ...
}:

let
  # AdGuard Home uses port 53 for DNS by default
  dnsPort = 53;
  exporterPort = 9617;
  url = homelab.url "adguard";
in
{
  options.my.services.adguard.enable = lib.mkEnableOption "adguard";

  config = lib.mkIf config.my.services.adguard.enable {
    services.adguardhome = {
      enable = true;
      mutableSettings = true;
      openFirewall = true;
      host = "0.0.0.0";
      settings = {
        upstream_dns = [
          "https://dns.quad9.net/dns-query"
          "https://dns.google/dns-query"
          "https://dns.cloudflare.com/dns-query"
        ]; # Set reliable upstream DNS servers
      };
    };

    networking.firewall = {
      allowedUDPPorts = [ dnsPort ];
      allowedTCPPorts = [ dnsPort ];
    };

    # For troubleshooting DNS
    environment.systemPackages = with pkgs; [
      # Collection of common network programs (e.g. ftp, ping, traceroute, hostname, ifconfig)
      inetutils
      # DNS tools (e.g. nslookup, dig)
      dnsutils
    ];

    services.adguard-exporter = lib.mkIf config.my.services.metrics.enable {
      enable = true;
      extraFlags = [
        "-log_limit"
        "10000"
      ];
    };

    services.victoriametrics.prometheusConfig.scrape_configs =
      lib.mkIf config.my.services.metrics.enable
        [
          (homelab.scrape "adguard" exporterPort)
        ];

    services.restic.backups = lib.mkIf config.my.services.restic.enable {
      homelab.paths = [ "/var/lib/AdGuardHome/AdGuardHome.yaml" ];
    };

    my.nginx.vhosts = {
      adguard = config.services.adguardhome.port;
    };

    services.gatus.settings.endpoints = [
      (homelab.endpoint {
        name = "AdGuard";
        group = "Networking";
        inherit url;
      })
    ];

    my.homepage.services."Networking" = [
      {
        AdGuard = {
          icon = "adguard-home";
          href = url;
          description = "DNS-level Ad Blocking";
          widget = {
            type = "adguard";
            inherit url;
          };
        };
      }
    ];

    services.vector.settings.sources.journald.include_units = [ "adguardhome" ];
  };
}
