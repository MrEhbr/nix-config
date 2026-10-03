{ options, config, lib, pkgs, ... }:

with lib;
let
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
  };
}
