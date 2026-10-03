{ config, ... }:

{
  my.secrets.names = [ "wifi" ];

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking = {
    resolvconf.useLocalResolver = true;
    hostName = "server"; # Define your hostname.
    networkmanager.enable = false;
    interfaces.enp2s0 = {
      wakeOnLan.enable = true;
      macAddress = "d1:7f:c9:27:cc:d8";
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "192.168.2.3";
          prefixLength = 24;
        }
      ];
      ipv4.routes = [
        {
          address = "0.0.0.0";
          prefixLength = 0;
          via = "192.168.2.1";
          options = {
            metric = "100";
          };
        }
      ];
    };

    interfaces.wlp3s0 = {
      useDHCP = false;
      macAddress = "b7:4b:57:19:4f:f3";
      ipv4.addresses = [
        {
          address = "192.168.2.31";
          prefixLength = 24;
        }
      ];
      ipv4.routes = [
        {
          address = "0.0.0.0";
          prefixLength = 0;
          via = "192.168.2.1";
          options = {
            metric = "200";
          };
        }
      ];
    };

    defaultGateway = {
      address = "192.168.2.1";
      interface = "enp2s0";
    };

    wireless = {
      enable = true;
      secretsFile = config.age.secrets.wifi.path;
      networks = {
        "IoT" = {
          pskRaw = "ext:PKS_IOT";
        };
      };
    };

    firewall = {
      enable = true;
      allowedTCPPorts = [
        5001
        5201
      ];
      allowedUDPPorts = [
        5001
        5201
      ];
    };
  };
}
