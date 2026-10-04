{
  config,
  lib,
  homelab,
  ...
}:

let
  cfg = config.services.yokoku;
  url = homelab.url "yokoku";
  root = kind: dir: {
    inherit kind;
    path = "/media/library/${dir}";
  };
in
{
  options.my.services.yokoku.enable = lib.mkEnableOption "yokoku";

  config = lib.mkIf config.my.services.yokoku.enable {
    services.yokoku = {
      enable = true;
      user = "media";
      group = "storage";
      settings = {
        web.port = 7171;
        clock.timezone = config.time.timeZone;
        transmission.url = "http://127.0.0.1:9091/transmission/rpc";
        jellyfin.url = "http://127.0.0.1:8096";
        naming = {
          series_folder = "{title}";
          episode_file = "{episodes}[ - {episode_title}]";
        };
        roots =
          map (root "series") [
            "Shows"
            "Anime"
            "Doramas"
            "CartoonShows"
          ]
          ++ map (root "movies") [
            "Movies"
            "AnimeMovies"
            "Cartoons"
          ];
      };
    };

    services.restic.backups = lib.mkIf config.my.services.restic.enable {
      homelab.paths = [ cfg.dataDir ];
    };

    my.nginx.vhosts = {
      yokoku = cfg.settings.web.port;
    };

    services.gatus.settings.endpoints = [
      (homelab.endpoint {
        name = "Yokoku";
        group = "Media";
        inherit url;
      })
    ];

    my.homepage.services."Media" = [
      {
        Yokoku = {
          icon = "mdi-movie-open-outline";
          href = url;
          description = "Library manager";
        };
      }
    ];

    services.vector.settings.sources.journald.include_units = [ "yokoku" ];
  };
}
