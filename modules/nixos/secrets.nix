{ config, lib, secrets, user, ... }:
let
  cfg = config.my.secrets;
in
{
  options.my.secrets = {
    github.enable = lib.mkEnableOption "GitHub ssh key at ~/.ssh/id_github";

    names = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Secrets decrypted from <secrets>/<name>.age, owned by the user and wheel, mode 600.";
    };
  };

  config = {
    age.identityPaths = [
      "/home/${user}/.ssh/id_ed25519"
    ];

    age.secrets = lib.mkMerge [
      (lib.genAttrs cfg.names (name: {
        file = "${secrets}/${name}.age";
        mode = "600";
        owner = user;
        group = "wheel";
      }))

      (lib.mkIf cfg.github.enable {
        "github-ssh-key" = {
          symlink = false;
          path = "/home/${user}/.ssh/id_github";
          file = "${secrets}/github-ssh-key.age";
          mode = "600";
          owner = "${user}";
          group = "wheel";
        };
      })
    ];
    # age.secrets."mqtt_root" = {
    #   file = "${secrets}/mqtt_root.age";
    #   mode = "600";
    #   owner = "mosquitto";
    #   group = "wheel";
    # };
    # age.secrets."mqtt_zigbee2mqtt" = {
    #   file = "${secrets}/mqtt_zigbee2mqtt.age";
    #   mode = "600";
    #   owner = "mosquitto";
    #   group = "wheel";
    # };
    # age.secrets."zigbee2mqtt.yaml" = {
    #   file = "${secrets}/zigbee2mqtt.yaml.age";
    #   mode = "600";
    #   owner = "zigbee2mqtt";
    #   group = "wheel";
    # };
  };
}
