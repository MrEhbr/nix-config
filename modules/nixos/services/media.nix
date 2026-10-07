{
  config,
  pkgs,
  lib,
  homelab,
  ...
}:
let
  inherit (homelab) url;
  user = "media";
  group = "storage";
  mediaDir = "/media";
in
{
  options.my.services.media.enable = lib.mkEnableOption "media";

  config = lib.mkIf config.my.services.media.enable {
    # Create the directories that the services will need with the correct permissions
    systemd.tmpfiles.rules = [
      "L ${mediaDir} - - - - /mnt/storage/media"
      "d ${mediaDir}/library/Movies 2775 ${user} ${group} -"
      "d ${mediaDir}/library/Cartoons 2775 ${user} ${group} -"
      "d ${mediaDir}/library/Shows 2775 ${user} ${group} -"
      "d ${mediaDir}/library/Doramas 2775 ${user} ${group} -"
      "d ${mediaDir}/library/Anime 2775 ${user} ${group} -"
      "d ${mediaDir}/library/AnimeMovies 2775 ${user} ${group} -"
      "d ${mediaDir}/torrents 2775 ${user} ${group} -"
      "d ${mediaDir}/torrents/.incomplete 2775 ${user} ${group} -"
      "d ${mediaDir}/services/jellyfin 2775 ${user} ${group} -"
      "d ${mediaDir}/services/jellyfin/data 2775 ${user} ${group} -"
      "d ${mediaDir}/services/jellyfin/log 2775 ${user} ${group} -"
      "d ${mediaDir}/services/jellyfin/cache 2775 ${user} ${group} -"
    ];

    users.users = {
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
      inherit user group;
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

    services.jackett = {
      enable = true;
    };

    services.flaresolverr = {
      enable = true;
    };

    services.jellyfin = {
      enable = true;
      inherit user group;
      dataDir = "${mediaDir}/services/jellyfin/data";
      logDir = "${mediaDir}/services/jellyfin/log";
      configDir = "${mediaDir}/services/jellyfin";
      cacheDir = "${mediaDir}/services/jellyfin/cache";
    };

    services.restic.backups = lib.mkIf config.my.services.restic.enable {
      homelab.paths = [
        config.services.jackett.dataDir
        config.services.jellyfin.dataDir
        config.services.jellyfin.configDir
      ];
    };

    my.nginx.vhosts = {
      transmission = 9091;
      jellyfin = 8096;
      jackett = 9117;
    };

    services.gatus.settings.endpoints = map homelab.endpoint [
      {
        name = "Jellyfin";
        group = "Media";
        url = "${url "jellyfin"}/health";
      }
      {
        name = "Jackett";
        group = "Media";
        url = url "jackett";
      }
      {
        name = "Transmission";
        group = "Downloaders";
        url = url "transmission";
        conditions = [
          "[STATUS] == 200"
          "[RESPONSE_TIME] < 2000"
        ];
      }
    ];

    my.homepage.services."Downloaders" = [
      {
        Transmission = {
          icon = "transmission";
          href = url "transmission";
          description = "Torrent client";
          widget = {
            type = "transmission";
            url = url "transmission";
          };
        };
      }
    ];

    my.homepage.services."Media" = [
      {
        Jellyfin = {
          icon = "jellyfin";
          href = url "jellyfin";
          description = "Media server";
          widget = {
            type = "jellyfin";
            url = url "jellyfin";
            key = "{{HOMEPAGE_VAR_JELLYFIN_API_KEY}}";
            enableBlocks = true;
            enableNowPlaying = false;
          };
        };
      }
      {
        Jackett = {
          icon = "jackett";
          href = url "jackett";
          description = "Indexers";
          widget = {
            type = "jackett";
            url = url "jackett";
            password = "{{HOMEPAGE_VAR_JACKETT_PASSWORD}}";
          };
        };
      }
    ];

    services.vector.settings.sources.journald.include_units = [
      "jellyfin"
      "jackett"
      "flaresolverr"
      "transmission"
    ];
  };
}
