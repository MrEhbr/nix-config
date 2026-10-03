{ config, lib, pkgs, constants, ... }:
let
  inherit (constants) domain;
  inherit (constants.git) email;

  # Helper function to create a virtual host with SSL and reverse proxy
  mkVhost = port: {
    forceSSL = true;
    useACMEHost = domain;
    locations."/" = {
      proxyPass = "http://localhost:${toString port}";
      proxyWebsockets = true;
    };
  };

  serviceVhosts = lib.mapAttrs'
    (name: port: lib.nameValuePair "${name}.${domain}" (mkVhost port))
    config.my.nginx.vhosts;
in
{
  options.my.services.nginx.enable = lib.mkEnableOption "nginx";

  options.my.nginx.vhosts = lib.mkOption {
    type = lib.types.attrsOf lib.types.port;
    default = { };
    description = "Subdomains of the domain reverse-proxied to a local port.";
  };

  config = lib.mkIf config.my.services.nginx.enable {
    my.secrets.names = [ "acme" ];

    security.acme = {
      acceptTerms = true;
      defaults.email = email;

      certs."${domain}" = {
        extraDomainNames = [ "*.${domain}" ];
        dnsProvider = "cloudflare";
        dnsPropagationCheck = true;
        environmentFile = config.age.secrets.acme.path;
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
        };

        # llama router on sparrow
        "llama.${domain}" = {
          forceSSL = true;
          useACMEHost = domain;
          locations."/" = {
            proxyPass = "http://192.168.1.112:11435";
            proxyWebsockets = true;
            extraConfig = ''
              proxy_buffering off;
              proxy_read_timeout 600s;
            '';
          };
        };
      } // serviceVhosts;
    };

    networking.firewall = {
      allowedTCPPorts = [ 80 443 ];
      allowedUDPPorts = [ 80 443 ];
    };

    services.vector.settings.sources.journald.include_units = [ "nginx" ];
  };
}
