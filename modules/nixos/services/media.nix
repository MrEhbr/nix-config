{ config, pkgs, lib, ... }:
let
  user = "media";
  group = "storage";
  mediaDir = "/media";
in
{
  # Create the directories that the services will need with the correct permissions
  systemd.tmpfiles.rules = [
    "L /mnt/storage/media - - - - ${mediaDir}"
    "d ${mediaDir}/library/Movies 2775 ${user} ${group} -"
    "d ${mediaDir}/library/Cartoons 2775 ${user} ${group} -"
    "d ${mediaDir}/library/Shows 2775 ${user} ${group} -"
    "d ${mediaDir}/library/Doramas 2775 ${user} ${group} -"
    "d ${mediaDir}/library/Anime 2775 ${user} ${group} -"
    "d ${mediaDir}/library/AnimeMovies 2775 ${user} ${group} -"
    "d ${mediaDir}/torrents 2775 ${user} ${group} -"
    "d ${mediaDir}/torrents/.incomplete 2775 ${user} ${group} -"
    "d ${mediaDir}/services/radarr 2775 ${user} ${group} -"
    "d ${mediaDir}/services/sonarr 2775 ${user} ${group} -"
    "d ${mediaDir}/services/jellyfin 2775 ${user} ${group} -"
    "d ${mediaDir}/services/jellyfin/data 2775 ${user} ${group} -"
    "d ${mediaDir}/services/jellyfin/log 2775 ${user} ${group} -"
    "d ${mediaDir}/services/jellyfin/cache 2775 ${user} ${group} -"
  ];

  users.users =
    {
      ${user} = {
        isSystemUser = true;
        group = "${group}";
      };
    };

  services.transmission = {
    enable = true;
    package = pkgs.transmission_4;
    downloadDirPermissions = "0770";
    openPeerPorts = true;
    user = user;
    group = group;
    settings = {
      incomplete-dir-enabled = true;
      download-dir = "${mediaDir}/torrents";
      incomplete-dir = "${mediaDir}/torrents/.incomplete";
      watch-dir-enabled = false;
      rpc-whitelist = "127.0.0.1,192.168.*.*";
      rpc-host-whitelist = "*";
      rpc-host-whitelist-enabled = true;
      ratio-limit = 0;
      ratio-limit-enabled = true;
      download-queue-enabled = false;
      seed-queue-enabled = false;
      utp-enabled = true;
      # NOTE: This mask needs to be specified in base 10 instead of octal.
      umask = 7; # 0o007 == 7
      cache-size-mb = 1024;
      peer-limit-per-torrent = 250;
      peer-limit-global = 10000;
    };
  };

  # TODO: Override for this issue:
  # https://github.com/NixOs/nixpkgs/issues/258793
  # As of 2024-07-18, still not fixed, despite that issue being closed.
  systemd.services.transmission.serviceConfig = {
    RootDirectoryStartOnly = lib.mkForce false;
    RootDirectory = lib.mkForce "";
  };
  # Always prioritize other services wrt. I/O
  systemd.services.transmission.serviceConfig.IOSchedulingPriority = 7;

  services.prowlarr = {
    enable = true;
  };

  services.radarr = {
    enable = true;
    user = user;
    group = group;
    dataDir = "${mediaDir}/services/radarr";
  };

  services.sonarr = {
    enable = true;
    user = user;
    group = group;
    dataDir = "${mediaDir}/services/sonarr";
  };

  services.jellyfin = {
    enable = true;
    user = user;
    group = group;
    dataDir = "${mediaDir}/services/jellyfin/data";
    logDir = "${mediaDir}/services/jellyfin/log";
    configDir = "${mediaDir}/services/jellyfin";
    cacheDir = "${mediaDir}/services/jellyfin/cache";
  };

  services.restic.backups.homelab.paths = [
    "/var/lib/prowlarr"
    config.services.jellyfin.dataDir
    config.services.jellyfin.configDir
    config.services.sonarr.dataDir
    config.services.radarr.dataDir
  ];
}
