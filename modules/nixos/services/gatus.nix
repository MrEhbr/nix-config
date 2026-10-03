{
  config,
  lib,
  constants,
  homelab,
  ...
}:
let
  inherit (constants) domain;
  url = homelab.url "uptime";
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
          href = url;
          description = "Status page";
          widget = {
            type = "gatus";
            inherit url;
          };
        };
      }
    ];

    services.vector.settings.sources.journald.include_units = [ "gatus" ];
  };
}
