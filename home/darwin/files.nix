{ user, config, pkgs, lib, constants, ... }:

let
  ghosttyCursorShaders = pkgs.fetchFromGitHub {
    owner = "sahaj-b";
    repo = "ghostty-cursor-shaders";
    rev = "main";
    sha256 = "sha256-ruhEqXnWRCYdX5mRczpY3rj1DTdxyY3BoN9pdlDOKrE=";
  };
in
{
  ".ssh/id_work.pub" = {
    text = constants.sshKeys.work;
  };

  ".ssh/id_work_gitlab.pub" = {
    text = constants.sshKeys.workGitlab;
  };

  ".config/ghostty" = {
    source = ../config/ghostty;
    recursive = true;
  };

  ".config/ghostty/shaders" = {
    source = ghosttyCursorShaders;
    recursive = true;
  };

  ".config/revdiff/config" = {
    source = ../config/revdiff/config;
  };

  ".config/revdiff/themes/kanagawa" = {
    source = ../config/revdiff/themes/kanagawa;
  };
}
