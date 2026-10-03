{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.services.fail2ban.enable = lib.mkEnableOption "fail2ban";

  config = lib.mkIf config.my.services.fail2ban.enable {
    environment.etc."fail2ban/filter.d/nginx-probing.conf".text = ''
      [Definition]
      failregex = ^<HOST>.*GET.*(matrix/server|\.php|admin|wp\-).* HTTP/\d.\d\" 404.*$
    '';

    services.fail2ban = {
      enable = true;
      # Needed to ban on IPv4 and IPv6 for all ports
      extraPackages = [ pkgs.ipset ];
      banaction = "iptables-ipset-proto6-allports";
      # Ban IP after 5 failures
      maxretry = 5;
      ignoreIP = [
        # Whitelist some subnets
        # Local subnet
        "192.168.2.0/24"
        # Tailscale subnet
        "100.64.0.0/10"
      ];
      # Ban IPs for one hour on the first ban
      bantime = "1h";
      bantime-increment = {
        # Enable increment of bantime after each violation
        enable = true;
        multipliers = "1 2 4 8 16 32 64";
        # Do not ban for more than 1 week
        maxtime = "168h";
        # Calculate the bantime based on all the violations
        overalljails = true;
      };
      jails = {
        # Maximum 6 failures in 600 seconds
        "nginx-probing" = ''
          enabled = true
          filter = nginx-probing
          logpath = /var/log/nginx/access.log
          backend = auto
          maxretry = 5
          findtime = 600
        '';
      };
    };

    services.vector.settings.sources.journald.include_units = [ "fail2ban" ];
  };
}
