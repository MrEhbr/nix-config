{ pkgs, options, config, lib, ... }:
{
  options.my.services.tailscale.enable = lib.mkEnableOption "tailscale";

  config = lib.mkIf config.my.services.tailscale.enable {
    my.secrets.names = [ "tailscale" ];

    services = {
      tailscale = {
        enable = true;
        useRoutingFeatures = "both";
        authKeyFile = config.age.secrets."tailscale".path;
        openFirewall = true;
        extraUpFlags = [
          "--accept-dns=false"
          "--advertise-routes=192.168.2.0/24"
          "--advertise-exit-node"
          "--exit-node-allow-lan-access=true"
        ];
      };
    };

    networking.firewall = {
      checkReversePath = "loose";
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ config.services.tailscale.port ];
    };
  };
}
