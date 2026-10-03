{ config, lib, constants, ... }:
{
  options.my.work.enable = lib.mkEnableOption "work git/ssh settings and public keys";

  config = lib.mkIf config.my.work.enable {
    home.file = {
      ".ssh/id_work.pub".text = constants.sshKeys.work;
      ".ssh/id_work_gitlab.pub".text = constants.sshKeys.workGitlab;
    };
  };
}
