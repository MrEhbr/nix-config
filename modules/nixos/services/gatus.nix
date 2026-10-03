{ config, lib, constants, ... }:
let
  inherit (constants) domain;
in
{
  options.my.services.gatus.enable = lib.mkEnableOption "gatus";

  config = lib.mkIf config.my.services.gatus.enable {
    services.gatus = {
      enable = true;
      settings = {
        web = {
          port = 4000;
          address = "127.0.0.1";
        };

        storage = {
          type = "sqlite";
          path = "/var/lib/gatus/data.db";
        };

        ui = {
          title = "Status | ${domain}";
          header = "Service Status";
        };

      };
    };

    # Ensure state directory exists
    systemd.services.gatus.serviceConfig = {
      StateDirectory = "gatus";
    };

    my.nginx.vhosts = {
      uptime = config.services.gatus.settings.web.port;
    };

    my.homepage.services."Monitoring" = lib.mkAfter [
      {
        Gatus = {
          icon = "gatus";
          href = "https://uptime.${domain}";
          description = "Status page";
          widget = {
            type = "gatus";
            url = "https://uptime.${domain}";
          };
        };
      }
    ];

    services.vector.settings.sources.journald.include_units = [ "gatus" ];
  };
}
