{ config, lib, pkgs, ... }:
let
  ghosttyCursorShaders = pkgs.fetchFromGitHub {
    owner = "sahaj-b";
    repo = "ghostty-cursor-shaders";
    rev = "main";
    sha256 = "sha256-ruhEqXnWRCYdX5mRczpY3rj1DTdxyY3BoN9pdlDOKrE=";
  };
in
{
  options.my.programs.ghostty.enable = lib.mkEnableOption "ghostty config";

  config = lib.mkIf config.my.programs.ghostty.enable {
    home.file = {
      ".config/ghostty" = {
        source = ../config/ghostty;
        recursive = true;
      };

      ".config/ghostty/shaders" = {
        source = ghosttyCursorShaders;
        recursive = true;
      };
    };
  };
}
