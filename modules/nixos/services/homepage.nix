{ options, config, lib, ... }:

let
  homepagePort = 8082;
  domain = "ehbr.cloud";
in
{
  services.homepage-dashboard = {
    enable = true;
    listenPort = homepagePort;
    environmentFile = config.age.secrets.homepage.path;
    allowedHosts = "localhost:8082,127.0.0.1:8082,${domain}";
    settings = {
      title = "Homepage";
      theme = "dark";
      language = "en";
      headerStyle = "boxedWidgets";
      disableCollape = true;
      cardBlur = "md";
      color = "gray";
      fiveColumns = true;
      statusStyle = "dot";
      hideVersion = true;
      layout = [
        {
          "Networking" = {
            style = "row";
            columns = 1;
          };
        }
        {
          "Media" = {
            style = "row";
            columns = 1;
          };
        }
        {
          "Downloaders" = {
            style = "row";
            columns = 1;
          };
        }
        {
          "Monitoring" = {
            style = "row";
            columns = 1;
          };
        }
        {
          "Home Automation" = {
            style = "row";
            columns = 1;
          };
        }
        {
          "Misc" = {
            style = "row";
            columns = 1;
          };
        }
      ];
    };
    widgets = [
      {
        resources = {
          cpu = true;
          memory = true;
          disk = "/mnt/storage";
          cputemp = true;
          uptime = true;
        };
      }
    ];
    services = [
      {
        "Networking" = [
          {
            AdGuard = {
              icon = "adguard-home";
              href = "https://adguard.${domain}";
              description = "DNS-level Ad Blocking";
              widget = {
                type = "adguard";
                url = "https://adguard.${domain}";
              };
            };
          }
        ];
      }
      {
        "Monitoring" = [
          {
            Grafana = {
              icon = "grafana";
              href = "https://grafana.${domain}";
              description = "Metrics dashboards";
            };
          }
          {
            Prometheus = {
              icon = "victoriametrics";
              href = "https://prometheus.${domain}";
              description = "Metrics (VictoriaMetrics)";
              widget = {
                type = "prometheus";
                url = "https://prometheus.${domain}";
              };
            };
          }
          {
            VictoriaLogs = {
              icon = "victoriametrics";
              href = "https://logs.${domain}/select/vmui";
              description = "Logs";
            };
          }
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
      }
      {
        "Downloaders" = [
          {
            Transmission = {
              icon = "transmission";
              href = "https://transmission.${domain}";
              description = "Torrent client";
              widget = {
                type = "transmission";
                url = "https://transmission.${domain}";
              };
            };
          }
        ];
      }
      {
        "Media" = [
          {
            Jellyfin = {
              icon = "jellyfin";
              href = "https://jellyfin.${domain}";
              description = "Media server";
              widget = {
                type = "jellyfin";
                url = "https://jellyfin.${domain}";
                key = "{{HOMEPAGE_VAR_JELLYFIN_API_KEY}}";
                enableBlocks = true;
                enableNowPlaying = false;
              };
            };
          }
          {
            Sonarr = {
              icon = "sonarr";
              href = "https://sonarr.${domain}";
              description = "TV Shows";
              widget = {
                type = "sonarr";
                url = "https://sonarr.${domain}";
                key = "{{HOMEPAGE_VAR_SONARR_API_KEY}}";
                enableBlocks = true;
                showEpisodeNumber = true;
              };
            };
          }
          {
            Radarr = {
              icon = "radarr";
              href = "https://radarr.${domain}";
              description = "Movies";
              widget = {
                type = "radarr";
                url = "https://radarr.${domain}";
                key = "{{HOMEPAGE_VAR_RADARR_API_KEY}}";
                enableBlocks = true;
                showEpisodeNumber = true;
              };
            };
          }
        ];
      }
      {
        "Home Automation" = [
          {
            ntfy = {
              icon = "ntfy";
              href = "https://ntfy.${domain}";
              description = "Notifications";
            };
          }
          {
            "Homebridge" = {
              icon = "homebridge";
              href = "https://homebridge.${domain}";
              description = "HomeKit";
            };
          }
          {
            "Zigbee2MQTT" = {
              icon = "zigbee2mqtt";
              href = "https://zigbee2mqtt.${domain}";
              description = "Zigbee";
            };
          }
        ];
      }
    ];
  };

  environment.systemPackages = [ config.services.homepage-dashboard.package ];
}
