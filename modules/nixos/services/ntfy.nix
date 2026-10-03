{
  config,
  lib,
  homelab,
  ...
}:

let
  ntfyPort = 6780;
  ntfyMetricsPort = 19095;
  url = homelab.url "ntfy";
in
{
  options.my.services.ntfy.enable = lib.mkEnableOption "ntfy";

  config = lib.mkIf config.my.services.ntfy.enable {
    services.ntfy-sh = {
      enable = true;
      settings = {
        base-url = url;
        listen-http = ":${toString ntfyPort}";
        behind-proxy = true;
        auth-default-access = "deny-all";
        upstream-base-url = "https://ntfy.sh";
        # Set to "disable" to disable web UI
        # See https://github.com/binwiederhier/ntfy/issues/459
        web-root = "app";
        # Enable metrics endpoint for Prometheus
        enable-metrics = true;
        metrics-listen-http = ":${toString ntfyMetricsPort}";
      };
    };

    environment.systemPackages = [ config.services.ntfy-sh.package ];

    services.restic.backups = lib.mkIf config.my.services.restic.enable {
      homelab.paths = [
        "/var/lib/ntfy-sh/user.db"
        "/var/lib/ntfy-sh/attachments"
        "/var/lib/ntfy-sh/cache-file.db"
      ];
    };

    my.nginx.vhosts = {
      ntfy = ntfyPort;
    };

    services.gatus.settings.endpoints = [
      (homelab.endpoint {
        name = "ntfy";
        group = "Home Automation";
        inherit url;
      })
    ];

    my.homepage.services."Home Automation" = [
      {
        ntfy = {
          icon = "ntfy";
          href = url;
          description = "Notifications";
        };
      }
    ];

    services.victoriametrics.prometheusConfig.scrape_configs =
      lib.mkIf config.my.services.metrics.enable
        [
          (homelab.scrape "ntfy" ntfyMetricsPort)
        ];

    services.vector.settings.sources.journald.include_units = [ "ntfy-sh" ];
  };
}
