{ ... }:
let
  # Services to collect logs from (without .service suffix)
  monitoredUnits = [
    # Media
    "jellyfin"
    "sonarr"
    "radarr"
    "prowlarr"
    "transmission"
    # Monitoring
    "victorialogs"
    "victoriametrics"
    "grafana"
    "gatus"
    # Networking
    "nginx"
    "adguardhome"
    "fail2ban"
    "tailscaled"
    # Home Automation
    "ntfy-sh"
    # Backup
    "restic-backups-homelab"
    # Shell
    "atuin"
  ];
in
{
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
        include_units = monitoredUnits;
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

}
