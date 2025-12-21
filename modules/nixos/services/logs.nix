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
    # "homebridge.service"
    # "zigbee2mqtt.service"
    # Backup
    "restic-backups-homelab.service"
    # Shell
    "atuin.service"
  ];
in
{
  services.victorialogs = {
    enable = true;
  };

  services.journald.upload = {
    enable = true;
    settings.Upload = {
      URL = "http://localhost:9428/insert/journald";
    };
  };

  # Filter to only upload logs from specific services
  systemd.services.systemd-journal-upload = {
    after = [ "victorialogs.service" ];
    requires = [ "victorialogs.service" ];
    serviceConfig.ExecStart = let
      matches = builtins.concatStringsSep " " (map (u: "--match=_SYSTEMD_UNIT=${u}") monitoredUnits);
    in [
      ""  # Clear default ExecStart
      "/run/current-system/systemd/lib/systemd/systemd-journal-upload --save-state ${matches}"
    ];
  };
}
