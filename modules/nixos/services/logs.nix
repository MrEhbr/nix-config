{ config, lib, constants, ... }:
let
  inherit (constants) domain;
in
{
  options.my.services.logs.enable = lib.mkEnableOption "logs";

  config = lib.mkIf config.my.services.logs.enable {
    services.victorialogs = {
      enable = true;
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
          uri = "http://localhost:9428/insert/jsonline?_msg_field=message&_time_field=timestamp&_stream_fields=unit";
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
      logs = 9428;
    };

    services.gatus.settings.endpoints = [
      {
        name = "Logs (VictoriaLogs)";
        group = "Monitoring";
        url = "https://logs.${domain}/health";
        interval = "60s";
        conditions = [ "[STATUS] == 200" ];
      }
    ];

    my.homepage.services."Monitoring" = [
      {
        VictoriaLogs = {
          icon = "victoriametrics";
          href = "https://logs.${domain}/select/vmui";
          description = "Logs";
        };
      }
    ];

    services.vector.settings.sources.journald.include_units = [ "victorialogs" ];
  };
}
