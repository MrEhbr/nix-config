{
  config,
  lib,
  constants,
  ...
}:
let
  home = config.home.homeDirectory;
in
{
  options.my.work.enable = lib.mkEnableOption "work git/ssh settings and public keys";

  config = lib.mkIf config.my.work.enable {
    home.file = {
      ".ssh/id_work.pub".text = constants.sshKeys.work;
      ".ssh/id_work_gitlab.pub".text = constants.sshKeys.workGitlab;
    };

    programs.git = {
      includes = [
        {
          path = "${home}/Work/.gitconfig";
          condition = "gitdir:${home}/Work/";
        }
      ];
      settings.url."git@gitlab.mobbtech.com:".insteadOf = "https://gitlab.mobbtech.com/";
    };

    programs.ssh.settings."gitlab.mobbtech.com" = {
      IdentitiesOnly = true;
      IdentityFile = [ "${home}/.ssh/id_work_gitlab" ];
    };
  };
}
