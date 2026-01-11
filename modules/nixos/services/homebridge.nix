{ config
, lib
, pkgs
, ...
}: {
  services.homebridge = {
    enable = true;
    openFirewall = true;
    allowInsecure = true;
  };

  services.mosquitto = {
    enable = true;
    listeners = [
      {
        users.root = {
          acl = [ "readwrite #" ];
          passwordFile = config.age.secrets."mqtt_root".path;
        };
        users.zigbee2mqtt = {
          acl = [ "readwrite zigbee2mqtt/#" ];
          passwordFile = config.age.secrets."mqtt_zigbee2mqtt".path;
        };
      }
    ];
  };

  services.zigbee2mqtt = {
    enable = true;
    settings = {
      permit_join = false;
      serial.port = "/dev/serial/by-id/usb-ITead_Sonoff_Zigbee_3.0_USB_Dongle_Plus_9a8f80c23f96ed118ffb654ce259fb3e-if00-port0";
      mqtt = {
        server = "mqtt://localhost:1883";
        user = "zigbee2mqtt";
        password = "!${config.age.secrets."zigbee2mqtt.yaml".path} password";
        base_topic = "zigbee2mqtt";
      };
      advanced = {
        log_level = "warn";
      };
      frontend.port = 8072;
    };
  };

  services.restic.backups.homelab.paths = [ "/var/lib/homebridge" "/var/lib/zigbee2mqtt" "/var/lib/mosquitto" ];
}
