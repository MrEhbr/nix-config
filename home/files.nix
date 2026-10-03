{ config, lib, constants, ... }:

{
  options.my.work.enable = lib.mkEnableOption "work git/ssh settings and public keys";

  config.home.file = lib.mkMerge [
    {
      ".ssh/id_github.pub" = {
        text = constants.sshKeys.personal;
      };
      ".config/tlrc/config.toml".text = ''
        [cache]
        auto_update = true
        max_age = 336 # 336 hours = 2 weeks
      '';
    }

    (lib.mkIf config.my.work.enable {
      ".ssh/id_work.pub".text = constants.sshKeys.work;
      ".ssh/id_work_gitlab.pub".text = constants.sshKeys.workGitlab;
    })
  ];
}
