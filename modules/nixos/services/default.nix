_: {

  imports = [
    ./homepage.nix
    ./adguard.nix
    ./nginx.nix
    ./media.nix
    ./prometheus.nix
    ./grafana
    ./uptime-kuma.nix
    ./fail2ban.nix
    ./ntfy.nix
    ./tailscale.nix
    ./restic.nix
    # ./homebridge.nix
  ];
}
