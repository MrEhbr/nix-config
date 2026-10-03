{ options, config, lib, constants, ... }:

let
  inherit (constants) domain;
  ntfyPort = 6780;
  ntfyMetricsPort = 19095;
  ntfyHost = "ntfy.${domain}";
in
{
  options.my.services.ntfy.enable = lib.mkEnableOption "ntfy";

  config = lib.mkIf config.my.services.ntfy.enable {
    services.ntfy-sh = {
      enable = true;
      settings = {
        base-url = "https://${ntfyHost}";
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
      homelab.paths = [ "/var/lib/ntfy-sh/user.db" "/var/lib/ntfy-sh/attachments" "/var/lib/ntfy-sh/cache-file.db" ];
    };
  };
}
