{
  config,
  lib,
  homelab,
  ...
}:
let
  port = 9428;
  url = homelab.url "logs";
in
{
  options.my.services.logs.enable = lib.mkEnableOption "logs";

  config = lib.mkIf config.my.services.logs.enable {
    services.victorialogs = {
      enable = true;
      listenAddress = ":${toString port}";
    };

    services.vector = {
      enable = true;
      journaldAccess = true;
      settings = {
        sources.journald = {
          type = "journald";
          current_boot_only = true;
        };

        transforms.clean = {
          type = "remap";
          inputs = [ "journald" ];
          source = ''
            . = {
              "message": .message,
              "timestamp": .timestamp,
              "unit": ."_SYSTEMD_UNIT",
              "priority": .PRIORITY,
            }
          '';
        };

        sinks.victorialogs = {
          type = "http";
          inputs = [ "clean" ];
          uri = "http://localhost:${toString port}/insert/jsonline?_msg_field=message&_time_field=timestamp&_stream_fields=unit";
          compression = "gzip";
          encoding.codec = "json";
          framing.method = "newline_delimited";
          healthcheck.enabled = false;
        };
      };
    };

    # Ensure vector starts after VictoriaLogs
    systemd.services.vector = {
      after = [ "victorialogs.service" ];
      requires = [ "victorialogs.service" ];
    };

    my.nginx.vhosts = {
      logs = port;
    };

    services.gatus.settings.endpoints = [
      (homelab.endpoint {
        name = "Logs (VictoriaLogs)";
        group = "Monitoring";
        url = "${url}/health";
      })
    ];

    my.homepage.services."Monitoring" = [
      {
        VictoriaLogs = {
          icon = "victoriametrics";
          href = "${url}/select/vmui";
          description = "Logs";
        };
      }
    ];

    services.victoriametrics.prometheusConfig.scrape_configs =
      lib.mkIf config.my.services.metrics.enable
        [
          (homelab.scrape "victorialogs" port)
        ];

    services.vector.settings.sources.journald.include_units = [ "victorialogs" ];
  };
}
