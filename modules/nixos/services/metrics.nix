{
  config,
  lib,
  homelab,
  ...
}:
let
  port = 8428;
  url = homelab.url "prometheus";
in
{
  options.my.services.metrics.enable = lib.mkEnableOption "metrics";

  config = lib.mkIf config.my.services.metrics.enable {
    services.victoriametrics = {
      enable = true;
      listenAddress = ":${toString port}";
      prometheusConfig.scrape_configs = with config.services.prometheus.exporters; [
        (homelab.scrape "node" node.port)
        (homelab.scrape "systemd" systemd.port)
        (homelab.scrape "smartctl" smartctl.port)
        (homelab.scrape "nginx" nginx.port)
        {
          job_name = "process-exporter";
          scrape_interval = "15s";
          static_configs = [
            {
              targets = [ "localhost:${toString process.port}" ];
            }
          ];
        }
        (
          (homelab.scrape "speedtest" config.services.speedtest-exporter.port)
          // {
            scrape_timeout = "30s";
            scrape_interval = "1h";
          }
        )
        (homelab.scrape "victoriametrics" port)
      ];
    };

    # Prometheus exporters (compatible with VictoriaMetrics)
    services.prometheus.exporters = {
      node = {
        enable = true;
        port = 9100;
        enabledCollectors = [ "systemd" ];
      };

      process = {
        enable = true;
        port = 9256;
        user = "root";
        settings.process_names = [
          {
            name = "{{ .Matches.Wrapped }}";
            cmdline = [ "^/nix/store[^ ]*/(?P<Wrapped>[^ /]*)" ];
          }
          {
            name = "{{ .Matches.Command }}";
            cmdline = [ "(?P<Command>[^ ]+)" ];
          }
        ];
      };

      systemd = {
        enable = true;
        port = 9558;
      };

      smartctl = {
        enable = true;
        user = "root";
        port = 9633;
      };

      nginx = {
        enable = true;
        port = 9113;
        openFirewall = false;
      };
    };

    services.speedtest-exporter = {
      enable = true;
      port = 9862;
    };

    my.nginx.vhosts = {
      prometheus = port;
    };

    services.gatus.settings.endpoints = [
      (homelab.endpoint {
        name = "Prometheus (VictoriaMetrics)";
        group = "Monitoring";
        inherit url;
      })
    ];

    my.homepage.services."Monitoring" = [
      {
        Prometheus = {
          icon = "victoriametrics";
          href = url;
          description = "Metrics (VictoriaMetrics)";
          widget = {
            type = "prometheus";
            inherit url;
          };
        };
      }
    ];

    services.vector.settings.sources.journald.include_units = [ "victoriametrics" ];
  };
}
