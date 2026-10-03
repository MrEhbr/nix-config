{ lib, pkgs, config, ... }: {
  options.my.services.restic.enable = lib.mkEnableOption "restic";

  config = lib.mkIf config.my.services.restic.enable {
    my.secrets.names = [ "rclone" "restic" ];

    services.restic.backups = {
      homelab = {
        repository = "rclone:r2:backups";
        passwordFile = config.age.secrets."restic".path;
        rcloneConfigFile = config.age.secrets."rclone".path;
        pruneOpts = [
          "--keep-daily 7"
        ];
        initialize = true;
        timerConfig.OnCalendar = "*-*-* *:00:00";
        timerConfig.RandomizedDelaySec = "5m";
        extraBackupArgs = [
          "--exclude=\".direnv\""
          "--exclude=\".terraform\""
          "--exclude=\"node_modules/*\""
        ];
      };
    };

    environment.systemPackages = with pkgs; [
      restic
      rclone
    ];

    services.vector.settings.sources.journald.include_units = [ "restic-backups-homelab" ];
  };
}
