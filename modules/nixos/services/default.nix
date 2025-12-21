_: {

  imports = [
    ./homepage.nix
    ./adguard.nix
    ./nginx.nix
    ./logs.nix
    ./media.nix
    ./metrics.nix
    ./grafana
    ./uptime-kuma.nix
    ./fail2ban.nix
    ./ntfy.nix
    ./tailscale.nix
    ./restic.nix
    ./atuin.nix
    # ./homebridge.nix
  ];
}
