{ constants, ... }:

{
  home.file = {
    ".ssh/id_github.pub".text = constants.sshKeys.personal;
    ".config/tlrc/config.toml".text = ''
      [cache]
      auto_update = true
      max_age = 336 # 336 hours = 2 weeks
    '';
  };
}
