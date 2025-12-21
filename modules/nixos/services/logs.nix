{ ... }:
let
  # Services to collect logs from
  monitoredUnits = [
    # Media
    "jellyfin.service"
    "sonarr.service"
    "radarr.service"
    "prowlarr.service"
    "transmission.service"
    "aria2.service"
    # Monitoring
    "victorialogs.service"
    "victoriametrics.service"
    "grafana.service"
    "uptime-kuma.service"
    # Networking
    "nginx.service"
    "adguardhome.service"
    "fail2ban.service"
    "tailscaled.service"
    # Home Automation
    "ntfy-sh.service"
    # Backup
    "restic-backups-homelab.service"
    # Shell
    "atuin.service"
  ];

  # Build regex pattern for Vector filter
  unitPattern = builtins.concatStringsSep "|" monitoredUnits;
in
{
  services.victorialogs = {
    enable = true;
  };

  services.vector = {
    enable = true;
    settings = {
      sources.journald = {
        type = "journald";
        current_boot_only = false;
      };

      transforms.filter_units = {
        type = "filter";
        inputs = [ "journald" ];
        condition = ''.UNIT != null && match!(.UNIT, r'^(${unitPattern})$')'';
      };

      sinks.victorialogs = {
        type = "http";
        inputs = [ "filter_units" ];
        uri = "http://localhost:9428/insert/jsonline";
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
