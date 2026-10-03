{ options, config, lib, pkgs, constants, ... }:

with lib;
let
  inherit (constants) domain;
  # AdGuard Home uses port 53 for DNS by default
  adguardDNSPort = 53;
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
      allowedUDPPorts = [ adguardDNSPort ];
      allowedTCPPorts = [ adguardDNSPort ];
    };

    # For troubleshooting DNS
    environment.systemPackages = with pkgs; [
      # Collection of common network programs (e.g. ftp, ping, traceroute, hostname, ifconfig)
      inetutils
      # DNS tools (e.g. nslookup, dig)
      dnsutils
    ];

    services.restic.backups = lib.mkIf config.my.services.restic.enable {
      homelab.paths = [ "/var/lib/AdGuardHome/AdGuardHome.yaml" ];
    };

    my.nginx.vhosts = {
      adguard = config.services.adguardhome.port;
    };

    services.gatus.settings.endpoints = [
      {
        name = "AdGuard";
        group = "Networking";
        url = "https://adguard.${domain}";
        interval = "60s";
        conditions = [ "[STATUS] == 200" ];
      }
    ];

    my.homepage.services."Networking" = [
      {
        AdGuard = {
          icon = "adguard-home";
          href = "https://adguard.${domain}";
          description = "DNS-level Ad Blocking";
          widget = {
            type = "adguard";
            url = "https://adguard.${domain}";
          };
        };
      }
    ];

    services.vector.settings.sources.journald.include_units = [ "adguardhome" ];
  };
}
