{
  config,
  lib,
  constants,
  homelab,
  ...
}:

let
  inherit (constants) domain;
  url = homelab.url "llama";
in
{
  options.my.services.llama.enable = lib.mkEnableOption "llama.cpp router on sparrow";

  config = lib.mkIf config.my.services.llama.enable {
    # llama router on sparrow
    services.nginx.virtualHosts."llama.${domain}" = {
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

    my.homepage.services."AI" = [
      {
        Llama = {
          icon = "mdi-robot-outline";
          href = url;
          description = "llama.cpp on sparrow";
          siteMonitor = "${url}/health";
        };
      }
    ];
  };
}
