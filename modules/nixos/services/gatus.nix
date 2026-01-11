{ ... }:
let
  domain = "ehbr.cloud";
in
{
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

      endpoints = [
        # Monitoring
        {
          name = "Grafana";
          group = "Monitoring";
          url = "https://grafana.${domain}";
          interval = "60s";
          conditions = [ "[STATUS] == 200" ];
        }
        {
          name = "Prometheus (VictoriaMetrics)";
          group = "Monitoring";
          url = "https://prometheus.${domain}";
          interval = "60s";
          conditions = [ "[STATUS] == 200" ];
        }
        {
          name = "Logs (VictoriaLogs)";
          group = "Monitoring";
          url = "https://logs.${domain}/health";
          interval = "60s";
          conditions = [ "[STATUS] == 200" ];
        }

        # Media
        {
          name = "Jellyfin";
          group = "Media";
          url = "https://jellyfin.${domain}/health";
          interval = "60s";
          conditions = [ "[STATUS] == 200" ];
        }
        {
          name = "Sonarr";
          group = "Media";
          url = "https://sonarr.${domain}";
          interval = "60s";
          conditions = [ "[STATUS] == 200" ];
        }
        {
          name = "Radarr";
          group = "Media";
          url = "https://radarr.${domain}";
          interval = "60s";
          conditions = [ "[STATUS] == 200" ];
        }
        {
          name = "Prowlarr";
          group = "Media";
          url = "https://prowlarr.${domain}";
          interval = "60s";
          conditions = [ "[STATUS] == 200" ];
        }

        # Networking
        {
          name = "AdGuard";
          group = "Networking";
          url = "https://adguard.${domain}";
          interval = "60s";
          conditions = [ "[STATUS] == 200" ];
        }

        # Downloads
        {
          name = "Transmission";
          group = "Downloads";
          url = "https://transmission.${domain}";
          interval = "60s";
          conditions = [ "[STATUS] == 200" "[RESPONSE_TIME] < 2000" ];
        }

        # Home Automation
        {
          name = "ntfy";
          group = "Home";
          url = "https://ntfy.${domain}";
          interval = "60s";
          conditions = [ "[STATUS] == 200" ];
        }
      ];
    };
  };

  # Ensure state directory exists
  systemd.services.gatus.serviceConfig = {
    StateDirectory = "gatus";
  };
}
