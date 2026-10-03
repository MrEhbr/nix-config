{ config, lib, ... }:
{
  options.my.programs.revdiff.enable = lib.mkEnableOption "revdiff config";

  config = lib.mkIf config.my.programs.revdiff.enable {
    home.file = {
      ".config/revdiff/config".source = ../config/revdiff/config;
      ".config/revdiff/themes/kanagawa".source = ../config/revdiff/themes/kanagawa;
    };
  };
}
