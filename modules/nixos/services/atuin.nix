{ pkgs, config, lib, ... }:
{
  services.atuin = {
    enable = true;
    openRegistration = true;
    host = "127.0.0.1";
    maxHistoryLength = 1000000;
    port = 5000;
    database = {
      createLocally = false;
      uri = "sqlite:///var/lib/atuin/atuin.db";
    };
  };

  systemd.services.atuin.serviceConfig = {
    StateDirectory = "atuin";
    StateDirectoryMode = "0700";
  };


  services.restic.backups.homelab.paths = [ "/var/lib/atuin/atuin.db" ];
}

