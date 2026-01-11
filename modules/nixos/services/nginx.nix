{ config
, lib
, pkgs
, ...
}:
let
  email = "mr.ehbr@gmail.com";
  domain = "ehbr.cloud";
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
    # Enable the NGINX status page
    statusPage = true;

    # Use recommended settings
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = {
      "${domain}" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://localhost:8082";
          proxyWebsockets = true;
        };
      };
      "atuin.${domain}" = {
        forceSSL = true;
        useACMEHost = domain;
        locations."/" = {
          proxyPass = "http://localhost:5000";
          proxyWebsockets = true;
        };
      };
      "prometheus.${domain}" = {
        forceSSL = true;
        useACMEHost = domain;
        locations."/" = {
          proxyPass = "http://localhost:8428";
          proxyWebsockets = true;
        };
      };
      "grafana.${domain}" = {
        forceSSL = true;
        useACMEHost = domain;
        locations."/" = {
          proxyPass = "http://localhost:3100";
          proxyWebsockets = true;
        };
      };
      "logs.${domain}" = {
        forceSSL = true;
        useACMEHost = domain;
        locations."/" = {
          proxyPass = "http://localhost:9428";
          proxyWebsockets = true;
        };
      };
      "adguard.${domain}" = {
        forceSSL = true;
        useACMEHost = domain;
        locations."/" = {
          proxyPass = "http://localhost:3000";
          proxyWebsockets = true;
        };
      };
      "transmission.${domain}" = {
        forceSSL = true;
        useACMEHost = domain;
        locations."/" = {
          proxyPass = "http://localhost:9091";
          proxyWebsockets = true;
        };
      };
      "jellyfin.${domain}" = {
        forceSSL = true;
        useACMEHost = domain;
        locations."/" = {
          proxyPass = "http://localhost:8096";
          proxyWebsockets = true;
        };
      };
      "sonarr.${domain}" = {
        forceSSL = true;
        useACMEHost = domain;
        locations."/" = {
          proxyPass = "http://localhost:8989";
          proxyWebsockets = true;
        };
      };
      "radarr.${domain}" = {
        forceSSL = true;
        useACMEHost = domain;
        locations."/" = {
          proxyPass = "http://localhost:7878";
          proxyWebsockets = true;
        };
      };
      "prowlarr.${domain}" = {
        forceSSL = true;
        useACMEHost = domain;
        locations."/" = {
          proxyPass = "http://localhost:9696";
          proxyWebsockets = true;
        };
      };
      "uptime.${domain}" = {
        forceSSL = true;
        useACMEHost = domain;
        locations."/" = {
          proxyPass = "http://localhost:4000";
          proxyWebsockets = true;
        };
      };
      "ntfy.${domain}" = {
        forceSSL = true;
        useACMEHost = domain;
        locations."/" = {
          proxyPass = "http://localhost:6780";
          proxyWebsockets = true;
        };
      };
      "homebridge.${domain}" = {
        forceSSL = true;
        useACMEHost = domain;
        locations."/" = {
          proxyPass = "http://localhost:8581";
          proxyWebsockets = true;
        };
      };
      "zigbee2mqtt.${domain}" = {
        forceSSL = true;
        useACMEHost = domain;
        locations."/" = {
          proxyPass = "http://localhost:8072";
          proxyWebsockets = true;
        };
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 80 443 ];
    allowedUDPPorts = [ 80 443 ];
  };
}
