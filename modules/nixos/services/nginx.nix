{ config
, lib
, pkgs
, ...
}:
let
  email = "mr.ehbr@gmail.com";
  domain = "ehbr.cloud";

  # Helper function to create a virtual host with SSL and reverse proxy
  mkVhost = port: {
    forceSSL = true;
    useACMEHost = domain;
    locations."/" = {
      proxyPass = "http://localhost:${toString port}";
      proxyWebsockets = true;
    };
  };

  # Service subdomain to port mapping
  services = {
    atuin = 5000;
    prometheus = 8428;
    grafana = 3100;
    logs = 9428;
    adguard = 3000;
    transmission = 9091;
    jellyfin = 8096;
    sonarr = 8989;
    radarr = 7878;
    prowlarr = 9696;
    uptime = 4000;
    ntfy = 6780;
    homebridge = 8581;
    zigbee2mqtt = 8072;
  };

  # Generate virtual hosts from services map
  serviceVhosts = lib.mapAttrs'
    (name: port: lib.nameValuePair "${name}.${domain}" (mkVhost port))
    services;
in
{
  security.acme = {
    acceptTerms = true;
    defaults.email = email;

    certs."${domain}" = {
      extraDomainNames = [ "*.${domain}" ];
      dnsProvider = "cloudflare";
      dnsPropagationCheck = true;
      credentialsFile = config.age.secrets.acme.path;
      webroot = null;
      reloadServices = [ "nginx" ];
    };
  };

  users.users.nginx.extraGroups = [ "acme" ];

  services.nginx = {
    enable = true;
    statusPage = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = {
      # Root domain uses enableACME instead of useACMEHost
      "${domain}" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://localhost:8082";
          proxyWebsockets = true;
        };
      };
    } // serviceVhosts;
  };

  networking.firewall = {
    allowedTCPPorts = [ 80 443 ];
    allowedUDPPorts = [ 80 443 ];
  };
}
