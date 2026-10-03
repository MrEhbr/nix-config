{
  config,
  pkgs,
  lib,
  ...
}:

{
  options.my.programs.direnv.enable = lib.mkEnableOption "direnv";

  config = lib.mkIf config.my.programs.direnv.enable {
    programs.direnv = {
      enable = true;
      package = pkgs.direnv.overrideAttrs (_: {
        doCheck = false;
      });
      silent = true;
      nix-direnv.enable = true;
      config = {
        global = {
          warn_timeout = "5m";
          log_format = "-";
        };
      };
      stdlib = ''
        declare -A direnv_layout_dirs
          direnv_layout_dir() {
            echo "''${direnv_layout_dirs[$PWD]:=$(
            echo -n "${config.xdg.cacheHome}"/direnv/layouts/
            echo -n "$PWD" | shasum | cut -d ' ' -f 1
          )}"
        }
      '';
    };
  };
}
