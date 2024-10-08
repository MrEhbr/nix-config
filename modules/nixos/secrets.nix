{ config, pkgs, agenix, secrets, ... }:

let user = "ehbr"; in
{
  age.identityPaths = [
    "/home/${user}/.ssh/id_ed25519"
  ];

  # Your secrets go here
  #
  # Note: the installWithSecrets command you ran to boostrap the machine actually copies over
  #       a Github key pair. However, if you want to store the keypair in your nix-secrets repo
  #       instead, you can reference the age files and specify the symlink path here. Then add your
  #       public key in shared/files.nix.
  #
  #       If you change the key name, you'll need to update the SSH configuration in shared/home-manager.nix
  #       so Github reads it correctly.

  #
  age.secrets."github-ssh-key" = {
    symlink = false;
    path = "/home/${user}/.ssh/id_github";
    file = "${secrets}/github-ssh-key.age";
    mode = "600";
    owner = "${user}";
    group = "wheel";
  };

  age.secrets."wifi" = {
    file = "${secrets}/wifi.age";
    mode = "600";
    owner = "${user}";
    group = "wheel";
  };

  age.secrets."acme" = {
    file = "${secrets}/acme.age";
    mode = "600";
    owner = "${user}";
    group = "wheel";
  };

  age.secrets."homepage" = {
    file = "${secrets}/homepage.age";
    mode = "600";
    owner = "${user}";
    group = "wheel";
  };
  age.secrets."tailscale" = {
    file = "${secrets}/tailscale.age";
    mode = "600";
    owner = "${user}";
    group = "wheel";
  };
  age.secrets."rclone" = {
    file = "${secrets}/rclone.age";
    mode = "600";
    owner = "${user}";
    group = "wheel";
  };
  age.secrets."restic" = {
    file = "${secrets}/restic.age";
    mode = "600";
    owner = "${user}";
    group = "wheel";
  };
  age.secrets."mqtt_root" = {
    file = "${secrets}/mqtt_root.age";
    mode = "600";
    owner = "mosquitto";
    group = "wheel";
  };
  age.secrets."mqtt_zigbee2mqtt" = {
    file = "${secrets}/mqtt_zigbee2mqtt.age";
    mode = "600";
    owner = "mosquitto";
    group = "wheel";
  };
  age.secrets."zigbee2mqtt.yaml" = {
    file = "${secrets}/zigbee2mqtt.yaml.age";
    mode = "600";
    owner = "zigbee2mqtt";
    group = "wheel";
  };
}
